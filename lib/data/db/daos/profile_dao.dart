import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/profile_table.dart';

part 'profile_dao.g.dart';

const _singletonId = 1;

/// The owner profile is always a single row at id `1` — [upsert] and [watch]
/// hide that convention behind a "there is only one" API.
@DriftAccessor(tables: [Profile])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<ProfileEntity?> get() {
    return (select(profile)..where((p) => p.id.equals(_singletonId))).getSingleOrNull();
  }

  Stream<ProfileEntity?> watch() {
    return (select(profile)..where((p) => p.id.equals(_singletonId))).watchSingleOrNull();
  }

  Future<void> upsert({required String name, String? photoPath, required String about}) async {
    final existing = await get();
    await into(profile).insertOnConflictUpdate(
      ProfileEntity(
        id: _singletonId,
        name: name,
        photoPath: photoPath,
        about: about,
        createdAt: existing?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
