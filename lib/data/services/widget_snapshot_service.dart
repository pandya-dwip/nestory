import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/widget_snapshot.dart';
import '../repositories/calendar_event_repository.dart';
import '../repositories/memory_repository.dart';
import 'calendar_sync_service.dart';

/// Coordinates synchronization between Flutter data repositories and the native
/// Android Home-Screen Widget. Delivers durable JSON snapshots via [MethodChannel]
/// to app-private [SharedPreferences] and routes widget click intents into the app.
class WidgetSnapshotService with WidgetsBindingObserver {
  WidgetSnapshotService._();

  static final WidgetSnapshotService instance = WidgetSnapshotService._();

  static const MethodChannel _channel = MethodChannel('com.nestory.app/widget');

  Timer? _debounceTimer;
  bool _initialized = false;

  void Function(String action, DateTime? date)? onActionReceived;
  Map<String, dynamic>? _pendingAction;

  bool get isInitialized => _initialized;

  /// Initializes listeners to repositories and starts observing app lifecycle.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addObserver(this);

    // Wire reactive repository listeners so any DB changes update the widget
    MemoryRepository.instance.addListener(_onDataChanged);
    CalendarEventRepository.instance.addListener(_onDataChanged);
    CalendarSyncService.instance.addListener(_onDataChanged);

    _channel.setMethodCallHandler(_handleNativeMethodCall);

    // Initial snapshot broadcast
    await updateSnapshot();

    // Check if the application was started directly via widget click
    await _checkInitialAction();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MemoryRepository.instance.removeListener(_onDataChanged);
    CalendarEventRepository.instance.removeListener(_onDataChanged);
    CalendarSyncService.instance.removeListener(_onDataChanged);
    _debounceTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Whenever the user returns to the app, ensure the widget snapshot is current
      updateSnapshot();
      _checkInitialAction();
    }
  }

  void _onDataChanged() {
    // Debounce updates by 150ms to batch rapid mutations (e.g. multi-event sync or photo import)
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      updateSnapshot();
    });
  }

  /// Builds a snapshot from the current repository state and delivers it to native Android.
  Future<void> updateSnapshot() async {
    if (!defaultTargetPlatformMatchesAndroid) return;

    try {
      final now = DateTime.now();
      final allEvents = CalendarEventRepository.instance.all;
      final allMemories = MemoryRepository.instance.all;

      final snapshot = WidgetSnapshot.build(
        now: now,
        allEvents: allEvents,
        allMemories: allMemories,
      );

      await _channel.invokeMethod('updateWidgetSnapshot', {
        'snapshotJson': snapshot.toJsonString(),
      });
    } catch (e) {
      debugPrint('[WidgetSnapshotService] Failed to update widget snapshot: $e');
    }
  }

  Future<void> _checkInitialAction() async {
    if (!defaultTargetPlatformMatchesAndroid) return;

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getInitialWidgetAction');
      if (result != null) {
        final action = result['action'] as String?;
        final dateStr = result['date'] as String?;
        if (action != null) {
          final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
          _dispatchAction(action, date);
        }
      }
    } catch (e) {
      debugPrint('[WidgetSnapshotService] Error checking initial widget action: $e');
    }
  }

  Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
    if (call.method == 'onWidgetAction') {
      final args = call.arguments as Map<dynamic, dynamic>? ?? {};
      final action = args['action'] as String?;
      final dateStr = args['date'] as String?;
      if (action != null) {
        final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
        _dispatchAction(action, date);
      }
    }
  }

  void _dispatchAction(String action, DateTime? date) {
    if (onActionReceived != null) {
      onActionReceived!(action, date);
    } else {
      _pendingAction = {'action': action, 'date': date};
    }
  }

  /// Consumes any pending widget action that arrived before the UI was mounted.
  Map<String, dynamic>? consumePendingAction() {
    final action = _pendingAction;
    _pendingAction = null;
    return action;
  }

  @visibleForTesting
  static bool defaultTargetPlatformMatchesAndroid = defaultTargetPlatform == TargetPlatform.android;
}
