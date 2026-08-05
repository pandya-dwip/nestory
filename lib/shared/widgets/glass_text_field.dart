import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Minimalist glass input trough: a floating Geist-caps label above a
/// bottom-hairline field, per DESIGN.md's "Input Fields" component spec.
class GlassTextField extends StatelessWidget {
  const GlassTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.maxLines = 1,
    this.textStyle,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final int maxLines;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final style = textStyle ?? theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(height: AppSpacing.stackSm),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: style,
          cursorColor: colors.onSurface,
          cursorWidth: 1,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: style?.copyWith(color: colors.onSurface.withValues(alpha: 0.3)),
            contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.stackSm),
            border: UnderlineInputBorder(borderSide: BorderSide(color: colors.glassBorder.withValues(alpha: 0.15))),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.glassBorder.withValues(alpha: 0.15))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.glassBorder.withValues(alpha: 0.5))),
          ),
        ),
      ],
    );
  }
}
