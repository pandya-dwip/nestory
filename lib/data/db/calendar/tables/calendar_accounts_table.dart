import 'package:drift/drift.dart';

/// Connected Google Account metadata. Exactly one active account in MVP,
/// with the table structured to support multi-account in the future.
@DataClassName('CalendarAccountEntity')
class CalendarAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get email => text().unique()();

  TextColumn get displayName => text().withDefault(const Constant(''))();

  TextColumn get photoUrl => text().nullable()();

  BoolColumn get needsReauth => boolean().withDefault(const Constant(false))();

  DateTimeColumn get lastSyncTime => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
