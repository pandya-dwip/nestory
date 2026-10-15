import 'package:flutter/material.dart';

import '../db/app_database.dart';

ThemeMode _themeModeFromString(String value) {
  return ThemeMode.values.firstWhere(
    (m) => m.name == value,
    orElse: () => ThemeMode.dark,
  );
}

/// App-wide persistent settings — always a single row, backed by
/// [AppDatabase]. Not yet wired to `themeModeNotifier` (which still governs
/// the live theme) — this is where that choice would persist across
/// restarts once that's wired up.
class AppSettingsRepository extends ChangeNotifier {
  AppSettingsRepository._();

  static final AppSettingsRepository instance = AppSettingsRepository._();

  AppDatabase get _db => AppDatabase.instance();

  AppSettingsEntity? _settings;
  bool _ready = false;

  bool get isReady => _ready;

  ThemeMode get themeMode => _themeModeFromCurrent();

  bool get onboardingCompleted => _settings?.onboardingCompleted ?? false;

  DateTime? get lastBackupDate => _settings?.lastBackupDate;

  ThemeMode _themeModeFromCurrent() {
    final settings = _settings;
    if (settings == null) return ThemeMode.dark;
    return _themeModeFromString(settings.themeMode);
  }

  Future<void> init() async {
    if (_ready) return;
    await reload();
    _ready = true;
  }

  /// Re-fetches from the database — used at startup and after a restore
  /// replaces the underlying database file.
  Future<void> reload() async {
    _settings = await _db.appSettingsDao.ensureExists();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _db.appSettingsDao.setThemeMode(mode.name);
    await reload();
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _db.appSettingsDao.setOnboardingCompleted(completed);
    await reload();
  }

  Future<void> setLastBackupDate(DateTime date) async {
    await _db.appSettingsDao.setLastBackupDate(date);
    await reload();
  }
}
