// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_photos_dao.dart';

// ignore_for_file: type=lint
mixin _$MemoryPhotosDaoMixin on DatabaseAccessor<AppDatabase> {
  $MemoriesTable get memories => attachedDatabase.memories;
  $MemoryPhotosTable get memoryPhotos => attachedDatabase.memoryPhotos;
  MemoryPhotosDaoManager get managers => MemoryPhotosDaoManager(this);
}

class MemoryPhotosDaoManager {
  final _$MemoryPhotosDaoMixin _db;
  MemoryPhotosDaoManager(this._db);
  $$MemoriesTableTableManager get memories =>
      $$MemoriesTableTableManager(_db.attachedDatabase, _db.memories);
  $$MemoryPhotosTableTableManager get memoryPhotos =>
      $$MemoryPhotosTableTableManager(_db.attachedDatabase, _db.memoryPhotos);
}
