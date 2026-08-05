import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/repositories/memory_repository.dart';
import '../../../shared/widgets/date_circle.dart';

const _weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const _monthLabels = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// One full month page: title, weekday header, and a circular-cell grid.
/// Presented inside a vertical [PageView] on the Home screen so swiping up
/// or down pages between months.
class MonthCalendarPage extends StatelessWidget {
  const MonthCalendarPage({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.onSelectDate,
  });

  final DateTime month;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = DateTime(month.year, month.month, 1).weekday % 7; // Sun=0

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        100,
        AppSpacing.gutter,
        AppSpacing.stackLg,
      ),
      child: Column(
        children: [
          Text(
            _monthLabels[month.month - 1].toUpperCase(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(letterSpacing: 6),
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
                final rows = (totalCells / 7).ceil().clamp(1, 6);
                const spacing = AppSpacing.unit;
                final cellWidth = (constraints.maxWidth - spacing * 6) / 7;
                final cellHeight = (constraints.maxHeight - spacing * (rows - 1)) / rows;

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: cellWidth / cellHeight,
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
                        selected: selected,
                        onTap: () => onSelectDate(date),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
