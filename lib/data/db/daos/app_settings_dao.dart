import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/app_settings_table.dart';

part 'app_settings_dao.g.dart';

const _singletonId = 1;

/// App-wide settings, always a single row at id `1`. [get] returns the
/// defaulted row on first run (created lazily by [ensureExists]) so callers
/// never have to null-check "no settings yet".
@DriftAccessor(tables: [AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase> with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  Future<AppSettingsEntity> ensureExists() async {
    final existing = await (select(appSettings)..where((s) => s.id.equals(_singletonId))).getSingleOrNull();
    if (existing != null) return existing;

    final id = await into(appSettings).insert(const AppSettingsCompanion());
    return (select(appSettings)..where((s) => s.id.equals(id))).getSingle();
  }

  Stream<AppSettingsEntity> watch() {
    return (select(appSettings)..where((s) => s.id.equals(_singletonId)))
        .watchSingleOrNull()
        .asyncMap((row) async => row ?? ensureExists());
  }

  Future<void> setThemeMode(String themeMode) async {
    await ensureExists();
    await (update(appSettings)..where((s) => s.id.equals(_singletonId)))
        .write(AppSettingsCompanion(themeMode: Value(themeMode), updatedAt: Value(DateTime.now())));
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await ensureExists();
    await (update(appSettings)..where((s) => s.id.equals(_singletonId)))
        .write(AppSettingsCompanion(onboardingCompleted: Value(completed), updatedAt: Value(DateTime.now())));
  }

  Future<void> setLastBackupDate(DateTime date) async {
    await ensureExists();
    await (update(appSettings)..where((s) => s.id.equals(_singletonId)))
        .write(AppSettingsCompanion(lastBackupDate: Value(date), updatedAt: Value(DateTime.now())));
  }
}
