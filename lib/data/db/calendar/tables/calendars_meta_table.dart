import 'package:drift/drift.dart';

import 'calendar_accounts_table.dart';

/// Available Google Calendars associated with an account (Primary, Work, etc.),
/// with selection flags determining whether events are displayed and synced.
@DataClassName('CalendarMetaEntity')
class CalendarsMeta extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get accountEmail => text().references(
    CalendarAccounts,
    #email,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get googleCalendarId => text()();

  TextColumn get summary => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get colorHex => text().nullable()();

  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  BoolColumn get isSelected => boolean().withDefault(const Constant(true))();

  TextColumn get syncToken => text().nullable()();

  TextColumn get accessRole => text().withDefault(const Constant('owner'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {accountEmail, googleCalendarId},
  ];
}
