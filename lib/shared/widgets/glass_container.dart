import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_glass.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_colors.dart';

/// The base "glass plate" every other glass component is built from —
/// heavy backdrop blur, translucent fill, and a hairline border, per
/// DESIGN.md's Glassmorphism / Optical Refraction rules.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppRadius.lg,
    this.active = false,
    this.blur,
    this.fillOpacity,
    this.borderOpacity,
    this.borderColor,
    this.alignment,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  /// Level-2 "focused" glass: brighter fill, heavier blur, inner glow.
  final bool active;

  final double? blur;
  final double? fillOpacity;
  final double? borderOpacity;
  final Color? borderColor;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveBlur = blur ?? (active ? AppGlass.blurHigh : AppGlass.blurLow);
    final effectiveFill = fillOpacity ?? (active ? AppGlass.fillOpacityHigh : AppGlass.fillOpacityLow);
    final effectiveBorderOpacity = borderOpacity ?? (active ? AppGlass.borderOpacityHigh : AppGlass.borderOpacityLow);
    final effectiveBorderColor = borderColor ?? colors.glassBorder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          alignment: alignment,
          padding: padding,
          decoration: BoxDecoration(
            color: colors.onSurface.withValues(alpha: effectiveFill),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: effectiveBorderColor.withValues(alpha: effectiveBorderOpacity),
              width: 1,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: colors.onSurface.withValues(alpha: 0.1),
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
