import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_photo.dart';

/// Large circular profile avatar with a soft gradient ring and glow, or a
/// local-placeholder icon when no photo is set.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.photoUrl, this.size = 140, this.onTap});

  final String? photoUrl;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.onSurface.withValues(alpha: 0.2), Colors.transparent],
          ),
          boxShadow: [
            BoxShadow(color: colors.onSurface.withValues(alpha: 0.08), blurRadius: 40, spreadRadius: 8),
          ],
        ),
        child: ClipOval(
          child: Container(
            color: colors.surfaceDim,
            child: photoUrl != null
                ? AppPhoto(url: photoUrl!)
                : Icon(Icons.person_outline, size: size * 0.45, color: colors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
