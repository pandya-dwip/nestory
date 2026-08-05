import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_container.dart';

enum GlassButtonVariant { primary, secondary }

/// Pill-shaped button. `primary` is solid fill with inverted text (the
/// "Save" / "Add Memory" action); `secondary` is glass-filled with a
/// hairline border (e.g. "Camera" / "Gallery" / "Backup").
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = GlassButtonVariant.secondary,
    this.expand = false,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final GlassButtonVariant variant;
  final bool expand;

  /// Overrides the label/icon color — e.g. [NestoryColors.error] for a
  /// destructive confirm action.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foregroundColor ?? (variant == GlassButtonVariant.primary ? colors.onPrimary : colors.onSurface),
        );

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: labelStyle?.color),
          const SizedBox(width: AppSpacing.unit),
        ],
        Text(label.toUpperCase(), style: labelStyle),
      ],
    );

    final padding = const EdgeInsets.symmetric(horizontal: AppSpacing.stackMd, vertical: AppSpacing.stackSm + 4);

    final button = variant == GlassButtonVariant.primary
        ? Container(
            padding: padding,
            decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(AppRadius.full)),
            child: content,
          )
        : GlassContainer(
            borderRadius: AppRadius.full,
            padding: padding,
            child: content,
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: button,
      ),
    );
  }
}
