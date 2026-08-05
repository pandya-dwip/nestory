import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/memory_tags_table.dart';
import '../tables/tags_table.dart';

part 'tags_dao.g.dart';

/// Tag CRUD. Uniqueness (case-insensitive) is enforced by the `Tags.name`
/// column's `UNIQUE COLLATE NOCASE` constraint — [getOrCreate] relies on
/// that to make "find or insert" a single round trip per tag.
@DriftAccessor(tables: [Tags, MemoryTags])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  Future<List<TagEntity>> getAllTags() => select(tags).get();

  Future<TagEntity?> findByName(String name) {
    return (select(tags)..where((t) => t.name.lower().equals(name.toLowerCase()))).getSingleOrNull();
  }

  /// Returns the existing tag's id if [name] already exists (any case),
  /// otherwise inserts it and returns the new id.
  Future<int> getOrCreate(String name) async {
    final existing = await findByName(name);
    if (existing != null) return existing.id;
    return into(tags).insert(TagsCompanion.insert(name: name));
  }

  Future<void> linkMemoryToTags(int memoryId, Iterable<int> tagIds) async {
    for (final tagId in tagIds) {
      await into(memoryTags).insert(
        MemoryTagsCompanion.insert(memoryId: memoryId, tagId: tagId),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<void> replaceMemoryTags(int memoryId, Iterable<int> tagIds) async {
    await (delete(memoryTags)..where((mt) => mt.memoryId.equals(memoryId))).go();
    await linkMemoryToTags(memoryId, tagIds);
  }

  /// Batch fetch tag names for many memories at once, grouped by memory id.
  Future<Map<int, List<String>>> getTagNamesForMemories(Iterable<int> memoryIds) async {
    if (memoryIds.isEmpty) return const {};
    final rows = await (select(memoryTags).join([
      innerJoin(tags, tags.id.equalsExp(memoryTags.tagId)),
    ])
          ..where(memoryTags.memoryId.isIn(memoryIds)))
        .get();

    final grouped = <int, List<String>>{};
    for (final row in rows) {
      final memoryId = row.readTable(memoryTags).memoryId;
      final tagName = row.readTable(tags).name;
      (grouped[memoryId] ??= []).add(tagName);
    }
    return grouped;
  }
}
