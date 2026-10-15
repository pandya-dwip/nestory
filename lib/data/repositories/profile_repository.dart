import 'package:flutter/foundation.dart';

import '../db/app_database.dart';

/// The owner's profile — always a single row, backed by [AppDatabase].
class ProfileRepository extends ChangeNotifier {
  ProfileRepository._();

  static final ProfileRepository instance = ProfileRepository._();

  AppDatabase get _db => AppDatabase.instance();

  ProfileEntity? _profile;
  bool _ready = false;

  bool get isReady => _ready;

  ProfileEntity? get current => _profile;

  String get name => _profile?.name ?? '';

  String get about => _profile?.about ?? '';

  String? get photoPath => _profile?.photoPath;

  Future<void> init() async {
    if (_ready) return;
    await reload();
    _ready = true;
  }

  /// Re-fetches from the database — used at startup and after a restore
  /// replaces the underlying database file.
  Future<void> reload() async {
    _profile = await _db.profileDao.get();
    notifyListeners();
  }

  Future<void> save({
    required String name,
    String? photoPath,
    required String about,
  }) async {
    await _db.profileDao.upsert(name: name, photoPath: photoPath, about: about);
    await reload();
  }
}
