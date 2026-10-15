import 'package:drift/drift.dart';

/// Preserved record of rejected offline edits when a remote update conflicted
/// with a local edit (HTTP 412). Ensures zero silent data loss.
@DataClassName('SyncConflictEntity')
class SyncConflicts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get googleEventId => text()();

  TextColumn get googleCalendarId => text()();

  TextColumn get eventTitle => text()();

  /// The rejected offline user edit payload in JSON.
  TextColumn get localPayloadJson => text()();

  /// The authoritative server version kept in JSON.
  TextColumn get remotePayloadJson => text()();

  TextColumn get conflictReason => text().withDefault(
    const Constant('Remote event was modified while offline'),
  )();

  DateTimeColumn get resolvedAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
}
