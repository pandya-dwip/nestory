import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/app_settings_dao.dart';
import 'daos/memories_dao.dart';
import 'daos/memory_photos_dao.dart';
import 'daos/profile_dao.dart';
import 'daos/tags_dao.dart';
import 'tables/app_settings_table.dart';
import 'tables/memories_table.dart';
import 'tables/memory_photos_table.dart';
import 'tables/memory_tags_table.dart';
import 'tables/profile_table.dart';
import 'tables/tags_table.dart';

part 'app_database.g.dart';

/// The Nestory vault. One [AppDatabase] instance for the app's lifetime
/// (see [AppDatabase.instance]), exposing one DAO per concern — widgets and
/// even repositories never see raw SQL, only typed DAO methods.
@DriftDatabase(
  tables: [Memories, MemoryPhotos, Tags, MemoryTags, Profile, AppSettings],
  daos: [MemoriesDao, MemoryPhotosDao, TagsDao, ProfileDao, AppSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  static AppDatabase? _instance;

  static AppDatabase instance() => _instance ??= AppDatabase._();

  static void setInstanceForTesting(AppDatabase? db) {
    _instance = db;
  }

  /// Closes the current connection and drops the cached instance, so the
  /// next [instance] call reopens fresh — used by Restore after the backup
  /// archive has replaced the database file on disk.
  static Future<void> closeAndReset() async {
    await _instance?.close();
    _instance = null;
  }

  static Future<String> filePath() async {
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'nestory.sqlite');
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes(m);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(memoryPhotos, memoryPhotos.displayMode);
      }
    },
    beforeOpen: (details) async {
      // MemoryPhotos/MemoryTags cascade deletes rely on this.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static Future<void> _createIndexes(Migrator m) async {
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_memories_date ON memories (memory_date)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_memories_is_demo ON memories (is_demo)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_memory_photos_memory_order ON memory_photos (memory_id, display_order)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_memory_tags_memory ON memory_tags (memory_id)',
    );
    await m.database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_memory_tags_tag ON memory_tags (tag_id)',
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'nestory',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
    );
  }
}
