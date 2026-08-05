import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_photo.dart';

/// A single day cell in the month calendar — a glass circle, optionally
/// filled with a memory cover photo, with a selected "active glow" state.
class DateCircle extends StatelessWidget {
  const DateCircle({
    super.key,
    required this.day,
    this.coverUrl,
    this.selected = false,
    this.dimmed = false,
    this.onTap,
  });

  final int day;
  final String? coverUrl;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasMemory = coverUrl != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.05 : 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: AspectRatio(
          aspectRatio: 1,
          child: Opacity(
            opacity: dimmed ? 0.35 : 1,
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.onSurface.withValues(alpha: hasMemory ? 0 : 0.03),
                  border: Border.all(
                    color: selected
                        ? colors.onSurface.withValues(alpha: 0.8)
                        : colors.glassBorder.withValues(alpha: 0.1),
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(color: colors.onSurface.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 1),
                        ]
                      : null,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    if (hasMemory) ...[
                      AppPhoto(url: coverUrl!, cacheWidth: 160),
                      Container(color: Colors.black.withValues(alpha: 0.35)),
                    ],
                    Center(
                      child: Text(
                        '$day',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: hasMemory ? colors.primary : colors.onSurface,
                              fontWeight: hasMemory ? FontWeight.w500 : FontWeight.w400,
                              height: 1,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
