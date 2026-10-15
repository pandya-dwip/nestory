import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark() => _build(NestoryColors.dark, Brightness.dark);

  static ThemeData light() => _build(NestoryColors.light, Brightness.light);

  static ThemeData _build(NestoryColors colors, Brightness brightness) {
    final textTheme = AppTypography.textTheme(
      colors.onSurface,
      colors.onSurfaceVariant,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.void_,
      canvasColor: colors.void_,
      fontFamily: AppTypography.fontBody,
      textTheme: textTheme,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        error: colors.error,
        onError: colors.surface,
        surface: colors.surface,
        onSurface: colors.onSurface,
        outline: colors.outline,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: [colors],
    );
  }
}
