import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/memory_photos_table.dart';

part 'memory_photos_dao.g.dart';

/// CRUD for a memory's photo set. Ordering and the max-5 rule are enforced
/// by the repository layer, which is the only caller that knows about both
/// the filesystem and the DB at once.
@DriftAccessor(tables: [MemoryPhotos])
class MemoryPhotosDao extends DatabaseAccessor<AppDatabase> with _$MemoryPhotosDaoMixin {
  MemoryPhotosDao(super.db);

  Future<List<MemoryPhoto>> getPhotosForMemory(int memoryId) {
    return (select(memoryPhotos)
          ..where((p) => p.memoryId.equals(memoryId))
          ..orderBy([(p) => OrderingTerm.asc(p.displayOrder)]))
        .get();
  }

  /// Batch fetch, grouped by memory id — used when assembling many memories
  /// at once so we run one query instead of one per memory.
  Future<Map<int, List<MemoryPhoto>>> getPhotosForMemories(Iterable<int> memoryIds) async {
    if (memoryIds.isEmpty) return const {};
    final rows = await (select(memoryPhotos)
          ..where((p) => p.memoryId.isIn(memoryIds))
          ..orderBy([(p) => OrderingTerm.asc(p.displayOrder)]))
        .get();
    final grouped = <int, List<MemoryPhoto>>{};
    for (final row in rows) {
      (grouped[row.memoryId] ??= []).add(row);
    }
    return grouped;
  }

  Future<int> insertPhoto(MemoryPhotosCompanion entry) => into(memoryPhotos).insert(entry);

  Future<void> replacePhotosForMemory(int memoryId, List<MemoryPhotosCompanion> entries) async {
    await (delete(memoryPhotos)..where((p) => p.memoryId.equals(memoryId))).go();
    for (final entry in entries) {
      await into(memoryPhotos).insert(entry);
    }
  }

  Future<int> deletePhotosForMemory(int memoryId) =>
      (delete(memoryPhotos)..where((p) => p.memoryId.equals(memoryId))).go();
}
