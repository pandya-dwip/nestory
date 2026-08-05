import 'package:flutter/foundation.dart';

import '../db/app_database.dart';

/// The owner's profile — always a single row. Not yet wired into the UI
/// (Phase 2 is the persistence layer only); ready for the Profile screen to
/// read/write through once it's time to persist name/photo/about there
/// instead of local widget state.
class ProfileRepository extends ChangeNotifier {
  ProfileRepository._();

  static final ProfileRepository instance = ProfileRepository._();

  AppDatabase get _db => AppDatabase.instance();

  ProfileEntity? _profile;
  bool _ready = false;

  bool get isReady => _ready;

  ProfileEntity? get current => _profile;

  Future<void> init() async {
    if (_ready) return;
    _profile = await _db.profileDao.get();
    _ready = true;
    notifyListeners();
  }

  Future<void> save({required String name, String? photoPath, required String about}) async {
    await _db.profileDao.upsert(name: name, photoPath: photoPath, about: about);
    _profile = await _db.profileDao.get();
    notifyListeners();
  }
}
