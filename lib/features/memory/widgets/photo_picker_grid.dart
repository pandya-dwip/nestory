import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/photo_display_mode.dart';
import '../../../shared/widgets/app_photo.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/glass_icon_button.dart';
import 'photo_display_mode_sheet.dart';

const maxMemoryPhotos = 5;

/// Cover image + horizontal thumbnail row for the Create/Edit screen.
/// Empty state shows the big "Add Photos" upload prompt; once photos exist,
/// the first one is the large cover (badged "Cover") with the rest —
/// plus an add tile while under [maxMemoryPhotos] — as thumbnails below.
class PhotoPickerGrid extends StatelessWidget {
  const PhotoPickerGrid({
    super.key,
    required this.photoUrls,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    required this.onMakeCover,
    this.coverDisplayMode = PhotoDisplayMode.fill,
    this.onChangeCoverDisplayMode,
    this.busy = false,
  });

  final List<String> photoUrls;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemovePhoto;
  final ValueChanged<int> onMakeCover;

  /// How the cover (first) photo is currently fitted — a per-photo choice,
  /// changed via the aspect-ratio control on the cover preview.
  final PhotoDisplayMode coverDisplayMode;
  final ValueChanged<PhotoDisplayMode>? onChangeCoverDisplayMode;

  /// True while a picked photo is being copied into app storage — swaps
  /// the add affordance for a spinner so a second tap can't queue up.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    if (photoUrls.isEmpty) {
      return GestureDetector(
        onTap: busy ? null : onAddPhoto,
        child: GlassContainer(
          borderRadius: AppRadius.xl,
          alignment: Alignment.center,
          child: SizedBox(
            height: 320,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (busy)
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colors.onSurface.withValues(alpha: 0.6)),
                  )
                else
                  Icon(Icons.add_photo_alternate_outlined, size: 56, color: colors.onSurface.withValues(alpha: 0.4)),
                const SizedBox(height: AppSpacing.stackSm),
                Text('Add Photos', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('Maximum $maxMemoryPhotos photos', style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: DecoratedBox(
                  decoration: BoxDecoration(border: Border.all(color: colors.glassBorder.withValues(alpha: 0.1))),
                  child: AppPhoto(url: photoUrls.first, fit: coverDisplayMode.boxFit),
                ),
              ),
              const Positioned(
                left: AppSpacing.stackSm,
                top: AppSpacing.stackSm,
                child: _CoverBadge(),
              ),
              if (onChangeCoverDisplayMode != null)
                Positioned(
                  right: AppSpacing.stackSm,
                  top: AppSpacing.stackSm,
                  child: GlassIconButton(
                    icon: Icons.aspect_ratio,
                    size: 40,
                    semanticLabel: 'Cover display mode',
                    onPressed: () async {
                      final mode = await showPhotoDisplayModeSheet(context, coverDisplayMode);
                      if (mode != null) onChangeCoverDisplayMode!(mode);
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.stackSm),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length + (photoUrls.length < maxMemoryPhotos ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.stackSm),
            itemBuilder: (context, index) {
              if (index == photoUrls.length) {
                return GestureDetector(
                  onTap: busy ? null : onAddPhoto,
                  child: GlassContainer(
                    borderRadius: AppRadius.md,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: busy
                          ? Padding(
                              padding: const EdgeInsets.all(24),
                              child: CircularProgressIndicator(strokeWidth: 2, color: colors.onSurface.withValues(alpha: 0.6)),
                            )
                          : Icon(Icons.add, color: colors.onSurface.withValues(alpha: 0.6)),
                    ),
                  ),
                );
              }

              final isCover = index == 0;
              return GestureDetector(
                onTap: () => onMakeCover(index),
                onLongPress: () => onRemovePhoto(index),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: SizedBox(
                        width: 76,
                        height: 76,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isCover ? colors.onSurface.withValues(alpha: 0.8) : colors.glassBorder.withValues(alpha: 0.1),
                              width: isCover ? 1.5 : 1,
                            ),
                          ),
                          child: AppPhoto(url: photoUrls[index]),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: GestureDetector(
                        onTap: () => onRemovePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.stackSm),
        Center(
          child: Text('${photoUrls.length} / $maxMemoryPhotos', style: theme.textTheme.labelSmall),
        ),
      ],
    );
  }
}

class _CoverBadge extends StatelessWidget {
  const _CoverBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.unit + 2, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Text(
        'COVER',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.primary, fontSize: 10),
      ),
    );
  }
}
