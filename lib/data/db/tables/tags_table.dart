import 'package:drift/drift.dart';

/// A tag, unique by name regardless of case (`NOCASE` collation gives us
/// case-insensitive uniqueness *and* a fast case-insensitive lookup/search
/// path without a separate normalized column).
@DataClassName('TagEntity')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()
      .withLength(min: 1, max: 40)
      .customConstraint('NOT NULL UNIQUE COLLATE NOCASE')();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
