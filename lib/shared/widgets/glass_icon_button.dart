import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'glass_container.dart';

/// Circular icon button used across app bars — plain (transparent, for
/// dense bars like Home's top-right actions) or `glass` (e.g. back button
/// on Add/Edit).
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.glass = false,
    this.size = 48,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool glass;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconWidget = Icon(
      icon,
      color: colors.onSurface,
      size: size * 0.42,
      semanticLabel: semanticLabel,
    );

    final child = glass
        ? GlassContainer(
            borderRadius: size,
            alignment: Alignment.center,
            child: SizedBox(
              width: size,
              height: size,
              child: Center(child: iconWidget),
            ),
          )
        : SizedBox(
            width: size,
            height: size,
            child: Center(child: iconWidget),
          );

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: child,
      ),
    );
  }
}
