import 'package:drift/drift.dart';

import '../calendar_database.dart';
import '../tables/calendar_events_table.dart';

part 'calendar_events_dao.g.dart';

@DriftAccessor(tables: [CalendarEvents])
class CalendarEventsDao extends DatabaseAccessor<CalendarDatabase>
    with _$CalendarEventsDaoMixin {
  CalendarEventsDao(super.db);

  String _formatDateString(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<List<CalendarEventEntity>> getAllEvents() {
    return (select(calendarEvents)
          ..where((e) => e.syncStatus.isNotValue('pendingDelete'))
          ..orderBy([
            (e) => OrderingTerm.asc(e.isAllDay),
            (e) => OrderingTerm.asc(e.startDate),
            (e) => OrderingTerm.asc(e.startDateTime),
          ]))
        .get();
  }

  Future<CalendarEventEntity?> getEventById(int id) {
    return (select(
      calendarEvents,
    )..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Future<CalendarEventEntity?> getEventByGoogleId(String googleEventId) {
    return (select(
      calendarEvents,
    )..where((e) => e.googleEventId.equals(googleEventId))).getSingleOrNull();
  }

  Future<CalendarEventEntity?> getEventByMutationId(String clientMutationId) {
    return (select(calendarEvents)
          ..where((e) => e.clientMutationId.equals(clientMutationId)))
        .getSingleOrNull();
  }

  /// Retrieves events occurring on [date] across enabled [calendarIds].
  ///
  /// For all-day events, applies Google's half-open interval `[startDate, endDate)`:
  /// `startDate <= dateString AND endDate > dateString`.
  ///
  /// For timed events, checks overlap with the UTC day window:
  /// `startDateTime < dayEnd AND endDateTime >= dayStart`.
  Future<List<CalendarEventEntity>> getEventsOnDate(
    DateTime date, {
    List<String>? calendarIds,
  }) {
    final dateString = _formatDateString(date);
    final dayStart = DateTime.utc(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final query = select(calendarEvents)
      ..where((e) {
        final notDeleted = e.syncStatus.isNotValue('pendingDelete');
        final calendarFilter = (calendarIds != null && calendarIds.isNotEmpty)
            ? (e.googleCalendarId.isIn(calendarIds) |
                e.googleCalendarId.equals('primary'))
            : const Constant(true);

        final isAllDayMatch =
            e.isAllDay.equals(true) &
            e.startDate.isSmallerOrEqualValue(dateString) &
            e.endDate.isBiggerThanValue(dateString);

        final isTimedMatch =
            e.isAllDay.equals(false) &
            e.startDateTime.isSmallerThanValue(dayEnd) &
            e.endDateTime.isBiggerOrEqualValue(dayStart);

        return notDeleted & calendarFilter & (isAllDayMatch | isTimedMatch);
      });

    query.orderBy([
      (e) => OrderingTerm.desc(e.isAllDay),
      (e) => OrderingTerm.asc(e.startDateTime),
      (e) => OrderingTerm.asc(e.title),
    ]);

    return query.get();
  }

  Future<int> insertEvent(CalendarEventsCompanion entry) {
    return into(calendarEvents).insert(entry);
  }

  Future<void> updateEvent(int id, CalendarEventsCompanion entry) {
    return (update(calendarEvents)..where((e) => e.id.equals(id))).write(entry);
  }

  Future<void> updateEventByGoogleId(
    String googleEventId,
    CalendarEventsCompanion entry,
  ) {
    return (update(
      calendarEvents,
    )..where((e) => e.googleEventId.equals(googleEventId))).write(entry);
  }

  Future<int> deleteEvent(int id) {
    return (delete(calendarEvents)..where((e) => e.id.equals(id))).go();
  }

  Future<int> deleteEventByGoogleId(String googleEventId) {
    return (delete(
      calendarEvents,
    )..where((e) => e.googleEventId.equals(googleEventId))).go();
  }

  Future<int> markEventPendingDelete(int id) {
    return (update(calendarEvents)..where((e) => e.id.equals(id))).write(
      CalendarEventsCompanion(
        syncStatus: const Value('pendingDelete'),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> markEventPendingDeleteByGoogleId(String googleEventId) {
    return (update(
      calendarEvents,
    )..where((e) => e.googleEventId.equals(googleEventId))).write(
      CalendarEventsCompanion(
        syncStatus: const Value('pendingDelete'),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteEventsForCalendar(String googleCalendarId) {
    return (delete(
      calendarEvents,
    )..where((e) => e.googleCalendarId.equals(googleCalendarId))).go();
  }

  Future<int> deleteAllEvents() {
    return delete(calendarEvents).go();
  }
}
