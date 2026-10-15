import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../demo/demo_memories.dart';
import '../services/image_storage_service.dart';
import '../../shared/models/memory.dart';
import '../../shared/models/photo_display_mode.dart';

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Single source of truth for memories, backed by [AppDatabase] (Drift).
///
/// Public API is deliberately synchronous (`onDate`, `search`, the stat
/// getters) because the screens that consume it were built against that
/// contract — so this keeps a full in-memory read cache, rebuilt from the
/// database after every write, and exposes reads from that cache. The
/// database remains the single source of truth; the cache is a reactive
/// mirror of it. A [ChangeNotifier], so every screen using
/// [ListenableBuilder]/[AnimatedBuilder] refreshes automatically after any
/// CRUD — no manual cross-screen invalidation, no restart required.
class MemoryRepository extends ChangeNotifier {
  MemoryRepository._();

  static final MemoryRepository instance = MemoryRepository._();

  AppDatabase get _db => AppDatabase.instance();

  List<Memory> _memories = const [];
  bool _ready = false;

  bool get isReady => _ready;

  /// All memories, most recent first.
  List<Memory> get all => _memories;

  Future<void> init() async {
    if (_ready) return;
    await reload();
    _ready = true;
  }

  Future<void> reload() async {
    final rows = await _db.memoriesDao.getAllMemories();
    final ids = rows.map((r) => r.id);
    final photosByMemory = await _db.memoryPhotosDao.getPhotosForMemories(ids);
    final tagsByMemory = await _db.tagsDao.getTagNamesForMemories(ids);

    _memories = [
      for (final row in rows)
        Memory(
          id: row.id,
          title: row.title,
          description: row.description,
          date: row.memoryDate,
          photoUrls: [
            for (final photo in photosByMemory[row.id] ?? const [])
              photo.localPath,
          ],
          photoDisplayModes: [
            for (final photo in photosByMemory[row.id] ?? const [])
              PhotoDisplayMode.fromName(photo.displayMode),
          ],
          tags: tagsByMemory[row.id] ?? const [],
          isFavorite: row.isFavorite,
          isDemo: row.isDemo,
        ),
    ];
    notifyListeners();
  }

  List<Memory> onDate(DateTime date) =>
      _memories.where((m) => _isSameDay(m.date, date)).toList();

  bool hasMemoriesOn(DateTime date) =>
      _memories.any((m) => _isSameDay(m.date, date));

  List<Memory> search(String query) {
    if (query.trim().isEmpty) return const [];
    return _memories.where((m) => m.matchesQuery(query)).toList();
  }

  Memory? byId(int id) {
    for (final m in _memories) {
      if (m.id == id) return m;
    }
    return null;
  }

  // ---- Statistics (Profile screen) ----------------------------------

  int get totalMemories => _memories.length;

  int get totalPhotos => _memories.fold(0, (sum, m) => sum + m.photoCount);

  int get totalTags => _memories
      .expand((m) => m.tags)
      .map((t) => t.toLowerCase())
      .toSet()
      .length;

  int? get firstMemoryYear {
    if (_memories.isEmpty) return null;
    return _memories.map((m) => m.date.year).reduce((a, b) => a < b ? a : b);
  }

  // ---- CRUD -----------------------------------------------------------

  Future<Memory> create({
    required String title,
    required String description,
    required DateTime date,
    required List<String> tags,
    required List<String> photoPaths,
    List<PhotoDisplayMode>? photoDisplayModes,
    bool isFavorite = false,
    bool isDemo = false,
  }) async {
    final id = await _db.transaction(() async {
      final memoryId = await _db.memoriesDao.insertMemory(
        MemoriesCompanion.insert(
          title: title,
          memoryDate: date,
          description: Value(description),
          isFavorite: Value(isFavorite),
          isDemo: Value(isDemo),
        ),
      );

      await _insertPhotos(
        memoryId,
        photoPaths,
        displayModes: photoDisplayModes,
      );
      await _linkTags(memoryId, tags);
      return memoryId;
    });

    await reload();
    return byId(id)!;
  }

  /// Replaces a memory's fields and photo set. Any previously-stored photo
  /// (and its thumbnail) that's no longer in [photoPaths] is deleted from
  /// app storage; photos that are unchanged keep their existing thumbnail
  /// instead of regenerating it.
  Future<void> update({
    required int id,
    required String title,
    required String description,
    required DateTime date,
    required List<String> tags,
    required List<String> photoPaths,
    List<PhotoDisplayMode>? photoDisplayModes,
    bool? isFavorite,
  }) async {
    await _db.transaction(() async {
      await _db.memoriesDao.updateMemory(
        id,
        MemoriesCompanion(
          title: Value(title),
          description: Value(description),
          memoryDate: Value(date),
          isFavorite: isFavorite == null
              ? const Value.absent()
              : Value(isFavorite),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final existingPhotos = await _db.memoryPhotosDao.getPhotosForMemory(id);
      final existingByPath = {for (final p in existingPhotos) p.localPath: p};

      for (final photo in existingPhotos) {
        if (!photoPaths.contains(photo.localPath)) {
          await ImageStorageService.delete(photo.localPath);
          await ImageStorageService.delete(photo.thumbnailPath);
        }
      }

      await _db.memoryPhotosDao.deletePhotosForMemory(id);
      await _insertPhotos(
        id,
        photoPaths,
        reuseThumbnails: existingByPath,
        displayModes: photoDisplayModes,
      );
      await _linkTags(id, tags);
    });

    await reload();
  }

  Future<void> toggleFavorite(int id) async {
    final memory = byId(id);
    if (memory == null) return;
    await _db.memoriesDao.setFavorite(id, !memory.isFavorite);
    await reload();
  }

  Future<void> delete(int id) async {
    final photos = await _db.memoryPhotosDao.getPhotosForMemory(id);
    for (final photo in photos) {
      await ImageStorageService.delete(photo.localPath);
      await ImageStorageService.delete(photo.thumbnailPath);
    }
    await _db.memoriesDao.deleteMemory(id);
    await reload();
  }

  /// Deletes every memory (and their photos/tags) — never touches Profile
  /// or AppSettings.
  Future<void> deleteAllMemories() async {
    for (final memory in _memories) {
      final photos = await _db.memoryPhotosDao.getPhotosForMemory(memory.id);
      for (final photo in photos) {
        await ImageStorageService.delete(photo.localPath);
        await ImageStorageService.delete(photo.thumbnailPath);
      }
    }
    await _db.memoriesDao.deleteAllMemories();
    await reload();
  }

  // ---- Demo data --------------------------------------------------------

  Future<bool> seedDemoDataIfNeeded() async {
    if (await _db.memoriesDao.hasDemoMemories()) return false;

    final now = DateTime.now();
    for (final def in demoMemoryDefs) {
      final photoPaths = [
        for (final asset in def.photoAssets)
          await ImageStorageService.copyAssetIntoAppStorage(asset),
      ];
      await create(
        title: def.title,
        description: def.description,
        date: def.dateFor(now),
        tags: def.tags,
        photoPaths: photoPaths,
        isFavorite: def.isFavorite,
        isDemo: true,
      );
    }
    return true;
  }

  Future<void> clearDemoData() async {
    final demoMemories = _memories.where((m) => m.isDemo).toList();
    for (final memory in demoMemories) {
      final photos = await _db.memoryPhotosDao.getPhotosForMemory(memory.id);
      for (final photo in photos) {
        await ImageStorageService.delete(photo.localPath);
        await ImageStorageService.delete(photo.thumbnailPath);
      }
    }
    await _db.memoriesDao.deleteDemoMemories();
    await reload();
  }

  // ---- Internal helpers ---------------------------------------------

  Future<void> _insertPhotos(
    int memoryId,
    List<String> photoPaths, {
    Map<String, MemoryPhoto>? reuseThumbnails,
    List<PhotoDisplayMode>? displayModes,
  }) async {
    int? coverPhotoId;
    for (var i = 0; i < photoPaths.length; i++) {
      final path = photoPaths[i];
      final thumbnailPath =
          reuseThumbnails?[path]?.thumbnailPath ??
          await ImageStorageService.thumbnailFor(path);
      final mode = (displayModes != null && i < displayModes.length)
          ? displayModes[i]
          : PhotoDisplayMode.fill;
      final photoId = await _db.memoryPhotosDao.insertPhoto(
        MemoryPhotosCompanion.insert(
          memoryId: memoryId,
          localPath: path,
          thumbnailPath: thumbnailPath,
          displayOrder: Value(i),
          displayMode: Value(mode.name),
        ),
      );
      if (i == 0) coverPhotoId = photoId;
    }
    await _db.memoriesDao.setCoverPhoto(memoryId, coverPhotoId);
  }

  Future<void> _linkTags(int memoryId, List<String> tags) async {
    final tagIds = [for (final tag in tags) await _db.tagsDao.getOrCreate(tag)];
    await _db.tagsDao.replaceMemoryTags(memoryId, tagIds);
  }
}
