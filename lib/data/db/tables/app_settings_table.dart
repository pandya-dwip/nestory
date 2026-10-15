import 'package:drift/drift.dart';

/// App-wide persistent preferences — the single owner row (id `1`) that
/// replaces SharedPreferences for anything the app must remember.
///
/// Deliberately holds only the fields actually used today. A future
/// preference (accent color, language, biometric lock, auto backup,
/// grid/list layout, home screen default, ...) is added the same way any
/// schema change is: bump [AppDatabase.schemaVersion] and add a column in
/// `onUpgrade` — not by pre-declaring speculative columns now.
@DataClassName('AppSettingsEntity')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stored as plain text (`dark` / `light` / `system`) rather than a
  /// Flutter `ThemeMode` so the data layer stays framework-agnostic; the
  /// repository maps it to/from `ThemeMode`.
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();

  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get lastBackupDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
