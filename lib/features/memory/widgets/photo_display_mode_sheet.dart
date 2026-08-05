import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/photo_display_mode.dart';
import '../../../shared/widgets/glass_bottom_sheet.dart';
import '../../settings/widgets/settings_tile.dart';

const _icons = {
  PhotoDisplayMode.fill: Icons.crop,
  PhotoDisplayMode.fit: Icons.fit_screen_outlined,
  PhotoDisplayMode.landscapePriority: Icons.panorama_outlined,
  PhotoDisplayMode.portraitPriority: Icons.crop_portrait_outlined,
};

/// "How should this photo be shown?" — Fill / Fit / Landscape / Portrait
/// priority, in the same glass sheet chrome used elsewhere. Returns the
/// chosen mode, or null if the user dismisses without choosing.
Future<PhotoDisplayMode?> showPhotoDisplayModeSheet(BuildContext context, PhotoDisplayMode current) {
  return GlassBottomSheet.show<PhotoDisplayMode>(
    context,
    title: 'Cover Display',
    heightFactor: 0.42,
    builder: (context) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      children: [
        for (final mode in PhotoDisplayMode.values)
          SettingsTile(
            icon: _icons[mode]!,
            title: mode.label,
            trailing: mode == current ? const Icon(Icons.check) : const SizedBox.shrink(),
            onTap: () => Navigator.of(context).pop(mode),
          ),
      ],
    ),
  );
}
