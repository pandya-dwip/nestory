import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/memories_table.dart';
import '../tables/memory_tags_table.dart';
import '../tables/tags_table.dart';

part 'memories_dao.g.dart';

/// Row-level CRUD and queries on [Memories]. Composition with photos/tags
/// into the UI-facing `Memory` DTO happens one layer up, in the repository.
@DriftAccessor(tables: [Memories, MemoryTags, Tags])
class MemoriesDao extends DatabaseAccessor<AppDatabase> with _$MemoriesDaoMixin {
  MemoriesDao(super.db);

  Future<List<MemoryEntity>> getAllMemories() {
    return (select(memories)..orderBy([(m) => OrderingTerm.desc(m.memoryDate)])).get();
  }

  Future<MemoryEntity?> getMemoryById(int id) {
    return (select(memories)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  Future<List<MemoryEntity>> getMemoriesOnDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(memories)
          ..where((m) => m.memoryDate.isBiggerOrEqualValue(start) & m.memoryDate.isSmallerThanValue(end))
          ..orderBy([(m) => OrderingTerm.desc(m.memoryDate)]))
        .get();
  }

  /// Type-safe, case-insensitive search across title, description, and tag
  /// names. Two indexed lookups + an in-memory merge/sort — no N+1, no
  /// unbounded joins. `LIKE '%..%'` can't use a btree index for an
  /// arbitrary substring match; if search over tens of thousands of rows
  /// ever becomes the bottleneck, the upgrade path is an FTS5 virtual
  /// table, not a bigger query here.
  Future<List<MemoryEntity>> searchMemories(String query) async {
    final pattern = '%${query.toLowerCase()}%';

    final directMatches = await (select(memories)
          ..where((m) => m.title.lower().like(pattern) | m.description.lower().like(pattern)))
        .get();

    final tagMatchRows = await (select(memoryTags).join([
      innerJoin(tags, tags.id.equalsExp(memoryTags.tagId)),
    ])
          ..where(tags.name.lower().like(pattern)))
        .get();
    final tagMatchIds = tagMatchRows.map((r) => r.readTable(memoryTags).memoryId).toSet();

    final byId = {for (final m in directMatches) m.id: m};
    final missingIds = tagMatchIds.difference(byId.keys.toSet());
    if (missingIds.isNotEmpty) {
      final tagMemories = await (select(memories)..where((m) => m.id.isIn(missingIds))).get();
      for (final m in tagMemories) {
        byId[m.id] = m;
      }
    }

    return byId.values.toList()..sort((a, b) => b.memoryDate.compareTo(a.memoryDate));
  }

  Future<bool> hasDemoMemories() async {
    final row = await (select(memories)
          ..where((m) => m.isDemo.equals(true))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  Future<int> insertMemory(MemoriesCompanion entry) => into(memories).insert(entry);

  Future<void> updateMemory(int id, MemoriesCompanion entry) {
    return (update(memories)..where((m) => m.id.equals(id))).write(entry);
  }

  Future<void> setCoverPhoto(int memoryId, int? coverPhotoId) {
    return (update(memories)..where((m) => m.id.equals(memoryId)))
        .write(MemoriesCompanion(coverPhotoId: Value(coverPhotoId)));
  }

  Future<void> setFavorite(int id, bool isFavorite) {
    return (update(memories)..where((m) => m.id.equals(id)))
        .write(MemoriesCompanion(isFavorite: Value(isFavorite), updatedAt: Value(DateTime.now())));
  }

  /// Single `UPDATE ... WHERE id IN (...)` — the batch-update path for e.g.
  /// bulk favorite/unfavorite.
  Future<void> setFavoriteBatch(List<int> ids, bool isFavorite) {
    if (ids.isEmpty) return Future.value();
    return (update(memories)..where((m) => m.id.isIn(ids)))
        .write(MemoriesCompanion(isFavorite: Value(isFavorite), updatedAt: Value(DateTime.now())));
  }

  /// Cascades to that memory's photos and tag links via FK `ON DELETE CASCADE`.
  Future<int> deleteMemory(int id) => (delete(memories)..where((m) => m.id.equals(id))).go();

  /// Single `DELETE ... WHERE id IN (...)` — cascades per row.
  Future<int> deleteMemoriesBatch(List<int> ids) {
    if (ids.isEmpty) return Future.value(0);
    return (delete(memories)..where((m) => m.id.isIn(ids))).go();
  }

  Future<int> deleteDemoMemories() => (delete(memories)..where((m) => m.isDemo.equals(true))).go();

  /// Deletes every memory — Profile/AppSettings live in separate tables and
  /// are untouched.
  Future<int> deleteAllMemories() => delete(memories).go();
}
