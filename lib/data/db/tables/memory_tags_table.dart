import 'package:drift/drift.dart';

import 'memories_table.dart';
import 'tags_table.dart';

/// Many-to-many join between [Memories] and [Tags].
@DataClassName('MemoryTagEntity')
class MemoryTags extends Table {
  IntColumn get memoryId => integer().references(Memories, #id, onDelete: KeyAction.cascade)();

  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {memoryId, tagId};
}
