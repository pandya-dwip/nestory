import 'package:drift/drift.dart';

/// Cached Google Calendar events with strict separation of all-day date-only
/// intervals [startDate, endDate) and timed UTC instants.
@DataClassName('CalendarEventEntity')
class CalendarEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get googleEventId => text().nullable()();

  TextColumn get googleCalendarId => text()();

  TextColumn get title => text().withLength(min: 1, max: 500)();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get location => text().withDefault(const Constant(''))();

  /// Flag indicating whether this is an all-day event or timed event.
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();

  /// Date-only start date in `YYYY-MM-DD` format for all-day events.
  TextColumn get startDate => text().nullable()();

  /// Date-only exclusive end date in `YYYY-MM-DD` format for all-day events
  /// conforming strictly to Google Calendar's half-open `[startDate, endDate)` interval.
  TextColumn get endDate => text().nullable()();

  /// Instant start for timed events in UTC.
  DateTimeColumn get startDateTime => dateTime().nullable()();

  /// Instant end for timed events in UTC.
  DateTimeColumn get endDateTime => dateTime().nullable()();

  /// Original time zone string (e.g. 'Asia/Kolkata', 'America/New_York').
  TextColumn get timeZone => text().withDefault(const Constant('UTC'))();

  TextColumn get recurrenceRule => text().nullable()();

  TextColumn get recurringEventId => text().nullable()();

  /// Sync state: 'synced', 'pendingCreate', 'pendingUpdate', 'pendingDelete', 'failed'
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  TextColumn get remoteETag => text().nullable()();

  /// Client-generated UUID tracking the local mutation ownership.
  TextColumn get clientMutationId => text().nullable()();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
