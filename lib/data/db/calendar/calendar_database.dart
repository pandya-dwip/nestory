import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/calendar_accounts_dao.dart';
import 'daos/calendar_events_dao.dart';
import 'daos/calendar_outbox_dao.dart';
import 'daos/calendars_meta_dao.dart';
import 'daos/sync_conflicts_dao.dart';
import 'tables/calendar_accounts_table.dart';
import 'tables/calendar_events_table.dart';
import 'tables/calendar_outbox_table.dart';
import 'tables/calendars_meta_table.dart';
import 'tables/sync_conflicts_table.dart';

part 'calendar_database.g.dart';

/// Dedicated Drift database for Google Calendar data (`calendar_cache.sqlite`).
/// Completely physically separated from `nestory.sqlite` so that memory vault
/// backup/restore remains 100% isolated and immune from cloud cache overwrites.
@DriftDatabase(
  tables: [
    CalendarAccounts,
    CalendarsMeta,
    CalendarEvents,
    CalendarOutbox,
    SyncConflicts,
  ],
  daos: [
    CalendarAccountsDao,
    CalendarsMetaDao,
    CalendarEventsDao,
    CalendarOutboxDao,
    SyncConflictsDao,
  ],
)
class CalendarDatabase extends _$CalendarDatabase {
  CalendarDatabase._() : super(_openConnection());

  CalendarDatabase.forTesting(super.executor);

  static CalendarDatabase? _instance;

  static CalendarDatabase instance() => _instance ??= CalendarDatabase._();

  static void setInstanceForTesting(CalendarDatabase? db) {
    _instance = db;
  }

  static Future<void> closeAndReset() async {
    await _instance?.close();
    _instance = null;
  }

  static Future<String> filePath() async {
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'calendar_cache.sqlite');
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes(m);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static Future<void> _createIndexes(Migrator m) async {
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_calendar_events_google_id ON calendar_events (google_event_id)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_calendar_events_all_day_dates ON calendar_events (is_all_day, start_date, end_date)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_calendar_events_timed_dates ON calendar_events (is_all_day, start_date_time, end_date_time)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_calendar_events_sync_status ON calendar_events (sync_status)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_calendar_outbox_created ON calendar_outbox (created_at)',
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'calendar_cache',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
    );
  }
}
