import 'package:flutter/widgets.dart';

/// How a single photo should be fitted within its frame — a per-photo
/// choice (stored on `MemoryPhotos.displayMode`), not a global setting.
enum PhotoDisplayMode {
  /// Crop to fill the frame (today's default behavior).
  fill,

  /// Show the entire image, letterboxed if needed.
  fit,

  /// Favor filling the width — best for wide/landscape photos.
  landscapePriority,

  /// Favor filling the height — best for tall/portrait photos.
  portraitPriority;

  static PhotoDisplayMode fromName(String? name) {
    return PhotoDisplayMode.values.firstWhere((m) => m.name == name, orElse: () => PhotoDisplayMode.fill);
  }

  BoxFit get boxFit => switch (this) {
        PhotoDisplayMode.fill => BoxFit.cover,
        PhotoDisplayMode.fit => BoxFit.contain,
        PhotoDisplayMode.landscapePriority => BoxFit.fitWidth,
        PhotoDisplayMode.portraitPriority => BoxFit.fitHeight,
      };

  String get label => switch (this) {
        PhotoDisplayMode.fill => 'Fill (Crop)',
        PhotoDisplayMode.fit => 'Fit (Show Entire Image)',
        PhotoDisplayMode.landscapePriority => 'Landscape Priority',
        PhotoDisplayMode.portraitPriority => 'Portrait Priority',
      };
}
