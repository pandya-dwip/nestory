/// Spacing tokens — mirrors DESIGN.md `spacing` scale (8px linear rhythm).
class AppSpacing {
  const AppSpacing._();

  static const double unit = 8;
  static const double stackSm = 12;
  static const double stackMd = 24;
  static const double stackLg = 48;
  static const double gutter = 24;
  static const double containerPadding =
      24; // scaled down from 40 desktop for phone width
}
