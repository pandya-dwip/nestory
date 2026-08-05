import 'package:drift/drift.dart';

/// The single owner profile. Exactly one row (id `1`) ever exists — enforced
/// by the DAO always upserting that fixed id rather than by a DB constraint.
@DataClassName('ProfileEntity')
class Profile extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withDefault(const Constant(''))();

  TextColumn get photoPath => text().nullable()();

  TextColumn get about => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
