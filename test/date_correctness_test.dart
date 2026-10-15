import 'package:flutter_test/flutter_test.dart';
import 'package:nestory/shared/models/calendar_event.dart';

void main() {
  group('All-Day Event Date Semantics [startDate, endDate)', () {
    test(
      'Single-day all-day event appears only on its date and not on the exclusive end date',
      () {
        const event = CalendarEvent(
          id: 1,
          googleCalendarId: 'primary',
          title: 'Founder Meeting',
          isAllDay: true,
          startDate: '2026-10-14',
          endDate:
              '2026-10-15', // Exclusive end date (+1 day per Google standard)
        );

        // October 14: Must match
        expect(event.occursOn(DateTime(2026, 10, 14)), isTrue);

        // October 13: Must not match
        expect(event.occursOn(DateTime(2026, 10, 13)), isFalse);

        // October 15 (exclusive end date): Must NOT match
        expect(event.occursOn(DateTime(2026, 10, 15)), isFalse);
      },
    );

    test(
      'Multi-day all-day event covers all intermediate days up to but excluding endDate',
      () {
        const event = CalendarEvent(
          id: 2,
          googleCalendarId: 'primary',
          title: 'Design Retreat',
          isAllDay: true,
          startDate: '2026-10-14',
          endDate: '2026-10-17', // Exclusive end date: covers 14, 15, 16
        );

        expect(event.occursOn(DateTime(2026, 10, 13)), isFalse);
        expect(event.occursOn(DateTime(2026, 10, 14)), isTrue);
        expect(event.occursOn(DateTime(2026, 10, 15)), isTrue);
        expect(event.occursOn(DateTime(2026, 10, 16)), isTrue);
        // October 17 is the exclusive boundary
        expect(event.occursOn(DateTime(2026, 10, 17)), isFalse);
        expect(event.occursOn(DateTime(2026, 10, 18)), isFalse);
      },
    );

    test(
      'Month boundary transition works correctly without off-by-one errors',
      () {
        const event = CalendarEvent(
          id: 3,
          googleCalendarId: 'primary',
          title: 'Month-End Hackathon',
          isAllDay: true,
          startDate: '2026-10-31',
          endDate: '2026-11-02', // Covers Oct 31 and Nov 1, excludes Nov 2
        );

        expect(event.occursOn(DateTime(2026, 10, 30)), isFalse);
        expect(event.occursOn(DateTime(2026, 10, 31)), isTrue);
        expect(event.occursOn(DateTime(2026, 11, 1)), isTrue);
        expect(event.occursOn(DateTime(2026, 11, 2)), isFalse);
      },
    );
  });

  group('Timed Event Date Semantics & Time Zones', () {
    test(
      'Timed event correctly identifies day occurrence based on local time conversion',
      () {
        // 10:00 AM to 11:30 AM local
        final start = DateTime(2026, 10, 14, 10, 0).toUtc();
        final end = DateTime(2026, 10, 14, 11, 30).toUtc();

        final event = CalendarEvent(
          id: 4,
          googleCalendarId: 'primary',
          title: 'Architecture Review',
          isAllDay: false,
          startDateTime: start,
          endDateTime: end,
          timeZone: 'UTC',
        );

        expect(event.occursOn(DateTime(2026, 10, 14)), isTrue);
        expect(event.occursOn(DateTime(2026, 10, 13)), isFalse);
        expect(event.occursOn(DateTime(2026, 10, 15)), isFalse);
        expect(event.formatTimeRange(), contains('10:00 AM'));
        expect(event.formatTimeRange(), contains('11:30 AM'));
      },
    );

    test('Timed event spanning midnight appears on both days', () {
      // 11:00 PM on Oct 14 to 02:00 AM on Oct 15 local
      final start = DateTime(2026, 10, 14, 23, 0).toUtc();
      final end = DateTime(2026, 10, 15, 2, 0).toUtc();

      final event = CalendarEvent(
        id: 5,
        googleCalendarId: 'primary',
        title: 'Midnight Launch',
        isAllDay: false,
        startDateTime: start,
        endDateTime: end,
        timeZone: 'UTC',
      );

      expect(event.occursOn(DateTime(2026, 10, 14)), isTrue);
      expect(event.occursOn(DateTime(2026, 10, 15)), isTrue);
      expect(event.occursOn(DateTime(2026, 10, 16)), isFalse);
    });
  });
}
