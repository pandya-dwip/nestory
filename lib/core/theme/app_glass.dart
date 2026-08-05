/// Glassmorphism tokens — blur radii and fill/border opacities per DESIGN.md
/// "Elevation & Depth" and Stitch `.glass-panel` / `.glass-panel-active` classes.
class AppGlass {
  const AppGlass._();

  // Level 1 — resting glass (30px blur, 3% fill, 10% border).
  static const double blurLow = 30;
  static const double fillOpacityLow = 0.03;
  static const double borderOpacityLow = 0.10;

  // Level 2 — active/floating glass (50px blur, 5-6% fill, 20% border).
  static const double blurHigh = 50;
  static const double fillOpacityHigh = 0.06;
  static const double borderOpacityHigh = 0.20;

  // Focused memory-pod border per "Cards" component spec.
  static const double borderOpacityFocused = 0.40;
}
