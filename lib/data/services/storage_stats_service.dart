import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../repositories/memory_repository.dart';

class StorageStats {
  const StorageStats({
    required this.totalMemories,
    required this.totalPhotos,
    required this.totalBytes,
  });

  final int totalMemories;
  final int totalPhotos;
  final int totalBytes;

  String get formattedSize => formatBytes(totalBytes);

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    const units = ['KB', 'MB', 'GB', 'TB'];
    double value = bytes / 1024;
    var unitIndex = 0;
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    return '${value.toStringAsFixed(value < 10 ? 1 : 0)} ${units[unitIndex]}';
  }
}

/// Real, on-disk storage usage — original photos, thumbnails, and the
/// database file(s) — computed fresh each call so it's always accurate
/// after a create/edit/delete/demo/backup/restore.
class StorageStatsService {
  StorageStatsService._();

  static Future<StorageStats> compute() async {
    final docs = await getApplicationDocumentsDirectory();
    var bytes = 0;
    bytes += await _dirSize(Directory(p.join(docs.path, 'memory_photos')));
    bytes += await _dirSize(Directory(p.join(docs.path, 'memory_thumbnails')));
    bytes += await _databaseSize(docs.path);

    final repo = MemoryRepository.instance;
    return StorageStats(
      totalMemories: repo.totalMemories,
      totalPhotos: repo.totalPhotos,
      totalBytes: bytes,
    );
  }

  static Future<int> _dirSize(Directory dir) async {
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  static Future<int> _databaseSize(String docsPath) async {
    final dir = Directory(docsPath);
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File &&
          p.basename(entity.path).startsWith('nestory.sqlite')) {
        total += await entity.length();
      }
    }
    return total;
  }
}
