import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

import '../db/calendar/calendar_database.dart';
import 'google_auth_service.dart';
import 'google_calendar_client.dart';

/// Coordinates synchronization between Google Calendar API and local SQLite cache.
///
/// Implements:
/// - Initial sync with date bounding [timeMin, timeMax].
/// - Incremental delta sync via Google Calendar [syncToken] (without timeMin/timeMax).
/// - HTTP 410 (Gone) recovery via full resynchronization while preserving local outbox.
/// - Outbox mutation processing with base32hex client ID idempotent creation.
/// - Remote verification on HTTP 409 duplicate detection.
/// - Conflict resolution on HTTP 412: preserves server version and records rejected edit in [SyncConflicts].
/// - Remote deletion handling.
class CalendarSyncService extends ChangeNotifier {
  CalendarSyncService._();

  static final CalendarSyncService instance = CalendarSyncService._();

  CalendarDatabase get _db => CalendarDatabase.instance();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String? _syncError;
  int _pendingOutboxCount = 0;

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get syncError => _syncError;
  int get pendingOutboxCount => _pendingOutboxCount;

  void init() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline) {
        triggerOutboxDrain();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void triggerOutboxDrain() {
    if (!_isSyncing && GoogleAuthService.instance.isSignedIn) {
      syncAll();
    }
  }

  /// Synchronizes all enabled Google calendars and flushes the outbox queue.
  Future<void> syncAll({bool isManual = false}) async {
    if (_isSyncing) return;
    if (!GoogleAuthService.instance.isSignedIn) return;

    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final authClient = await GoogleAuthService.instance
          .getAuthenticatedClient();
      if (authClient == null) {
        _syncError = 'Could not establish authenticated connection.';
        return;
      }

      final client = GoogleCalendarClient.fromAuthClient(authClient);
      final accountEmail = GoogleAuthService.instance.userEmail ?? '';

      // 1. Sync Calendar List (discover newly created or modified calendars)
      try {
        final calendarList = await client.listCalendars();
        for (final item in calendarList.items ?? <cal.CalendarListEntry>[]) {
          final calId = item.id;
          if (calId == null) continue;
          await _db.calendarsMetaDao.upsertCalendar(
            accountEmail: accountEmail,
            googleCalendarId: calId,
            summary: item.summary ?? 'Untitled Calendar',
            description: item.description ?? '',
            colorHex: item.backgroundColor,
            isPrimary: item.primary ?? false,
            accessRole: item.accessRole,
          );
        }
      } catch (e) {
        debugPrint('[CalendarSyncService] Calendar list refresh error: $e');
      }

      // 2. Sync Events for Each Selected Calendar
      final selectedCalendars = await _db.calendarsMetaDao
          .getSelectedCalendars();
      for (final calMeta in selectedCalendars) {
        await _syncCalendarEvents(client, calMeta);
      }

      // 3. Flush the Outbox Queue (Offline mutations)
      await _drainOutbox(client);

      _lastSyncTime = DateTime.now();
      await _db.calendarAccountsDao.updateLastSyncTime(
        accountEmail,
        _lastSyncTime!,
      );
    } catch (e) {
      debugPrint('[CalendarSyncService] Synchronization error: $e');
      _syncError = e.toString();
    } finally {
      _pendingOutboxCount = await _db.calendarOutboxDao.countPending();
      _isSyncing = false;
      notifyListeners();
    }
  }

  @visibleForTesting
  Future<void> syncCalendarEventsForTesting(
    GoogleCalendarClient client,
    CalendarMetaEntity calMeta,
  ) => _syncCalendarEvents(client, calMeta);

  @visibleForTesting
  Future<void> drainOutboxForTesting(GoogleCalendarClient client) =>
      _drainOutbox(client);

  /// Synchronizes events for a single calendar using syncToken delta sync.
  Future<void> _syncCalendarEvents(
    GoogleCalendarClient client,
    CalendarMetaEntity calMeta,
  ) async {
    final calendarId = calMeta.googleCalendarId;
    var syncToken = calMeta.syncToken;

    try {
      await _fetchAndApplyEvents(client, calendarId, syncToken: syncToken);
    } on cal.DetailedApiRequestError catch (e) {
      if (e.status == 410) {
        // HTTP 410 Gone: Sync token has expired.
        // Recovery: Clear token, perform full resync, preserve local outbox.
        debugPrint(
          '[CalendarSyncService] Sync token expired (410) for $calendarId. Performing full resync.',
        );
        await _db.calendarsMetaDao.updateSyncToken(calendarId, null);
        await _fetchAndApplyEvents(client, calendarId, syncToken: null);
      } else {
        rethrow;
      }
    }
  }

  String? _formatDateOnly(DateTime? d) {
    if (d == null) return null;
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  DateTime? _parseDateOnly(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split('-').map(int.parse).toList();
    return DateTime.utc(parts[0], parts[1], parts[2]);
  }

  /// Fetches event pages from Google and writes them into SQLite.
  Future<void> _fetchAndApplyEvents(
    GoogleCalendarClient client,
    String calendarId, {
    String? syncToken,
  }) async {
    String? pageToken;
    String? nextSyncToken;
    final isDeltaSync = syncToken != null && syncToken.isNotEmpty;

    // Window for full initial sync: 2 years back to 2 years forward
    final now = DateTime.now();
    final timeMin = isDeltaSync ? null : DateTime(now.year - 2, 1, 1);
    final timeMax = isDeltaSync ? null : DateTime(now.year + 2, 12, 31);

    do {
      final eventsPage = await client.listEvents(
        calendarId,
        syncToken: syncToken,
        timeMin: timeMin,
        timeMax: timeMax,
        pageToken: pageToken,
      );

      nextSyncToken = eventsPage.nextSyncToken;
      pageToken = eventsPage.nextPageToken;

      for (final item in eventsPage.items ?? <cal.Event>[]) {
        final eventId = item.id;
        if (eventId == null) continue;

        if (item.status == 'cancelled') {
          // Remote deletion
          await _db.calendarEventsDao.deleteEventByGoogleId(eventId);
          continue;
        }

        final isAllDay = item.start?.date != null;
        final startDate = _formatDateOnly(item.start?.date);
        final endDate = _formatDateOnly(item.end?.date);
        final startDateTime = item.start?.dateTime?.toUtc();
        final endDateTime = item.end?.dateTime?.toUtc();
        final timeZone = item.start?.timeZone ?? 'UTC';

        final existing = await _db.calendarEventsDao.getEventByGoogleId(
          eventId,
        );
        if (existing == null) {
          await _db.calendarEventsDao.insertEvent(
            CalendarEventsCompanion.insert(
              googleEventId: Value(eventId),
              googleCalendarId: calendarId,
              title: item.summary ?? '(No title)',
              description: Value(item.description ?? ''),
              location: Value(item.location ?? ''),
              isAllDay: Value(isAllDay),
              startDate: Value(startDate),
              endDate: Value(endDate),
              startDateTime: Value(startDateTime),
              endDateTime: Value(endDateTime),
              timeZone: Value(timeZone),
              recurrenceRule: Value(item.recurrence?.join('\n')),
              recurringEventId: Value(item.recurringEventId),
              syncStatus: const Value('synced'),
              remoteETag: Value(item.etag),
            ),
          );
        } else {
          // If this event has a pending local modification, handle potential conflict
          if (existing.syncStatus == 'pendingUpdate' &&
              existing.remoteETag != item.etag) {
            final outboxEntry = await _db.calendarOutboxDao.getByMutationId(
              existing.clientMutationId ?? '',
            );
            if (outboxEntry != null) {
              await _db.syncConflictsDao.insertConflict(
                SyncConflictsCompanion.insert(
                  googleEventId: eventId,
                  googleCalendarId: calendarId,
                  eventTitle: item.summary ?? existing.title,
                  localPayloadJson: outboxEntry.payloadJson,
                  remotePayloadJson: jsonEncode({
                    'summary': item.summary,
                    'description': item.description,
                    'start':
                        item.start?.date ??
                        item.start?.dateTime?.toIso8601String(),
                    'end':
                        item.end?.date ?? item.end?.dateTime?.toIso8601String(),
                  }),
                ),
              );
              await _db.calendarOutboxDao.remove(outboxEntry.id);
            }
          }

          // Authoritative server update
          await _db.calendarEventsDao.updateEvent(
            existing.id,
            CalendarEventsCompanion(
              title: Value(item.summary ?? '(No title)'),
              description: Value(item.description ?? ''),
              location: Value(item.location ?? ''),
              isAllDay: Value(isAllDay),
              startDate: Value(startDate),
              endDate: Value(endDate),
              startDateTime: Value(startDateTime),
              endDateTime: Value(endDateTime),
              timeZone: Value(timeZone),
              recurrenceRule: Value(item.recurrence?.join('\n')),
              recurringEventId: Value(item.recurringEventId),
              syncStatus: const Value('synced'),
              remoteETag: Value(item.etag),
              lastModified: Value(DateTime.now()),
            ),
          );
        }
      }
    } while (pageToken != null && pageToken.isNotEmpty);

    // Save fresh sync token only after all pages are safely persisted
    if (nextSyncToken != null && nextSyncToken.isNotEmpty) {
      await _db.calendarsMetaDao.updateSyncToken(calendarId, nextSyncToken);
    }
  }

  /// Flushes pending offline outbox operations to Google Calendar.
  Future<void> _drainOutbox(GoogleCalendarClient client) async {
    final mutations = await _db.calendarOutboxDao.getPendingMutations();

    for (final mutation in mutations) {
      try {
        final payload =
            jsonDecode(mutation.payloadJson) as Map<String, dynamic>;

        switch (mutation.actionType) {
          case 'create':
            await _processCreateMutation(client, mutation, payload);
            break;
          case 'update':
            await _processUpdateMutation(client, mutation, payload);
            break;
          case 'delete':
            await _processDeleteMutation(client, mutation, payload);
            break;
        }
      } catch (e) {
        debugPrint('[CalendarSyncService] Mutation execution error: $e');
        await _db.calendarOutboxDao.recordFailure(mutation.id, e.toString());
      }
    }
  }

  Future<void> _processCreateMutation(
    GoogleCalendarClient client,
    CalendarOutboxEntity mutation,
    Map<String, dynamic> payload,
  ) async {
    final isAllDay = payload['isAllDay'] as bool? ?? false;
    final googleEvent = cal.Event(
      id: mutation.googleEventId,
      summary: payload['title'] as String,
      description: payload['description'] as String?,
      location: payload['location'] as String?,
      extendedProperties: cal.EventExtendedProperties(
        private: {'clientMutationId': mutation.clientMutationId},
      ),
    );

    if (isAllDay) {
      googleEvent.start = cal.EventDateTime(
        date: _parseDateOnly(payload['startDate'] as String?),
      );
      googleEvent.end = cal.EventDateTime(
        date: _parseDateOnly(payload['endDate'] as String?),
      );
    } else {
      googleEvent.start = cal.EventDateTime(
        dateTime: DateTime.parse(payload['startDateTime'] as String),
      );
      googleEvent.end = cal.EventDateTime(
        dateTime: DateTime.parse(payload['endDateTime'] as String),
      );
    }

    try {
      final created = await client.insertEvent(
        mutation.googleCalendarId,
        googleEvent,
      );
      // Success: update local cache and drop outbox row
      if (mutation.localEventId != null) {
        await _db.calendarEventsDao.updateEvent(
          mutation.localEventId!,
          CalendarEventsCompanion(
            googleEventId: Value(created.id),
            syncStatus: const Value('synced'),
            remoteETag: Value(created.etag),
            lastModified: Value(DateTime.now()),
          ),
        );
      }
      await _db.calendarOutboxDao.remove(mutation.id);
    } on cal.DetailedApiRequestError catch (e) {
      if (e.status == 409 && mutation.googleEventId != null) {
        // HTTP 409 Conflict: Verify existing event before marking success
        final existing = await client.getEvent(
          mutation.googleCalendarId,
          mutation.googleEventId!,
        );
        final matchesMutationId =
            existing?.extendedProperties?.private?['clientMutationId'] ==
            mutation.clientMutationId;
        final matchesContent = existing?.summary == payload['title'];

        if (matchesMutationId || matchesContent) {
          // Confirmed: Previous attempt succeeded before connection dropped
          if (mutation.localEventId != null) {
            await _db.calendarEventsDao.updateEvent(
              mutation.localEventId!,
              CalendarEventsCompanion(
                syncStatus: const Value('synced'),
                remoteETag: Value(existing?.etag),
                lastModified: Value(DateTime.now()),
              ),
            );
          }
          await _db.calendarOutboxDao.remove(mutation.id);
        } else {
          // True ID collision with an unrelated remote event
          await _db.calendarOutboxDao.recordFailure(
            mutation.id,
            'Collision: Event ID already exists on Google Calendar with different content.',
          );
        }
      } else {
        rethrow;
      }
    }
  }

  Future<void> _processUpdateMutation(
    GoogleCalendarClient client,
    CalendarOutboxEntity mutation,
    Map<String, dynamic> payload,
  ) async {
    final googleEventId = mutation.googleEventId;
    if (googleEventId == null) return;

    final isAllDay = payload['isAllDay'] as bool? ?? false;
    final patch = cal.Event(
      summary: payload['title'] as String,
      description: payload['description'] as String?,
      location: payload['location'] as String?,
    );

    if (isAllDay) {
      patch.start = cal.EventDateTime(
        date: _parseDateOnly(payload['startDate'] as String?),
      );
      patch.end = cal.EventDateTime(
        date: _parseDateOnly(payload['endDate'] as String?),
      );
    } else {
      patch.start = cal.EventDateTime(
        dateTime: DateTime.parse(payload['startDateTime'] as String),
      );
      patch.end = cal.EventDateTime(
        dateTime: DateTime.parse(payload['endDateTime'] as String),
      );
    }

    try {
      final updated = await client.patchEvent(
        mutation.googleCalendarId,
        googleEventId,
        patch,
      );
      if (mutation.localEventId != null) {
        await _db.calendarEventsDao.updateEvent(
          mutation.localEventId!,
          CalendarEventsCompanion(
            syncStatus: const Value('synced'),
            remoteETag: Value(updated.etag),
            lastModified: Value(DateTime.now()),
          ),
        );
      }
      await _db.calendarOutboxDao.remove(mutation.id);
    } on cal.DetailedApiRequestError catch (e) {
      if (e.status == 412) {
        // Precondition Failed: Event changed remotely while offline
        final remote = await client.getEvent(
          mutation.googleCalendarId,
          googleEventId,
        );
        await _db.syncConflictsDao.insertConflict(
          SyncConflictsCompanion.insert(
            googleEventId: googleEventId,
            googleCalendarId: mutation.googleCalendarId,
            eventTitle: payload['title'] as String? ?? 'Conflicted Event',
            localPayloadJson: mutation.payloadJson,
            remotePayloadJson: jsonEncode(remote?.toJson() ?? {}),
          ),
        );
        // Retain authoritative server version and remove outbox row
        await _db.calendarOutboxDao.remove(mutation.id);
      } else if (e.status == 404) {
        // Remote event was deleted
        if (mutation.localEventId != null) {
          await _db.calendarEventsDao.deleteEvent(mutation.localEventId!);
        }
        await _db.calendarOutboxDao.remove(mutation.id);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _processDeleteMutation(
    GoogleCalendarClient client,
    CalendarOutboxEntity mutation,
    Map<String, dynamic> payload,
  ) async {
    final googleEventId = mutation.googleEventId;
    if (googleEventId == null) {
      if (mutation.localEventId != null) {
        await _db.calendarEventsDao.deleteEvent(mutation.localEventId!);
      }
      await _db.calendarOutboxDao.remove(mutation.id);
      return;
    }

    try {
      await client.deleteEvent(mutation.googleCalendarId, googleEventId);
      if (mutation.localEventId != null) {
        await _db.calendarEventsDao.deleteEvent(mutation.localEventId!);
      }
      await _db.calendarOutboxDao.remove(mutation.id);
    } on cal.DetailedApiRequestError catch (e) {
      // 404 (already deleted) or 410 (already gone) is considered successful deletion
      if (e.status == 404 || e.status == 410) {
        if (mutation.localEventId != null) {
          await _db.calendarEventsDao.deleteEvent(mutation.localEventId!);
        }
        await _db.calendarOutboxDao.remove(mutation.id);
      } else {
        rethrow;
      }
    }
  }
}
