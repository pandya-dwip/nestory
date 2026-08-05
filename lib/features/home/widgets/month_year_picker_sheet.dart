import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/glass_bottom_sheet.dart';
import '../../settings/widgets/settings_tile.dart';

const monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const _estimatedRowHeight = 64.0;

/// Month picker (1-12) — returns the chosen month, or null if dismissed.
Future<int?> showMonthPickerSheet(BuildContext context, int currentMonth) {
  return GlassBottomSheet.show<int>(
    context,
    title: 'Select Month',
    heightFactor: 0.6,
    builder: (context) => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      controller: ScrollController(initialScrollOffset: (currentMonth - 3).clamp(0, 12) * _estimatedRowHeight),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        return SettingsTile(
          icon: Icons.calendar_today_outlined,
          title: monthNames[index],
          trailing: month == currentMonth ? const Icon(Icons.check) : const SizedBox.shrink(),
          onTap: () => Navigator.of(context).pop(month),
        );
      },
    ),
  );
}

/// Year picker within [minYear]..[maxYear] inclusive — returns the chosen
/// year, or null if dismissed.
Future<int?> showYearPickerSheet(
  BuildContext context, {
  required int currentYear,
  required int minYear,
  required int maxYear,
}) {
  final years = [for (var y = maxYear; y >= minYear; y--) y];
  final selectedIndex = years.indexOf(currentYear);

  return GlassBottomSheet.show<int>(
    context,
    title: 'Select Year',
    heightFactor: 0.6,
    builder: (context) => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      controller: ScrollController(
        initialScrollOffset: ((selectedIndex < 0 ? 0 : selectedIndex) - 3).clamp(0, years.length) * _estimatedRowHeight,
      ),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        return SettingsTile(
          icon: Icons.calendar_month_outlined,
          title: '$year',
          trailing: year == currentYear ? const Icon(Icons.check) : const SizedBox.shrink(),
          onTap: () => Navigator.of(context).pop(year),
        );
      },
    ),
  );
}
