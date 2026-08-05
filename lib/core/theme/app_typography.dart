import 'package:flutter/material.dart';

/// Type scale from DESIGN.md. Font families are referenced by name only —
/// bundle the Manrope/Inter/Geist font assets later and register them in
/// pubspec.yaml; until then the platform falls back to its default font.
class AppTypography {
  const AppTypography._();

  static const fontDisplay = 'Manrope';
  static const fontBody = 'Inter';
  static const fontLabel = 'Geist';

  static TextTheme textTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      // display-lg, scaled down for phone per DESIGN.md's mobile guidance.
      displayLarge: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 48,
        height: 56 / 48,
        fontWeight: FontWeight.w200,
        letterSpacing: -0.02 * 48,
        color: onSurface,
      ),
      // headline-lg
      headlineLarge: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.01 * 32,
        color: onSurface,
      ),
      // headline-lg-mobile
      headlineMedium: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w300,
        color: onSurface,
      ),
      // body-md
      bodyMedium: TextStyle(
        fontFamily: fontBody,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.01 * 16,
        color: onSurfaceVariant,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontBody,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.01 * 16,
        color: onSurface,
      ),
      // label-sm
      labelSmall: TextStyle(
        fontFamily: fontLabel,
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1 * 12,
        color: onSurfaceVariant,
      ),
    );
  }
}
