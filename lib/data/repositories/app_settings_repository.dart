import 'package:flutter/material.dart';

import '../db/app_database.dart';

ThemeMode _themeModeFromString(String value) {
  return ThemeMode.values.firstWhere((m) => m.name == value, orElse: () => ThemeMode.dark);
}

/// App-wide persistent settings — always a single row. Not yet wired into
/// the UI (Phase 2 is the persistence layer only); ready to replace the
/// in-memory-only `themeModeNotifier` once the app should remember the
/// user's theme choice (and other settings) across restarts.
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
    _settings = await _db.appSettingsDao.ensureExists();
    _ready = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _db.appSettingsDao.setThemeMode(mode.name);
    _settings = await _db.appSettingsDao.ensureExists();
    notifyListeners();
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _db.appSettingsDao.setOnboardingCompleted(completed);
    _settings = await _db.appSettingsDao.ensureExists();
    notifyListeners();
  }

  Future<void> setLastBackupDate(DateTime date) async {
    await _db.appSettingsDao.setLastBackupDate(date);
    _settings = await _db.appSettingsDao.ensureExists();
    notifyListeners();
  }
}
