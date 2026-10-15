import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../shared/models/calendar_event.dart';
import '../db/calendar/calendar_database.dart';
import '../services/calendar_sync_service.dart';

/// Single source of truth for Google Calendar events in the presentation layer.
///
/// Follows Nestory's existing [ChangeNotifier] singleton pattern (matching
/// [MemoryRepository]). Maintains an in-memory cache of hydrated [CalendarEvent]
/// models, rebuilt from [CalendarDatabase] after every read/mutation.
class CalendarEventRepository extends ChangeNotifier {
  CalendarEventRepository._();

  static final CalendarEventRepository instance = CalendarEventRepository._();

  CalendarDatabase get _db => CalendarDatabase.instance();
  static const _uuid = Uuid();

  List<CalendarEvent> _events = const [];
  Map<String, CalendarMetaEntity> _calendarsById = const {};
  bool _ready = false;

  bool get isReady => _ready;
  List<CalendarEvent> get all => _events;

  Future<void> init() async {
    if (_ready) return;
    await reload();
    _ready = true;
  }

  /// Re-fetches all events and calendar metadata from SQLite.
  Future<void> reload() async {
    final calendars = await _db.calendarsMetaDao.getAllCalendars();
    _calendarsById = {for (final c in calendars) c.googleCalendarId: c};

    final selectedCalendarIds = calendars
        .where((c) => c.isSelected)
        .map((c) => c.googleCalendarId)
        .toSet();

    final rows = await _db.calendarEventsDao.getAllEvents();

    _events = [
      for (final row in rows)
        if (selectedCalendarIds.isEmpty ||
            selectedCalendarIds.contains(row.googleCalendarId))
          CalendarEvent(
            id: row.id,
            googleEventId: row.googleEventId,
            googleCalendarId: row.googleCalendarId,
            title: row.title,
            description: row.description,
            location: row.location,
            isAllDay: row.isAllDay,
            startDate: row.startDate,
            endDate: row.endDate,
            startDateTime: row.startDateTime,
            endDateTime: row.endDateTime,
            timeZone: row.timeZone,
            syncStatus: row.syncStatus,
            remoteETag: row.remoteETag,
            calendarSummary: _calendarsById[row.googleCalendarId]?.summary,
            calendarColorHex: _calendarsById[row.googleCalendarId]?.colorHex,
          ),
    ];

    notifyListeners();
  }

  /// Synchronous day query matching [MemoryRepository.onDate].
  List<CalendarEvent> onDate(DateTime date) {
    return _events.where((e) => e.occursOn(date)).toList();
  }

  bool hasEventsOn(DateTime date) {
    return _events.any((e) => e.occursOn(date));
  }

  CalendarEvent? byId(int id) {
    for (final e in _events) {
      if (e.id == id) return e;
    }
    return null;
  }

  CalendarEvent? byGoogleId(String googleEventId) {
    for (final e in _events) {
      if (e.googleEventId == googleEventId) return e;
    }
    return null;
  }

  // ---- Offline-First CRUD ---------------------------------------------------

  /// Creates a new calendar event locally and enqueues it in the persistent outbox.
  ///
  /// Generates a base32hex client ID formatted as unhyphenated UUID v4 to ensure
  /// idempotent creation on Google Calendar and avoid duplicate events.
  Future<CalendarEvent> create({
    required String title,
    required String googleCalendarId,
    String description = '',
    String location = '',
    bool isAllDay = false,
    String? startDate,
    String? endDate,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String timeZone = 'UTC',
  }) async {
    final clientMutationId = _uuid.v4();
    final clientEventId = _uuid.v4().replaceAll('-', '').toLowerCase();

    final payload = {
      'title': title,
      'description': description,
      'location': location,
      'isAllDay': isAllDay,
      'startDate': startDate,
      'endDate': endDate,
      'startDateTime': startDateTime?.toUtc().toIso8601String(),
      'endDateTime': endDateTime?.toUtc().toIso8601String(),
      'timeZone': timeZone,
      'clientMutationId': clientMutationId,
    };

    final id = await _db.transaction(() async {
      final localId = await _db.calendarEventsDao.insertEvent(
        CalendarEventsCompanion.insert(
          googleEventId: Value(clientEventId),
          googleCalendarId: googleCalendarId,
          title: title,
          description: Value(description),
          location: Value(location),
          isAllDay: Value(isAllDay),
          startDate: Value(startDate),
          endDate: Value(endDate),
          startDateTime: Value(startDateTime?.toUtc()),
          endDateTime: Value(endDateTime?.toUtc()),
          timeZone: Value(timeZone),
          syncStatus: const Value('pendingCreate'),
          clientMutationId: Value(clientMutationId),
        ),
      );

      await _db.calendarOutboxDao.enqueue(
        CalendarOutboxCompanion.insert(
          clientMutationId: clientMutationId,
          actionType: 'create',
          localEventId: Value(localId),
          googleEventId: Value(clientEventId),
          googleCalendarId: googleCalendarId,
          payloadJson: jsonEncode(payload),
        ),
      );

      return localId;
    });

    await reload();

    // Trigger asynchronous outbox drain in background without blocking UI
    CalendarSyncService.instance.triggerOutboxDrain();

    return byId(id)!;
  }

  /// Updates an existing calendar event locally and enqueues the mutation.
  Future<void> update({
    required int id,
    required String title,
    String description = '',
    String location = '',
    bool isAllDay = false,
    String? startDate,
    String? endDate,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String timeZone = 'UTC',
  }) async {
    final existing = byId(id);
    if (existing == null) return;

    final clientMutationId = _uuid.v4();
    final payload = {
      'title': title,
      'description': description,
      'location': location,
      'isAllDay': isAllDay,
      'startDate': startDate,
      'endDate': endDate,
      'startDateTime': startDateTime?.toUtc().toIso8601String(),
      'endDateTime': endDateTime?.toUtc().toIso8601String(),
      'timeZone': timeZone,
      'clientMutationId': clientMutationId,
    };

    await _db.transaction(() async {
      await _db.calendarEventsDao.updateEvent(
        id,
        CalendarEventsCompanion(
          title: Value(title),
          description: Value(description),
          location: Value(location),
          isAllDay: Value(isAllDay),
          startDate: Value(startDate),
          endDate: Value(endDate),
          startDateTime: Value(startDateTime?.toUtc()),
          endDateTime: Value(endDateTime?.toUtc()),
          timeZone: Value(timeZone),
          syncStatus: const Value('pendingUpdate'),
          clientMutationId: Value(clientMutationId),
          lastModified: Value(DateTime.now()),
        ),
      );

      await _db.calendarOutboxDao.enqueue(
        CalendarOutboxCompanion.insert(
          clientMutationId: clientMutationId,
          actionType: 'update',
          localEventId: Value(id),
          googleEventId: Value(existing.googleEventId),
          googleCalendarId: existing.googleCalendarId,
          payloadJson: jsonEncode(payload),
          remoteETag: Value(existing.remoteETag),
        ),
      );
    });

    await reload();
    CalendarSyncService.instance.triggerOutboxDrain();
  }

  /// Deletes an event.
  /// If the event was created offline and not yet pushed, it is removed immediately.
  /// If it exists remotely, it is marked as `pendingDelete` (hidden from UI) and enqueued.
  Future<void> delete(int id) async {
    final existing = byId(id);
    if (existing == null) return;

    await _db.transaction(() async {
      if (existing.syncStatus == 'pendingCreate' &&
          existing.googleEventId == null) {
        await _db.calendarEventsDao.deleteEvent(id);
        if (existing.googleEventId != null) {
          await _db.calendarOutboxDao.removeByGoogleEventId(
            existing.googleEventId!,
          );
        }
      } else {
        await _db.calendarEventsDao.markEventPendingDelete(id);
        final clientMutationId = _uuid.v4();
        await _db.calendarOutboxDao.enqueue(
          CalendarOutboxCompanion.insert(
            clientMutationId: clientMutationId,
            actionType: 'delete',
            localEventId: Value(id),
            googleEventId: Value(existing.googleEventId),
            googleCalendarId: existing.googleCalendarId,
            payloadJson: jsonEncode({
              'id': id,
              'googleEventId': existing.googleEventId,
            }),
          ),
        );
      }
    });

    await reload();
    CalendarSyncService.instance.triggerOutboxDrain();
  }

  /// Clears all cached Google Calendar events (e.g. during account disconnect).
  Future<void> clearAll() async {
    await _db.transaction(() async {
      await _db.calendarEventsDao.deleteAllEvents();
      await _db.calendarOutboxDao.clearAll();
      await _db.calendarsMetaDao.deleteAllCalendars();
      await _db.calendarAccountsDao.deleteAllAccounts();
    });
    await reload();
  }
}
