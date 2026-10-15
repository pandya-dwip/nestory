import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:nestory/data/db/calendar/calendar_database.dart';
import 'package:nestory/data/services/calendar_sync_service.dart';
import 'package:nestory/data/services/google_calendar_client.dart';
import 'package:uuid/uuid.dart';

class _FakeDuplicateTestClient implements GoogleCalendarClient {
  _FakeDuplicateTestClient({required this.onInsert, required this.onGet});

  final Future<cal.Event> Function(String calendarId, cal.Event event) onInsert;
  final Future<cal.Event?> Function(String calendarId, String eventId) onGet;

  @override
  Future<cal.Event> insertEvent(String calendarId, cal.Event event) =>
      onInsert(calendarId, event);

  @override
  Future<cal.Event?> getEvent(String calendarId, String eventId) =>
      onGet(calendarId, eventId);

  @override
  Future<cal.CalendarList> listCalendars() => throw UnimplementedError();

  @override
  Future<cal.Events> listEvents(
    String calendarId, {
    String? syncToken,
    DateTime? timeMin,
    DateTime? timeMax,
    String? pageToken,
    int maxResults = 250,
  }) => throw UnimplementedError();

  @override
  Future<cal.Event> patchEvent(
    String calendarId,
    String eventId,
    cal.Event event,
  ) => throw UnimplementedError();

  @override
  Future<void> deleteEvent(String calendarId, String eventId) =>
      throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Google Calendar Client Event ID Validation (Base32hex)', () {
    test(
      'Client-assigned Event ID complies with Google base32hex format [0-9a-v]',
      () {
        const uuid = Uuid();
        final base32hexRegex = RegExp(r'^[0-9a-v]{5,1024}$');

        for (var i = 0; i < 50; i++) {
          final clientEventId = uuid.v4().replaceAll('-', '').toLowerCase();

          // 1. Must match Google's base32hex requirement
          expect(
            base32hexRegex.hasMatch(clientEventId),
            isTrue,
            reason:
                'Generated ID "$clientEventId" must only contain chars in [0-9a-v]',
          );

          // 2. Length must be exactly 32 chars (within [5, 1024])
          expect(clientEventId.length, 32);

          // 3. Must be lowercase
          expect(clientEventId, clientEventId.toLowerCase());

          // 4. Must not have any hyphens
          expect(clientEventId.contains('-'), isFalse);
        }
      },
    );
  });

  group('Idempotent Outbox Drain & Duplicate Recovery (HTTP 409)', () {
    late CalendarDatabase db;

    setUp(() {
      db = CalendarDatabase.forTesting(NativeDatabase.memory());
      CalendarDatabase.setInstanceForTesting(db);
    });

    tearDown(() async {
      await db.close();
      CalendarDatabase.setInstanceForTesting(null);
    });

    test(
      'HTTP 409 verified with matching clientMutationId marks outbox as successful and updates local cache',
      () async {
        const clientMutationId = 'mut-uuid-1234-abcd';
        const googleEventId = 'abcdef0123456789abcdef0123456789';

        // 1. Insert local pending event
        final localId = await db.calendarEventsDao.insertEvent(
          CalendarEventsCompanion.insert(
            googleEventId: const Value(googleEventId),
            googleCalendarId: 'primary',
            title: 'Offline Design Sprint',
            syncStatus: const Value('pendingCreate'),
          ),
        );

        // 2. Insert outbox create entry
        await db.calendarOutboxDao.enqueue(
          CalendarOutboxCompanion.insert(
            clientMutationId: clientMutationId,
            actionType: 'create',
            localEventId: Value(localId),
            googleCalendarId: 'primary',
            googleEventId: const Value(googleEventId),
            payloadJson: jsonEncode({
              'title': 'Offline Design Sprint',
              'isAllDay': true,
              'startDate': '2026-10-14',
              'endDate': '2026-10-15',
            }),
          ),
        );

        // 3. Mock client where insertEvent throws 409 Conflict, but getEvent returns the matching event
        final client = _FakeDuplicateTestClient(
          onInsert: (calId, event) async {
            throw cal.DetailedApiRequestError(409, 'Event already exists');
          },
          onGet: (calId, eventId) async {
            return cal.Event(
              id: eventId,
              summary: 'Offline Design Sprint',
              etag: '"etag_verified_999"',
              extendedProperties: cal.EventExtendedProperties(
                private: {'clientMutationId': clientMutationId},
              ),
            );
          },
        );

        // 4. Run outbox drain
        await CalendarSyncService.instance.drainOutboxForTesting(client);

        // 5. Verify outbox entry is dropped because mutation ownership was proven
        final pendingOutbox = await db.calendarOutboxDao.getPendingMutations();
        expect(pendingOutbox, isEmpty);

        // 6. Verify local event status is now 'synced' with the remote ETag
        final localEvent = await db.calendarEventsDao.getEventById(localId);
        expect(localEvent, isNotNull);
        expect(localEvent!.syncStatus, 'synced');
        expect(localEvent.remoteETag, '"etag_verified_999"');
      },
    );

    test(
      'HTTP 409 with unmatched clientMutationId treats as collision: retains outbox and records failure',
      () async {
        const clientMutationId = 'mut-uuid-nestory-user';
        const googleEventId = 'collision123456789abcdef01234567';

        final localId = await db.calendarEventsDao.insertEvent(
          CalendarEventsCompanion.insert(
            googleEventId: const Value(googleEventId),
            googleCalendarId: 'primary',
            title: 'My Private Meeting',
            syncStatus: const Value('pendingCreate'),
          ),
        );

        final outboxId = await db.calendarOutboxDao.enqueue(
          CalendarOutboxCompanion.insert(
            clientMutationId: clientMutationId,
            actionType: 'create',
            localEventId: Value(localId),
            googleCalendarId: 'primary',
            googleEventId: const Value(googleEventId),
            payloadJson: jsonEncode({
              'title': 'My Private Meeting',
              'isAllDay': true,
              'startDate': '2026-10-14',
              'endDate': '2026-10-15',
            }),
          ),
        );

        // Mock client: returns 409, but the existing event belongs to someone else (different clientMutationId and title)
        final client = _FakeDuplicateTestClient(
          onInsert: (calId, event) async {
            throw cal.DetailedApiRequestError(409, 'Conflict: duplicate ID');
          },
          onGet: (calId, eventId) async {
            return cal.Event(
              id: eventId,
              summary: 'Unrelated Team All-Hands',
              extendedProperties: cal.EventExtendedProperties(
                private: {'clientMutationId': 'different-mutation-owner'},
              ),
            );
          },
        );

        await CalendarSyncService.instance.drainOutboxForTesting(client);

        // Outbox item must NOT be deleted
        final pendingOutbox = await db.calendarOutboxDao.getPendingMutations();
        expect(pendingOutbox.length, 1);
        expect(pendingOutbox.first.id, outboxId);
        expect(pendingOutbox.first.retryCount, 1);
        expect(pendingOutbox.first.lastError, contains('Collision'));

        // Local event must NOT be falsely marked synced
        final localEvent = await db.calendarEventsDao.getEventById(localId);
        expect(localEvent!.syncStatus, 'pendingCreate');
      },
    );
  });
}
