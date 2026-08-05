import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A photo with a graceful offline/error fallback — a soft glass gradient
/// tile with an icon, never a broken-image glyph or gray box. Renders a
/// local file path (the common case — every stored memory photo lives in
/// app storage) or, if [url] is an http(s) URL, a network image.
class AppPhoto extends StatelessWidget {
  const AppPhoto({super.key, required this.url, this.fit = BoxFit.cover, this.cacheWidth});

  final String url;
  final BoxFit fit;

  /// Decodes the image downsampled to this width — cheap thumbnailing for
  /// spots (like the calendar) that render many small copies at once.
  final int? cacheWidth;

  bool get _isNetwork => url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (_isNetwork) {
      return Image.network(
        url,
        fit: fit,
        cacheWidth: cacheWidth,
        loadingBuilder: (context, child, progress) => progress == null ? child : _placeholder(colors, loading: true),
        errorBuilder: (context, error, stack) => _placeholder(colors, loading: false),
      );
    }

    return Image.file(
      File(url),
      fit: fit,
      cacheWidth: cacheWidth,
      errorBuilder: (context, error, stack) => _placeholder(colors, loading: false),
    );
  }

  Widget _placeholder(NestoryColors colors, {required bool loading}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.surfaceContainerHigh, colors.surfaceContainerLowest],
        ),
      ),
      child: Center(
        child: Icon(
          loading ? Icons.image_outlined : Icons.image_not_supported_outlined,
          color: colors.onSurfaceVariant.withValues(alpha: 0.5),
          size: 32,
        ),
      ),
    );
  }
}
