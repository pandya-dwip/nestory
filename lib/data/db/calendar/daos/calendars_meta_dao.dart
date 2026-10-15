import 'package:drift/drift.dart';

import '../calendar_database.dart';
import '../tables/calendars_meta_table.dart';

part 'calendars_meta_dao.g.dart';

@DriftAccessor(tables: [CalendarsMeta])
class CalendarsMetaDao extends DatabaseAccessor<CalendarDatabase>
    with _$CalendarsMetaDaoMixin {
  CalendarsMetaDao(super.db);

  Future<List<CalendarMetaEntity>> getAllCalendars() {
    return (select(
      calendarsMeta,
    )..orderBy([(c) => OrderingTerm.asc(c.summary)])).get();
  }

  Future<List<CalendarMetaEntity>> getSelectedCalendars() {
    return (select(calendarsMeta)
          ..where((c) => c.isSelected.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.summary)]))
        .get();
  }

  Future<List<String>> getSelectedCalendarIds() async {
    final rows = await getSelectedCalendars();
    return rows.map((r) => r.googleCalendarId).toList();
  }

  Future<CalendarMetaEntity?> getCalendarById(String googleCalendarId) {
    return (select(calendarsMeta)
          ..where((c) => c.googleCalendarId.equals(googleCalendarId)))
        .getSingleOrNull();
  }

  Future<void> upsertCalendar({
    required String accountEmail,
    required String googleCalendarId,
    required String summary,
    String description = '',
    String? colorHex,
    bool isPrimary = false,
    bool? isSelected,
    String? accessRole,
  }) async {
    final existing =
        await (select(calendarsMeta)..where(
              (c) =>
                  c.accountEmail.equals(accountEmail) &
                  c.googleCalendarId.equals(googleCalendarId),
            ))
            .getSingleOrNull();

    if (existing == null) {
      await into(calendarsMeta).insert(
        CalendarsMetaCompanion.insert(
          accountEmail: accountEmail,
          googleCalendarId: googleCalendarId,
          summary: summary,
          description: Value(description),
          colorHex: Value(colorHex),
          isPrimary: Value(isPrimary),
          isSelected: Value(
            isSelected ?? isPrimary,
          ), // Primary calendar selected by default
          accessRole: Value(accessRole ?? 'owner'),
        ),
      );
    } else {
      await (update(
        calendarsMeta,
      )..where((c) => c.id.equals(existing.id))).write(
        CalendarsMetaCompanion(
          summary: Value(summary),
          description: Value(description),
          colorHex: Value(colorHex),
          isPrimary: Value(isPrimary),
          isSelected: isSelected == null
              ? const Value.absent()
              : Value(isSelected),
          accessRole: accessRole == null
              ? const Value.absent()
              : Value(accessRole),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> setCalendarSelected(String googleCalendarId, bool isSelected) {
    return (update(
      calendarsMeta,
    )..where((c) => c.googleCalendarId.equals(googleCalendarId))).write(
      CalendarsMetaCompanion(
        isSelected: Value(isSelected),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateSyncToken(String googleCalendarId, String? syncToken) {
    return (update(
      calendarsMeta,
    )..where((c) => c.googleCalendarId.equals(googleCalendarId))).write(
      CalendarsMetaCompanion(
        syncToken: Value(syncToken),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<String?> getSyncToken(String googleCalendarId) async {
    final row = await getCalendarById(googleCalendarId);
    return row?.syncToken;
  }

  Future<int> deleteCalendarsForAccount(String accountEmail) {
    return (delete(
      calendarsMeta,
    )..where((c) => c.accountEmail.equals(accountEmail))).go();
  }

  Future<int> deleteAllCalendars() {
    return delete(calendarsMeta).go();
  }
}
