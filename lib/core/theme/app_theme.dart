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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
        },
      ),
      extensions: [colors],
    );
  }
}

/// Snappy, non-laggy page transition with gentle 6% slide and cubic fade.
/// Avoids heavy Android ZoomPageTransitions matrix rasterization overhead.
class _SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  const _SmoothPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final secondaryCurved = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final secondarySlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.04, 0),
    ).animate(secondaryCurved);

    final primarySlide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(curvedAnimation);

    return RepaintBoundary(
      child: SlideTransition(
        position: secondarySlide,
        child: SlideTransition(
          position: primarySlide,
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        ),
      ),
    );
  }
}
