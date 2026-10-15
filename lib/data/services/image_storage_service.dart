import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const thumbnailWidth = 320;

/// Owns the app's private photo storage. Every photo a memory references —
/// picked, captured, or bundled demo content — is copied here first (so the
/// memory keeps working even if the original gallery file, or the app
/// bundle for demo photos, later goes away). Thumbnail generation is a
/// separate step ([thumbnailFor]) so callers that only need a full-quality
/// copy — e.g. the Create/Edit photo picker — aren't forced to pay for one
/// up front; the repository generates the thumbnail once, at save time.
class ImageStorageService {
  ImageStorageService._();

  static Directory? _photosDir;
  static Directory? _thumbsDir;

  static Future<Directory> _photos() async {
    return _photosDir ??= await _ensureDir('memory_photos');
  }

  static Future<Directory> _thumbs() async {
    return _thumbsDir ??= await _ensureDir('memory_thumbnails');
  }

  static Future<Directory> _ensureDir(String name) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, name));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static String _uniqueName(String ext) =>
      '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 32)}$ext';

  /// Copies [sourcePath] (a picked/captured file) into app storage and
  /// returns the new local path.
  static Future<String> copyIntoAppStorage(String sourcePath) async {
    final dir = await _photos();
    final ext = p.extension(sourcePath).isEmpty
        ? '.jpg'
        : p.extension(sourcePath);
    final destPath = p.join(dir.path, _uniqueName(ext));
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  /// Copies a bundled asset (see `assets/demo_photos/`) into app storage —
  /// used only for demo data, so seeded memories show real photos without
  /// the app ever touching the network at runtime.
  static Future<String> copyAssetIntoAppStorage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final dir = await _photos();
    final destPath = p.join(dir.path, _uniqueName(p.extension(assetPath)));
    await File(destPath).writeAsBytes(bytes);
    return destPath;
  }

  /// Generates and stores a small thumbnail from an already-stored photo at
  /// [localPath], returning the thumbnail's path.
  static Future<String> thumbnailFor(String localPath) async {
    final sourceBytes = await File(localPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(
      sourceBytes,
      targetWidth: thumbnailWidth,
    );
    final frame = await codec.getNextFrame();
    final pngBytes = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (pngBytes == null) {
      throw StateError('Failed to encode thumbnail for $localPath');
    }

    final dir = await _thumbs();
    final path = p.join(dir.path, _uniqueName('.png'));
    await File(path).writeAsBytes(_asUint8List(pngBytes));
    return path;
  }

  static Uint8List _asUint8List(ByteData data) =>
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  static Future<void> delete(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort cleanup — a missing/locked file isn't fatal.
    }
  }
}
