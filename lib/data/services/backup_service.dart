import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../db/app_database.dart';

const _photosDirName = 'memory_photos';
const _thumbsDirName = 'memory_thumbnails';
const _dbEntryPrefix = 'db/';

/// Everything Nestory needs to fully restore itself: the SQLite database
/// (memories, photos rows, tags, profile, app settings — Drift's single
/// source of truth) plus the actual photo and thumbnail files it points to.
/// Zipped into one archive; nothing is re-derived or re-encoded.
class BackupService {
  BackupService._();

  /// Builds the backup archive in memory and returns its bytes.
  static Future<Uint8List> buildArchive() async {
    final docs = await getApplicationDocumentsDirectory();
    final archive = Archive();

    await _addDirectory(archive, Directory(p.join(docs.path, _photosDirName)), _photosDirName);
    await _addDirectory(archive, Directory(p.join(docs.path, _thumbsDirName)), _thumbsDirName);
    await _addDatabaseFiles(archive, docs.path);

    final bytes = ZipEncoder().encode(archive);
    return Uint8List.fromList(bytes);
  }

  /// A cheap sanity check before committing to a restore — a real Nestory
  /// backup always contains the database file.
  static bool looksLikeValidBackup(Uint8List zipBytes) {
    try {
      final archive = ZipDecoder().decodeBytes(zipBytes);
      return archive.files.any((f) => f.name == '${_dbEntryPrefix}nestory.sqlite');
    } catch (_) {
      return false;
    }
  }

  /// Replaces the app's database and photo storage with the contents of
  /// [zipBytes]. The database connection is closed first and reopened by
  /// the next [AppDatabase.instance] call after this completes.
  static Future<void> restoreArchive(Uint8List zipBytes) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    await AppDatabase.closeAndReset();

    final docs = await getApplicationDocumentsDirectory();
    await _clearDirectory(Directory(p.join(docs.path, _photosDirName)));
    await _clearDirectory(Directory(p.join(docs.path, _thumbsDirName)));
    await _clearDatabaseFiles(docs.path);

    for (final entry in archive.files) {
      if (!entry.isFile) continue;
      final relativePath = entry.name.startsWith(_dbEntryPrefix)
          ? entry.name.substring(_dbEntryPrefix.length)
          : entry.name;
      final outFile = File(p.join(docs.path, relativePath));
      await outFile.create(recursive: true);
      await outFile.writeAsBytes(entry.content as List<int>);
    }
  }

  static Future<void> _addDirectory(Archive archive, Directory dir, String archivePrefix) async {
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      final bytes = await entity.readAsBytes();
      archive.addFile(ArchiveFile('$archivePrefix/${p.basename(entity.path)}', bytes.length, bytes));
    }
  }

  static Future<void> _addDatabaseFiles(Archive archive, String docsPath) async {
    for (final file in await _databaseFiles(docsPath)) {
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile('$_dbEntryPrefix${p.basename(file.path)}', bytes.length, bytes));
    }
  }

  static Future<void> _clearDatabaseFiles(String docsPath) async {
    for (final file in await _databaseFiles(docsPath)) {
      await file.delete();
    }
  }

  /// The main db file plus any WAL/SHM sidecar files SQLite may have
  /// created alongside it.
  static Future<List<File>> _databaseFiles(String docsPath) async {
    final dir = Directory(docsPath);
    if (!await dir.exists()) return const [];
    final files = <File>[];
    await for (final entity in dir.list()) {
      if (entity is File && p.basename(entity.path).startsWith('nestory.sqlite')) {
        files.add(entity);
      }
    }
    return files;
  }

  static Future<void> _clearDirectory(Directory dir) async {
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      if (entity is File) await entity.delete();
    }
  }
}
