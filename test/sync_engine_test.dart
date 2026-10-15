import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:nestory/data/db/calendar/calendar_database.dart';
import 'package:nestory/data/services/calendar_sync_service.dart';
import 'package:nestory/data/services/google_calendar_client.dart';

class _FakeSyncEngineClient implements GoogleCalendarClient {
  _FakeSyncEngineClient({
    this.onListEvents,
    this.onPatchEvent,
    this.onGetEvent,
  });

  Future<cal.Events> Function(
    String calendarId, {
    String? syncToken,
    DateTime? timeMin,
    DateTime? timeMax,
    String? pageToken,
    int maxResults,
  })?
  onListEvents;

  Future<cal.Event> Function(String calendarId, cal.Event event)? onInsertEvent;
  Future<cal.Event> Function(
    String calendarId,
    String eventId,
    cal.Event event,
  )?
  onPatchEvent;
  Future<void> Function(String calendarId, String eventId)? onDeleteEvent;
  Future<cal.Event?> Function(String calendarId, String eventId)? onGetEvent;

  @override
  Future<cal.CalendarList> listCalendars() async => cal.CalendarList(items: []);

  @override
  Future<cal.Events> listEvents(
    String calendarId, {
    String? syncToken,
    DateTime? timeMin,
    DateTime? timeMax,
    String? pageToken,
    int maxResults = 250,
  }) {
    if (onListEvents != null) {
      return onListEvents!(
        calendarId,
        syncToken: syncToken,
        timeMin: timeMin,
        timeMax: timeMax,
        pageToken: pageToken,
        maxResults: maxResults,
      );
    }
    return Future.value(cal.Events(items: []));
  }

  @override
  Future<cal.Event> insertEvent(String calendarId, cal.Event event) {
    if (onInsertEvent != null) return onInsertEvent!(calendarId, event);
    return Future.value(event);
  }

  @override
  Future<cal.Event> patchEvent(
    String calendarId,
    String eventId,
    cal.Event event,
  ) {
    if (onPatchEvent != null) return onPatchEvent!(calendarId, eventId, event);
    return Future.value(event);
  }

  @override
  Future<cal.Event?> getEvent(String calendarId, String eventId) {
    if (onGetEvent != null) return onGetEvent!(calendarId, eventId);
    return Future.value(null);
  }

  @override
  Future<void> deleteEvent(String calendarId, String eventId) {
    if (onDeleteEvent != null) return onDeleteEvent!(calendarId, eventId);
    return Future.value();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CalendarDatabase db;

  setUp(() async {
    db = CalendarDatabase.forTesting(NativeDatabase.memory());
    CalendarDatabase.setInstanceForTesting(db);

    // Setup default account
    await db.calendarAccountsDao.upsertAccount(
      email: 'test@nestory.app',
      displayName: 'Nestory Tester',
    );
  });

  tearDown(() async {
    await db.close();
    CalendarDatabase.setInstanceForTesting(null);
  });

  group('CalendarSyncEngine: Initial Sync & Pagination', () {
    test(
      'Initial sync fetches multiple pages and persists final nextSyncToken to database',
      () async {
        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'test@nestory.app',
          googleCalendarId: 'primary',
          summary: 'Primary Calendar',
          isSelected: true,
        );

        final client = _FakeSyncEngineClient(
          onListEvents:
              (
                calId, {
                syncToken,
                timeMin,
                timeMax,
                pageToken,
                maxResults = 250,
              }) async {
                expect(calId, 'primary');
                expect(
                  syncToken,
                  isNull,
                  reason: 'Initial sync must not pass syncToken',
                );
                expect(
                  timeMin,
                  isNotNull,
                  reason: 'Initial sync must specify time bounds',
                );

                if (pageToken == null) {
                  // Page 1
                  return cal.Events(
                    items: [
                      cal.Event(
                        id: 'evt_page1_1',
                        summary: 'Sprint Planning',
                        start: cal.EventDateTime(
                          date: DateTime.utc(2026, 10, 14),
                        ),
                        end: cal.EventDateTime(
                          date: DateTime.utc(2026, 10, 15),
                        ),
                        etag: '"etag1"',
                      ),
                    ],
                    nextPageToken: 'token_page_2',
                  );
                } else if (pageToken == 'token_page_2') {
                  // Page 2
                  return cal.Events(
                    items: [
                      cal.Event(
                        id: 'evt_page2_1',
                        summary: 'Architecture Sync',
                        start: cal.EventDateTime(
                          date: DateTime.utc(2026, 10, 15),
                        ),
                        end: cal.EventDateTime(
                          date: DateTime.utc(2026, 10, 16),
                        ),
                        etag: '"etag2"',
                      ),
                    ],
                    nextSyncToken: 'sync_token_v1',
                  );
                }
                return cal.Events(items: []);
              },
        );

        final calMeta = (await db.calendarsMetaDao.getCalendarById('primary'))!;
        await CalendarSyncService.instance.syncCalendarEventsForTesting(
          client,
          calMeta,
        );

        // Verify both events were saved
        final events = await db.calendarEventsDao.getAllEvents();
        expect(events.length, 2);
        expect(
          events.map((e) => e.googleEventId),
          containsAll(['evt_page1_1', 'evt_page2_1']),
        );

        // Verify sync token was stored
        final updatedCal = await db.calendarsMetaDao.getCalendarById('primary');
        expect(updatedCal!.syncToken, 'sync_token_v1');
      },
    );
  });

  group('CalendarSyncEngine: Incremental Delta Sync & Deletions', () {
    test(
      'Incremental sync uses syncToken without time bounds and processes remote cancellations',
      () async {
        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'test@nestory.app',
          googleCalendarId: 'primary',
          summary: 'Primary Calendar',
          isSelected: true,
        );
        await db.calendarsMetaDao.updateSyncToken('primary', 'sync_token_v1');

        // Pre-populate event in local database
        await db.calendarEventsDao.insertEvent(
          CalendarEventsCompanion.insert(
            googleEventId: const Value('evt_to_delete'),
            googleCalendarId: 'primary',
            title: 'Cancelled Lunch',
            syncStatus: const Value('synced'),
          ),
        );

        final client = _FakeSyncEngineClient(
          onListEvents:
              (
                calId, {
                syncToken,
                timeMin,
                timeMax,
                pageToken,
                maxResults = 250,
              }) async {
                expect(syncToken, 'sync_token_v1');
                expect(
                  timeMin,
                  isNull,
                  reason:
                      'Google Calendar API forbids timeMin when syncToken is provided',
                );
                expect(
                  timeMax,
                  isNull,
                  reason:
                      'Google Calendar API forbids timeMax when syncToken is provided',
                );

                return cal.Events(
                  items: [
                    cal.Event(id: 'evt_to_delete', status: 'cancelled'),
                    cal.Event(
                      id: 'evt_new_delta',
                      summary: 'New Delta Event',
                      start: cal.EventDateTime(
                        date: DateTime.utc(2026, 10, 18),
                      ),
                      end: cal.EventDateTime(date: DateTime.utc(2026, 10, 19)),
                      etag: '"etag_delta"',
                    ),
                  ],
                  nextSyncToken: 'sync_token_v2',
                );
              },
        );

        final calMeta = (await db.calendarsMetaDao.getCalendarById('primary'))!;
        await CalendarSyncService.instance.syncCalendarEventsForTesting(
          client,
          calMeta,
        );

        // Verify cancelled event was deleted locally
        final deletedEvent = await db.calendarEventsDao.getEventByGoogleId(
          'evt_to_delete',
        );
        expect(deletedEvent, isNull);

        // Verify new delta event was inserted
        final newEvent = await db.calendarEventsDao.getEventByGoogleId(
          'evt_new_delta',
        );
        expect(newEvent, isNotNull);
        expect(newEvent!.title, 'New Delta Event');

        // Verify sync token was updated
        final updatedCal = await db.calendarsMetaDao.getCalendarById('primary');
        expect(updatedCal!.syncToken, 'sync_token_v2');
      },
    );
  });

  group('CalendarSyncEngine: HTTP 410 Recovery', () {
    test(
      'HTTP 410 clears invalid syncToken and initiates full resync',
      () async {
        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'test@nestory.app',
          googleCalendarId: 'primary',
          summary: 'Primary Calendar',
          isSelected: true,
        );
        await db.calendarsMetaDao.updateSyncToken('primary', 'expired_token');

        var attempts = 0;
        final client = _FakeSyncEngineClient(
          onListEvents:
              (
                calId, {
                syncToken,
                timeMin,
                timeMax,
                pageToken,
                maxResults = 250,
              }) async {
                attempts++;
                if (attempts == 1) {
                  expect(syncToken, 'expired_token');
                  // First attempt with expired token fails with 410 Gone
                  throw cal.DetailedApiRequestError(
                    410,
                    'Sync token is invalid',
                  );
                } else {
                  // Second attempt must have syncToken cleared
                  expect(syncToken, isNull);
                  expect(timeMin, isNotNull);
                  return cal.Events(
                    items: [
                      cal.Event(
                        id: 'evt_after_410',
                        summary: 'Recovered Event',
                        start: cal.EventDateTime(
                          date: DateTime.utc(2026, 10, 20),
                        ),
                        end: cal.EventDateTime(
                          date: DateTime.utc(2026, 10, 21),
                        ),
                        etag: '"etag_resync"',
                      ),
                    ],
                    nextSyncToken: 'fresh_sync_token',
                  );
                }
              },
        );

        final calMeta = (await db.calendarsMetaDao.getCalendarById('primary'))!;
        await CalendarSyncService.instance.syncCalendarEventsForTesting(
          client,
          calMeta,
        );

        expect(attempts, 2);

        // Token must now be updated to the fresh token
        final updatedCal = await db.calendarsMetaDao.getCalendarById('primary');
        expect(updatedCal!.syncToken, 'fresh_sync_token');

        final event = await db.calendarEventsDao.getEventByGoogleId(
          'evt_after_410',
        );
        expect(event, isNotNull);
      },
    );
  });

  group('CalendarSyncEngine: HTTP 412 Conflict Preservation', () {
    test(
      'HTTP 412 preserves remote server event and saves rejected local edit in SyncConflicts',
      () async {
        const googleEventId = 'evt_shared_conflict';

        final localId = await db.calendarEventsDao.insertEvent(
          CalendarEventsCompanion.insert(
            googleEventId: const Value(googleEventId),
            googleCalendarId: 'primary',
            title: 'Local Modified Title',
            syncStatus: const Value('pendingUpdate'),
            remoteETag: const Value('"old_etag"'),
          ),
        );

        await db.calendarOutboxDao.enqueue(
          CalendarOutboxCompanion.insert(
            clientMutationId: 'mut_conflict_412',
            actionType: 'update',
            localEventId: Value(localId),
            googleCalendarId: 'primary',
            googleEventId: const Value(googleEventId),
            payloadJson: jsonEncode({
              'title': 'Local Modified Title',
              'isAllDay': true,
              'startDate': '2026-10-22',
              'endDate': '2026-10-23',
            }),
          ),
        );

        final client = _FakeSyncEngineClient(
          onPatchEvent: (calId, eventId, event) async {
            // Server rejects update due to outdated ETag
            throw cal.DetailedApiRequestError(
              412,
              'Precondition Failed: ETag mismatch',
            );
          },
          onGetEvent: (calId, eventId) async {
            return cal.Event(
              id: eventId,
              summary: 'Authoritative Remote Title',
              etag: '"server_newer_etag"',
            );
          },
        );

        await CalendarSyncService.instance.drainOutboxForTesting(client);

        // Outbox item must be cleared (not retried in an infinite loop)
        final outbox = await db.calendarOutboxDao.getPendingMutations();
        expect(outbox, isEmpty);

        // A conflict must be recorded in SyncConflicts table
        final conflicts = await db.syncConflictsDao.getActiveConflicts();
        expect(conflicts.length, 1);
        final conflict = conflicts.first;
        expect(conflict.googleEventId, googleEventId);
        expect(conflict.eventTitle, 'Local Modified Title');
        expect(conflict.localPayloadJson, contains('Local Modified Title'));
        expect(
          conflict.remotePayloadJson,
          contains('Authoritative Remote Title'),
        );
      },
    );
  });
}
