import 'package:drift/drift.dart';

/// Persistent queue of local offline mutations awaiting synchronization.
/// Survives application restarts, process termination, and network outages.
@DataClassName('CalendarOutboxEntity')
class CalendarOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Idempotent action identifier (UUID v4).
  TextColumn get clientMutationId => text().unique()();

  /// 'create', 'update', or 'delete'
  TextColumn get actionType => text()();

  /// Local SQLite ID in CalendarEvents (if created locally).
  IntColumn get localEventId => integer().nullable()();

  /// Remote Google Event ID (known for updates/deletes, or assigned client ID for creates).
  TextColumn get googleEventId => text().nullable()();

  /// Target Google Calendar ID.
  TextColumn get googleCalendarId => text()();

  /// Serialized event payload in JSON.
  TextColumn get payloadJson => text()();

  /// Remote ETag for concurrency check on updates.
  TextColumn get remoteETag => text().nullable()();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
