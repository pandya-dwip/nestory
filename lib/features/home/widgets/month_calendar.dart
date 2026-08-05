import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/repositories/memory_repository.dart';
import '../../../shared/models/photo_display_mode.dart';
import '../../../shared/widgets/date_circle.dart';
import 'month_year_picker_sheet.dart';

const _weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

/// One full month page: an independently-selectable month/year header,
/// weekday header, and a circular-cell grid. Presented inside a vertical
/// [PageView] on the Home screen so swiping up or down pages between
/// months — the header always reflects whichever page is current, and
/// picking a month or year from its dropdown scrolls the calendar there
/// (via [onSelectMonth]/[onSelectYear], handled by the parent that owns
/// the [PageController]).
class MonthCalendarPage extends StatelessWidget {
  const MonthCalendarPage({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onSelectMonth,
    required this.onSelectYear,
    required this.minYear,
    required this.maxYear,
  });

  final DateTime month;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<int> onSelectMonth;
  final ValueChanged<int> onSelectYear;
  final int minYear;
  final int maxYear;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = DateTime(month.year, month.month, 1).weekday % 7; // Sun=0
    final monthStyle = Theme.of(context).textTheme.displayLarge?.copyWith(letterSpacing: 6);
    final yearStyle = monthStyle?.copyWith(
      fontSize: 19,
      letterSpacing: 2,
      color: monthStyle.color?.withValues(alpha: 0.55),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        100,
        AppSpacing.gutter,
        AppSpacing.stackLg,
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                GestureDetector(
                  onTap: () async {
                    final selected = await showMonthPickerSheet(context, month.month);
                    if (selected != null) onSelectMonth(selected);
                  },
                  child: Text(monthNames[month.month - 1].toUpperCase(), style: monthStyle),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final selected = await showYearPickerSheet(
                      context,
                      currentYear: month.year,
                      minYear: minYear,
                      maxYear: maxYear,
                    );
                    if (selected != null) onSelectYear(selected);
                  },
                  child: Text('${month.year}', style: yearStyle),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.stackLg),
          Row(
            children: _weekdayLabels
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.stackMd),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalCells = leading + daysInMonth;
                final rows = (totalCells / 7).ceil();
                const columnSpacing = AppSpacing.unit; // tight column gap so circles use full width

                // Circle size is bound by the 7-column width — that's always
                // the tighter constraint than row height. Row spacing then
                // expands to consume whatever vertical room is left, so the
                // grid always fills the available height edge-to-edge with
                // no dead space below the last row, for every month (4-6
                // rows), instead of leaving leftover height unused.
                final cellSize = math.min(
                  (constraints.maxWidth - columnSpacing * 6) / 7,
                  constraints.maxHeight / rows,
                );
                // Fill most (not all) of the leftover height as row gaps —
                // a little breathing room, but not the full amount, so a
                // small margin is left below the last row instead of none.
                const rowFillFactor = 0.75;
                final rowSpacing =
                    rows > 1 ? (constraints.maxHeight - rows * cellSize) / (rows - 1) * rowFillFactor : 0.0;
                final gridHeight = rows * cellSize + (rows - 1) * rowSpacing;

                final gridWidth = 7 * cellSize + 6 * columnSpacing;

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: gridWidth,
                    height: gridHeight,
                    child: GridView.builder(
                      primary: false,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: rowSpacing,
                        crossAxisSpacing: columnSpacing,
                        childAspectRatio: 1,
                      ),
                      itemCount: rows * 7,
                      itemBuilder: (context, index) {
                        final dayNum = index - leading + 1;
                        if (dayNum < 1 || dayNum > daysInMonth) return const SizedBox.shrink();

                        final date = DateTime(month.year, month.month, dayNum);
                        final dayMemories = MemoryRepository.instance.onDate(date);
                        final selected = selectedDate != null &&
                            selectedDate!.year == date.year &&
                            selectedDate!.month == date.month &&
                            selectedDate!.day == date.day;

                        return Center(
                          child: DateCircle(
                            day: dayNum,
                            coverUrl: dayMemories.isNotEmpty ? dayMemories.first.coverUrl : null,
                            coverDisplayMode:
                                dayMemories.isNotEmpty ? dayMemories.first.coverDisplayMode : PhotoDisplayMode.fill,
                            selected: selected,
                            onTap: () => onSelectDate(date),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
