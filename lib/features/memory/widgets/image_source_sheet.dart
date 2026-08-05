import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/glass_bottom_sheet.dart';
import '../../settings/widgets/settings_tile.dart';

/// "Choose Image Source" glass sheet — Camera / Gallery — reusing the same
/// [GlassBottomSheet] chrome and row styling as the rest of the app.
/// Returns the chosen [ImageSource], or null if the user cancels.
Future<ImageSource?> showImageSourceSheet(BuildContext context) {
  return GlassBottomSheet.show<ImageSource>(
    context,
    title: 'Choose Image Source',
    heightFactor: 0.32,
    builder: (context) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      children: [
        SettingsTile(
          icon: Icons.photo_camera_outlined,
          title: 'Camera',
          trailing: const SizedBox.shrink(),
          onTap: () => Navigator.of(context).pop(ImageSource.camera),
        ),
        SettingsTile(
          icon: Icons.photo_library_outlined,
          title: 'Gallery',
          trailing: const SizedBox.shrink(),
          onTap: () => Navigator.of(context).pop(ImageSource.gallery),
        ),
        SettingsTile(
          icon: Icons.close,
          title: 'Cancel',
          trailing: const SizedBox.shrink(),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
