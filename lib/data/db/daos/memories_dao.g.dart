// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memories_dao.dart';

// ignore_for_file: type=lint
mixin _$MemoriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $MemoriesTable get memories => attachedDatabase.memories;
  $TagsTable get tags => attachedDatabase.tags;
  $MemoryTagsTable get memoryTags => attachedDatabase.memoryTags;
  MemoriesDaoManager get managers => MemoriesDaoManager(this);
}

class MemoriesDaoManager {
  final _$MemoriesDaoMixin _db;
  MemoriesDaoManager(this._db);
  $$MemoriesTableTableManager get memories =>
      $$MemoriesTableTableManager(_db.attachedDatabase, _db.memories);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$MemoryTagsTableTableManager get memoryTags =>
      $$MemoryTagsTableTableManager(_db.attachedDatabase, _db.memoryTags);
}
