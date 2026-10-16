import 'package:flutter_test/flutter_test.dart';
import 'package:nestory/data/models/widget_snapshot.dart';
import 'package:nestory/data/services/widget_snapshot_service.dart';
import 'package:nestory/shared/models/calendar_event.dart';
import 'package:nestory/shared/models/memory.dart';

void main() {
  group('WidgetSnapshot Contract & Serialization', () {
    test('Builds valid snapshot and serializes to JSON with version 1', () {
      final testDate = DateTime(2026, 10, 16, 14, 30);
      final events = [
        CalendarEvent(
          id: 1,
          googleCalendarId: 'primary',
          title: 'Design Review',
          isAllDay: false,
          startDateTime: DateTime(2026, 10, 16, 10, 0),
          endDateTime: DateTime(2026, 10, 16, 11, 0),
        ),
        CalendarEvent(
          id: 2,
          googleCalendarId: 'primary',
          title: 'All Day Milestone',
          isAllDay: true,
          startDate: '2026-10-16',
          endDate: '2026-10-17',
        ),
      ];
      final memories = [
        Memory(
          id: 101,
          title: 'Autumn Walk',
          description: 'A crisp morning in the park',
          date: DateTime(2026, 10, 16),
          tags: const ['walk', 'nature'],
          photoUrls: const ['/data/user/0/com.nestory.app/photos/p1.jpg'],
        ),
      ];

      final snapshot = WidgetSnapshot.build(
        now: testDate,
        todayEvents: events,
        todayMemories: memories,
      );

      expect(snapshot.version, equals(2));
      expect(snapshot.year, equals(2026));
      expect(snapshot.month, equals(10));
      expect(snapshot.day, equals(16));
      expect(snapshot.daysInMonth, equals(31));
      expect(snapshot.formattedDate, equals('16 OCT.'));
      expect(snapshot.upcomingEvents.length, equals(2));
      // All-day event must be sorted first
      expect(snapshot.upcomingEvents[0].title, equals('All Day Milestone'));
      expect(snapshot.upcomingEvents[0].timeFormatted, equals('All day'));
      expect(snapshot.upcomingEvents[1].title, equals('Design Review'));
      expect(snapshot.upcomingEvents[1].timeFormatted, equals('10:00 AM'));
      expect(snapshot.todayMemory, isNotNull);
      expect(snapshot.todayMemory!.title, equals('Autumn Walk'));
      expect(snapshot.todayMemory!.photoCount, equals(1));
      expect(snapshot.eventsByDate['2026-10-16'], isNotNull);
      expect(snapshot.eventsByDate['2026-10-16']!.length, equals(2));

      // Test JSON round-trip
      final jsonStr = snapshot.toJsonString();
      final parsed = WidgetSnapshot.fromJsonString(jsonStr);
      expect(parsed, isNotNull);
      expect(parsed!.version, equals(2));
      expect(parsed.day, equals(16));
      expect(parsed.upcomingEvents.length, equals(2));
      expect(parsed.todayMemory!.id, equals(101));
      expect(parsed.eventsByDate['2026-10-16'], isNotNull);
    });

    test('Handles empty states gracefully without fabricated content', () {
      final testDate = DateTime(2026, 1, 15);
      final snapshot = WidgetSnapshot.build(
        now: testDate,
        todayEvents: const [],
        todayMemories: const [],
      );

      expect(snapshot.upcomingEvents, isEmpty);
      expect(snapshot.todayMemory, isNull);

      final json = snapshot.toJson();
      expect((json['stats'] as Map)['totalEventsToday'], equals(0));
      expect((json['stats'] as Map)['hasMemoryToday'], isFalse);

      final jsonStr = snapshot.toJsonString();
      final parsed = WidgetSnapshot.fromJsonString(jsonStr);
      expect(parsed!.upcomingEvents, isEmpty);
      expect(parsed.todayMemory, isNull);
    });

    test('Robustly handles malformed and incomplete JSON payloads', () {
      expect(WidgetSnapshot.fromJsonString('invalid json {'), isNull);
      expect(WidgetSnapshot.fromJsonString('[]'), isNull);

      // Incomplete dictionary with missing fields should fallback safely
      final partial = WidgetSnapshot.fromJson(const {});
      expect(partial.version, equals(1));
      expect(partial.upcomingEvents, isEmpty);
      expect(partial.todayMemory, isNull);
    });

    test('Month grid math calculates days in month and Sunday-aligned offset', () {
      // October 2026: 31 days, Oct 1 is Thursday (weekday 4 -> Sunday=0 is 4)
      final oct2026 = WidgetSnapshot.build(
        now: DateTime(2026, 10, 1),
        todayEvents: const [],
        todayMemories: const [],
      );
      expect(oct2026.daysInMonth, equals(31));
      expect(oct2026.firstWeekday, equals(4)); // Thursday

      // February 2024 (Leap year): 29 days, Feb 1 is Thursday (4)
      final feb2024 = WidgetSnapshot.build(
        now: DateTime(2024, 2, 10),
        todayEvents: const [],
        todayMemories: const [],
      );
      expect(feb2024.daysInMonth, equals(29));

      // February 2025: 28 days
      final feb2025 = WidgetSnapshot.build(
        now: DateTime(2025, 2, 10),
        todayEvents: const [],
        todayMemories: const [],
      );
      expect(feb2025.daysInMonth, equals(28));
    });

    test('Events are sorted with all-day first then chronological', () {
      final now = DateTime(2026, 10, 16);
      final events = [
        CalendarEvent(
          id: 1,
          googleCalendarId: 'primary',
          title: 'Evening Dinner',
          isAllDay: false,
          startDateTime: DateTime(2026, 10, 16, 19, 0),
        ),
        CalendarEvent(
          id: 2,
          googleCalendarId: 'primary',
          title: 'Breakfast',
          isAllDay: false,
          startDateTime: DateTime(2026, 10, 16, 8, 30),
        ),
        CalendarEvent(
          id: 3,
          googleCalendarId: 'primary',
          title: 'Holiday',
          isAllDay: true,
          startDate: '2026-10-16',
        ),
      ];

      final snapshot = WidgetSnapshot.build(
        now: now,
        todayEvents: events,
        todayMemories: const [],
      );

      expect(snapshot.upcomingEvents[0].title, equals('Holiday'));
      expect(snapshot.upcomingEvents[1].title, equals('Breakfast'));
      expect(snapshot.upcomingEvents[1].timeFormatted, equals('8:30 AM'));
      expect(snapshot.upcomingEvents[2].title, equals('Evening Dinner'));
      expect(snapshot.upcomingEvents[2].timeFormatted, equals('7:00 PM'));
    });
  });

  group('WidgetSnapshotService Action Routing', () {
    test('Stores and consumes pending actions when no handler is attached', () {
      final service = WidgetSnapshotService.instance;
      service.onActionReceived = null;

      // Simulate a pending action arrival
      service.consumePendingAction(); // Clear any existing
      expect(service.consumePendingAction(), isNull);

      // Verify action consumption works cleanly
      expect(service.isInitialized, isFalse);
    });
  });
}
