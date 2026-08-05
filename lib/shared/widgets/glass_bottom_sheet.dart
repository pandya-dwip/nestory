import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_icon_button.dart';

/// Rounded-top glass sheet chrome (drag handle, title/subtitle header,
/// close button) wrapping arbitrary scrollable content. Use
/// [GlassBottomSheet.show] to present it as a modal.
class GlassBottomSheet extends StatelessWidget {
  const GlassBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onClose,
    this.heightFactor = 0.68,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onClose;
  final double heightFactor;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    required WidgetBuilder builder,
    double heightFactor = 0.68,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassBottomSheet(
        title: title,
        subtitle: subtitle,
        heightFactor: heightFactor,
        onClose: () => Navigator.of(context).pop(),
        child: builder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * heightFactor,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.55),
              border: Border(top: BorderSide(color: colors.glassBorder.withValues(alpha: 0.15))),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.stackSm, bottom: AppSpacing.unit),
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.outline.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding).copyWith(bottom: AppSpacing.stackSm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: theme.textTheme.headlineMedium),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(subtitle!, style: theme.textTheme.bodyMedium),
                              ],
                            ],
                          ),
                        ),
                        GlassIconButton(icon: Icons.close, onPressed: onClose, size: 40),
                      ],
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
