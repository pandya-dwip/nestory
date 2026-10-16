import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/photo_display_mode.dart';
import 'app_photo.dart';

/// A single day cell in the month calendar — a glass squircle, optionally
/// filled with a memory cover photo, with a selected "active glow" state
/// and restrained titanium top-right indicators for calendar events.
class DateCircle extends StatelessWidget {
  const DateCircle({
    super.key,
    required this.day,
    this.coverUrl,
    this.coverDisplayMode = PhotoDisplayMode.fill,
    this.selected = false,
    this.dimmed = false,
    this.eventCount = 0,
    this.onTap,
  });

  final int day;
  final String? coverUrl;
  final PhotoDisplayMode coverDisplayMode;
  final bool selected;
  final bool dimmed;
  final int eventCount;
  final VoidCallback? onTap;

  bool get hasEvents => eventCount > 0;

  static const BorderRadius _cellRadius = BorderRadius.all(Radius.circular(13));

  Widget _buildEventIndicator(NestoryColors colors) {
    if (eventCount <= 0) return const SizedBox.shrink();

    final dotColor = colors.primary.withValues(alpha: 0.95);
    final glowColor = colors.primary.withValues(alpha: 0.5);

    Widget dot({double size = 4.0}) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 3,
                spreadRadius: 0.5,
              ),
            ],
          ),
        );

    Widget content;
    if (eventCount == 1) {
      content = dot(size: 4.5);
    } else if (eventCount == 2) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot(size: 3.5),
          const SizedBox(width: 2.5),
          dot(size: 3.5),
        ],
      );
    } else if (eventCount == 3) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot(size: 3.0),
          const SizedBox(width: 2.0),
          dot(size: 3.0),
          const SizedBox(width: 2.0),
          dot(size: 3.0),
        ],
      );
    } else {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Text(
          '$eventCount',
          style: TextStyle(
            color: colors.primary,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      );
    }

    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(6),
        ),
        child: content,
      ),
    );
  }

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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: _cellRadius,
                color: colors.onSurface.withValues(
                  alpha: hasMemory ? 0 : (hasEvents ? 0.05 : 0.025),
                ),
                border: Border.all(
                  color: selected
                      ? colors.onSurface.withValues(alpha: 0.85)
                      : (hasEvents
                            ? colors.glassBorder.withValues(alpha: 0.28)
                            : colors.glassBorder.withValues(alpha: 0.1)),
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: colors.onSurface.withValues(alpha: 0.22),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: _cellRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasMemory) ...[
                      AppPhoto(
                        url: coverUrl!,
                        cacheWidth: 160,
                        fit: coverDisplayMode.boxFit,
                      ),
                      Container(color: Colors.black.withValues(alpha: 0.35)),
                    ],
                    Center(
                      child: Text(
                        '$day',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: hasMemory ? colors.primary : colors.onSurface,
                          fontWeight: (hasMemory || hasEvents)
                              ? FontWeight.w600
                              : FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    _buildEventIndicator(colors),
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
