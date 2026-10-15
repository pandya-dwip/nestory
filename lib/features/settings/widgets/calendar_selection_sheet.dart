import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/db/calendar/calendar_database.dart';
import '../../../data/repositories/calendar_event_repository.dart';
import '../../../data/services/calendar_sync_service.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_bottom_sheet.dart';

/// Modal sheet allowing the user to toggle which Google Calendars to display
/// and synchronize within Nestory.
class CalendarSelectionSheet extends StatefulWidget {
  const CalendarSelectionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return GlassBottomSheet.show(
      context,
      title: 'SELECT CALENDARS',
      subtitle: 'Choose which calendars appear in Nestory',
      builder: (context) => const CalendarSelectionSheet(),
    );
  }

  @override
  State<CalendarSelectionSheet> createState() => _CalendarSelectionSheetState();
}

class _CalendarSelectionSheetState extends State<CalendarSelectionSheet> {
  List<CalendarMetaEntity> _calendars = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await CalendarDatabase.instance().calendarsMetaDao
        .getAllCalendars();
    if (mounted) {
      setState(() {
        _calendars = list;
        _loading = false;
      });
    }
  }

  Future<void> _toggle(CalendarMetaEntity cal, bool val) async {
    await CalendarDatabase.instance().calendarsMetaDao.setCalendarSelected(
      cal.googleCalendarId,
      val,
    );
    await CalendarEventRepository.instance.reload();
    await _load();
    CalendarSyncService.instance.triggerOutboxDrain();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_calendars.isEmpty) {
      return const EmptyState(
        'No calendars discovered. Tap "Sync Now" in Settings to fetch calendars.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.stackLg,
      ),
      itemCount: _calendars.length,
      separatorBuilder: (_, index) => const Divider(height: 12, thickness: 0.5),
      itemBuilder: (context, index) {
        final cal = _calendars[index];
        Color dotColor = colors.primary;
        if (cal.colorHex != null && cal.colorHex!.isNotEmpty) {
          try {
            final hex = cal.colorHex!.replaceFirst('#', '');
            dotColor = Color(int.parse('0xFF$hex'));
          } catch (_) {}
        }

        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeTrackColor: colors.primary,
          title: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
              const SizedBox(width: AppSpacing.stackSm),
              Expanded(
                child: Text(
                  cal.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (cal.isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colors.surfaceContainer,
                  ),
                  child: Text(
                    'Primary',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colors.outlineVariant,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: cal.description.isNotEmpty
              ? Text(
                  cal.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          value: cal.isSelected,
          onChanged: (val) => _toggle(cal, val),
        );
      },
    );
  }
}
