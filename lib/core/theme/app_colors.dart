import 'package:flutter/material.dart';

/// "Obsidian Ethereal" palette as a [ThemeExtension] so every widget reads
/// colors from `Theme.of(context)` instead of hardcoding hex values.
@immutable
class NestoryColors extends ThemeExtension<NestoryColors> {
  const NestoryColors({
    required this.void_,
    required this.surface,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.primary,
    required this.onPrimary,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.glassBorder,
  });

  /// Pure void background (`#050505`) — the canvas glass floats above.
  final Color void_;
  final Color surface;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color primary;
  final Color onPrimary;
  final Color outline;
  final Color outlineVariant;
  final Color error;

  /// Semi-transparent white/black hairline used to edge glass (`rgba(_, 0.15)`).
  final Color glassBorder;

  static const dark = NestoryColors(
    void_: Color(0xFF050505),
    surface: Color(0xFF131313),
    surfaceDim: Color(0xFF131313),
    surfaceBright: Color(0xFF3A3939),
    surfaceContainerLowest: Color(0xFF0E0E0E),
    surfaceContainerLow: Color(0xFF1C1B1B),
    surfaceContainer: Color(0xFF201F1F),
    surfaceContainerHigh: Color(0xFF2A2A2A),
    surfaceContainerHighest: Color(0xFF353534),
    onSurface: Color(0xFFE5E2E1),
    onSurfaceVariant: Color(0xFFC4C7C8),
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF2F3131),
    outline: Color(0xFF8E9192),
    outlineVariant: Color(0xFF444748),
    error: Color(0xFFFFB4AB),
    glassBorder: Color(0xFFFFFFFF),
  );

  /// Light-mode mirror: same monochrome structure, inverted luminance.
  static const light = NestoryColors(
    void_: Color(0xFFF4F3F2),
    surface: Color(0xFFFCFBFA),
    surfaceDim: Color(0xFFEAE8E7),
    surfaceBright: Color(0xFFFCFBFA),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF6F5F4),
    surfaceContainer: Color(0xFFF0EFED),
    surfaceContainerHigh: Color(0xFFE9E7E6),
    surfaceContainerHighest: Color(0xFFE3E1DF),
    onSurface: Color(0xFF1B1B1B),
    onSurfaceVariant: Color(0xFF454747),
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xFF767979),
    outlineVariant: Color(0xFFC4C7C8),
    error: Color(0xFFBA1A1A),
    glassBorder: Color(0xFF000000),
  );

  @override
  NestoryColors copyWith({
    Color? void_,
    Color? surface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? primary,
    Color? onPrimary,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? glassBorder,
  }) {
    return NestoryColors(
      void_: void_ ?? this.void_,
      surface: surface ?? this.surface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      glassBorder: glassBorder ?? this.glassBorder,
    );
  }

  @override
  NestoryColors lerp(ThemeExtension<NestoryColors>? other, double t) {
    if (other is! NestoryColors) return this;
    return NestoryColors(
      void_: Color.lerp(void_, other.void_, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
    );
  }
}

extension NestoryColorsX on BuildContext {
  NestoryColors get colors => Theme.of(this).extension<NestoryColors>()!;
}
