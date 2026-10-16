import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestory/data/db/calendar/calendar_database.dart';
import 'package:nestory/data/repositories/calendar_event_repository.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CalendarDatabase db;

  setUp(() {
    db = CalendarDatabase.forTesting(NativeDatabase.memory());
    CalendarDatabase.setInstanceForTesting(db);
  });

  tearDown(() async {
    await db.close();
    CalendarDatabase.setInstanceForTesting(null);
  });

  group('Calendar Database Schema & DAOs', () {
    test(
      'CalendarAccountsDao: upsert, query, and clear account metadata',
      () async {
        await db.calendarAccountsDao.upsertAccount(
          email: 'developer@nestory.app',
          displayName: 'Nestory Dev',
          photoUrl: 'https://nestory.app/avatar.png',
        );

        final account = await db.calendarAccountsDao.getPrimaryAccount();
        expect(account, isNotNull);
        expect(account!.email, 'developer@nestory.app');
        expect(account.displayName, 'Nestory Dev');

        // Update sync time
        final now = DateTime.now().toUtc();
        await db.calendarAccountsDao.updateLastSyncTime(account.email, now);
        final updated = await db.calendarAccountsDao.getPrimaryAccount();
        expect(updated!.lastSyncTime, isNotNull);

        // Clear accounts on disconnect
        await db.calendarAccountsDao.deleteAllAccounts();
        expect(await db.calendarAccountsDao.getPrimaryAccount(), isNull);
      },
    );

    test(
      'CalendarsMetaDao: upsert, selection toggling, and retrieval',
      () async {
        await db.calendarAccountsDao.upsertAccount(
          email: 'developer@nestory.app',
          displayName: 'Nestory Dev',
        );

        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'developer@nestory.app',
          googleCalendarId: 'primary',
          summary: 'Personal',
          description: 'Main personal calendar',
          colorHex: '#0088FF',
          isPrimary: true,
          isSelected: true,
        );

        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'developer@nestory.app',
          googleCalendarId: 'work@company.com',
          summary: 'Work',
          isPrimary: false,
          isSelected: false,
        );

        final calendars = await db.calendarsMetaDao.getAllCalendars();
        expect(calendars.length, 2);

        final primary = await db.calendarsMetaDao.getCalendarById('primary');
        expect(primary, isNotNull);
        expect(primary!.googleCalendarId, 'primary');
        expect(primary.isPrimary, isTrue);

        // Toggle selection
        await db.calendarsMetaDao.setCalendarSelected('work@company.com', true);
        final updatedCalendars = await db.calendarsMetaDao.getAllCalendars();
        final workCal = updatedCalendars.firstWhere(
          (c) => c.googleCalendarId == 'work@company.com',
        );
        expect(workCal.isSelected, isTrue);
      },
    );

    test('CalendarEventsDao: insert, query, and deletion', () async {
      final insertId = await db.calendarEventsDao.insertEvent(
        CalendarEventsCompanion.insert(
          googleEventId: const Value('evt_101'),
          googleCalendarId: 'primary',
          title: 'Sprint Planning',
          description: const Value('Review backlog and set sprint goals'),
          location: const Value('Room 304'),
          isAllDay: const Value(false),
          startDateTime: Value(DateTime.utc(2026, 10, 14, 9, 0)),
          endDateTime: Value(DateTime.utc(2026, 10, 14, 10, 0)),
          timeZone: const Value('UTC'),
          syncStatus: const Value('synced'),
        ),
      );
      expect(insertId, isPositive);

      final events = await db.calendarEventsDao.getAllEvents();
      expect(events.length, 1);
      expect(events.first.title, 'Sprint Planning');
      expect(events.first.syncStatus, 'synced');

      // Update event by Google ID
      await db.calendarEventsDao.updateEventByGoogleId(
        'evt_101',
        const CalendarEventsCompanion(
          title: Value('Sprint Planning (Rescheduled)'),
        ),
      );

      final updatedEvents = await db.calendarEventsDao.getAllEvents();
      expect(updatedEvents.length, 1);
      expect(updatedEvents.first.title, 'Sprint Planning (Rescheduled)');

      // Delete event
      await db.calendarEventsDao.deleteEventByGoogleId('evt_101');
      expect(await db.calendarEventsDao.getAllEvents(), isEmpty);
    });

    test(
      'CalendarOutboxDao: enqueue mutation, FIFO ordering, mark failure, and remove',
      () async {
        final id1 = await db.calendarOutboxDao.enqueue(
          CalendarOutboxCompanion.insert(
            clientMutationId: 'mut_001',
            actionType: 'create',
            googleCalendarId: 'primary',
            googleEventId: const Value('temp_001'),
            payloadJson: jsonEncode({'title': 'Coffee with Alex'}),
          ),
        );

        final id2 = await db.calendarOutboxDao.enqueue(
          CalendarOutboxCompanion.insert(
            clientMutationId: 'mut_002',
            actionType: 'update',
            googleCalendarId: 'primary',
            googleEventId: const Value('temp_001'),
            payloadJson: jsonEncode({'title': 'Coffee with Alex & Sam'}),
          ),
        );

        final pending = await db.calendarOutboxDao.getPendingMutations();
        expect(pending.length, 2);
        expect(pending[0].id, id1);
        expect(pending[0].clientMutationId, 'mut_001');
        expect(pending[1].id, id2);
        expect(pending[1].clientMutationId, 'mut_002');

        // Mark first action failure
        await db.calendarOutboxDao.recordFailure(
          id1,
          'HTTP 503 Service Unavailable',
        );
        final afterFail = await db.calendarOutboxDao.getPendingMutations();
        expect(afterFail[0].retryCount, 1);
        expect(afterFail[0].lastError, 'HTTP 503 Service Unavailable');

        // Remove action on success
        await db.calendarOutboxDao.remove(id1);
        final remaining = await db.calendarOutboxDao.getPendingMutations();
        expect(remaining.length, 1);
        expect(remaining[0].id, id2);
      },
    );

    test(
      'SyncConflictsDao: insert conflict, query active, and dismiss',
      () async {
        final conflictId = await db.syncConflictsDao.insertConflict(
          SyncConflictsCompanion.insert(
            googleCalendarId: 'primary',
            googleEventId: 'evt_conflict_1',
            eventTitle: 'Design Review',
            localPayloadJson: jsonEncode({'title': 'Design Review V2'}),
            remotePayloadJson: jsonEncode({'title': 'Design Review Remote'}),
            conflictReason: const Value(
              'HTTP 412 Precondition Failed: ETag mismatch',
            ),
          ),
        );

        final conflicts = await db.syncConflictsDao.getActiveConflicts();
        expect(conflicts.length, 1);
        expect(conflicts.first.eventTitle, 'Design Review');
        expect(conflicts.first.isDismissed, isFalse);

        await db.syncConflictsDao.dismissConflict(conflictId);
        final afterDismissed = await db.syncConflictsDao.getActiveConflicts();
        expect(afterDismissed, isEmpty);
      },
    );
  });

  group('Outbox Persistence Across Database Reopens', () {
    test(
      'Pending outbox mutations survive database close and reopen without data loss',
      () async {
        final tempDir = await Directory.systemTemp.createTemp(
          'nestory_db_reopen_',
        );
        final dbFile = File(p.join(tempDir.path, 'calendar_cache.sqlite'));

        try {
          // Open file-backed database
          var fileDb = CalendarDatabase.forTesting(NativeDatabase(dbFile));
          await fileDb.calendarOutboxDao.enqueue(
            CalendarOutboxCompanion.insert(
              clientMutationId: 'mut_persistent_777',
              actionType: 'create',
              googleCalendarId: 'primary',
              googleEventId: const Value('evt_client_777'),
              payloadJson: jsonEncode({
                'title': 'Offline Strategy Meeting',
                'startDate': '2026-10-20',
                'endDate': '2026-10-21',
                'isAllDay': true,
              }),
            ),
          );

          // Verify it was persisted
          var actions = await fileDb.calendarOutboxDao.getPendingMutations();
          expect(actions.length, 1);
          expect(actions.first.clientMutationId, 'mut_persistent_777');

          // Close connection cleanly (simulating app process termination)
          await fileDb.close();

          // Reopen new connection to the same file
          fileDb = CalendarDatabase.forTesting(NativeDatabase(dbFile));
          actions = await fileDb.calendarOutboxDao.getPendingMutations();

          expect(actions.length, 1);
          final restored = actions.first;
          expect(restored.clientMutationId, 'mut_persistent_777');
          expect(restored.actionType, 'create');
          expect(restored.googleEventId, 'evt_client_777');

          final payload =
              jsonDecode(restored.payloadJson) as Map<String, dynamic>;
          expect(payload['title'], 'Offline Strategy Meeting');
          expect(payload['startDate'], '2026-10-20');
          expect(payload['endDate'], '2026-10-21');
          expect(payload['isAllDay'], true);

          await fileDb.close();
        } finally {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        }
      },
    );
  });

  group('CalendarEventRepository Filter and Reactive State', () {
    test(
      'Repository filters out events from deselected calendars and maintains reactive cache',
      () async {
        await db.calendarAccountsDao.upsertAccount(
          email: 'developer@nestory.app',
          displayName: 'Nestory Dev',
        );

        // Set up two calendars: primary (selected) and work (unselected)
        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'developer@nestory.app',
          googleCalendarId: 'primary',
          summary: 'Personal',
          isSelected: true,
        );
        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'developer@nestory.app',
          googleCalendarId: 'work@corp.com',
          summary: 'Work',
          isSelected: false,
        );

        // Insert event on primary
        await db.calendarEventsDao.insertEvent(
          CalendarEventsCompanion.insert(
            googleEventId: const Value('evt_personal'),
            googleCalendarId: 'primary',
            title: 'Grocery Run',
            isAllDay: const Value(true),
            startDate: const Value('2026-10-15'),
            endDate: const Value('2026-10-16'),
          ),
        );

        // Insert event on work calendar
        await db.calendarEventsDao.insertEvent(
          CalendarEventsCompanion.insert(
            googleEventId: const Value('evt_work'),
            googleCalendarId: 'work@corp.com',
            title: 'Team Standup',
            isAllDay: const Value(true),
            startDate: const Value('2026-10-15'),
            endDate: const Value('2026-10-16'),
          ),
        );

        final repo = CalendarEventRepository.instance;
        await repo.reload();

        // Only the selected calendar's events must appear
        expect(repo.all.length, 1);
        expect(repo.all.first.title, 'Grocery Run');

        // onDate check
        final dayEvents = repo.onDate(DateTime(2026, 10, 15));
        expect(dayEvents.length, 1);
        expect(dayEvents.first.title, 'Grocery Run');

        // Now enable the work calendar and reload
        await db.calendarsMetaDao.setCalendarSelected('work@corp.com', true);
        await repo.reload();

        expect(repo.all.length, 2);
        expect(
          repo.all.map((e) => e.title),
          containsAll(['Grocery Run', 'Team Standup']),
        );
      },
    );

    test(
      'create queues outbox mutation and adds event to SQLite cache immediately',
      () async {
        await db.calendarAccountsDao.upsertAccount(
          email: 'developer@nestory.app',
          displayName: 'Nestory Dev',
        );

        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'developer@nestory.app',
          googleCalendarId: 'primary',
          summary: 'Personal',
          isSelected: true,
        );

        final repo = CalendarEventRepository.instance;
        await repo.reload();

        final createdEvent = await repo.create(
          googleCalendarId: 'primary',
          title: 'Dentist Appointment',
          isAllDay: false,
          startDateTime: DateTime.utc(2026, 10, 18, 14, 0),
          endDateTime: DateTime.utc(2026, 10, 18, 15, 0),
          location: 'Dental Clinic Suite 2',
          description: 'Annual cleaning',
        );

        expect(createdEvent.title, 'Dentist Appointment');
        expect(createdEvent.syncStatus, 'pendingCreate');

        // Verify immediate presence in repository cache
        expect(repo.hasEventsOn(DateTime(2026, 10, 18)), isTrue);
        expect(
          repo.onDate(DateTime(2026, 10, 18)).first.title,
          'Dentist Appointment',
        );

        // Verify outbox entry was written
        final outbox = await db.calendarOutboxDao.getPendingMutations();
        expect(outbox.length, 1);
        expect(outbox.first.actionType, 'create');
        expect(outbox.first.googleCalendarId, 'primary');
        expect(outbox.first.googleEventId, createdEvent.googleEventId);
      },
    );

    test(
      'Offline events with primary ID remain visible after Google accounts sync email-based calendar IDs',
      () async {
        final repo = CalendarEventRepository.instance;

        // 1. User creates event offline before any calendars exist
        final offlineEvent = await repo.create(
          googleCalendarId: 'primary',
          title: 'Offline Doctor Visit',
          isAllDay: false,
          startDateTime: DateTime.utc(2026, 10, 20, 10, 0),
          endDateTime: DateTime.utc(2026, 10, 20, 11, 0),
        );

        expect(repo.onDate(DateTime(2026, 10, 20)).length, 1);
        expect(repo.byId(offlineEvent.id), isNotNull);

        // 2. Google calendar list syncs with user email as calendar ID (NOT 'primary')
        await db.calendarAccountsDao.upsertAccount(
          email: 'dwip@example.com',
          displayName: 'Dwip Pandya',
        );

        await db.calendarsMetaDao.upsertCalendar(
          accountEmail: 'dwip@example.com',
          googleCalendarId: 'dwip@example.com',
          summary: 'dwip@example.com',
          isPrimary: true,
          isSelected: true,
        );

        await repo.reload();

        // 3. The offline event created with 'primary' must NOT be lost or hidden
        final events = repo.onDate(DateTime(2026, 10, 20));
        expect(events.length, 1);
        expect(events.first.title, 'Offline Doctor Visit');
        expect(repo.byId(offlineEvent.id), isNotNull);
      },
    );
  });
}
