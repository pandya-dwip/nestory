import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../models/memory.dart';
import 'app_photo.dart';

/// A single memory in a list — cover image with a photo-count badge, title,
/// short description, and (optionally) date. Used inside the Memory
/// Bottom Sheet's card list.
class MemoryCard extends StatelessWidget {
  const MemoryCard({super.key, required this.memory, this.onTap, this.showDate = false});

  final Memory memory;
  final VoidCallback? onTap;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(border: Border.all(color: colors.outline.withValues(alpha: 0.1))),
                    child: AppPhoto(url: memory.coverUrl, fit: memory.coverDisplayMode.boxFit),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppSpacing.stackSm,
                    bottom: AppSpacing.stackSm,
                    child: _PhotoCountBadge(count: memory.photoCount),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.stackSm),
          Text(memory.title, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          if (showDate) ...[
            Text(_formatDate(memory.date), style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
          ],
          Text(
            memory.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _PhotoCountBadge extends StatelessWidget {
  const _PhotoCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.unit + 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_library_outlined, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text('$count', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
