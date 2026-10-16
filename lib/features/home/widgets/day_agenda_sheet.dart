import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/repositories/calendar_event_repository.dart';
import '../../../data/repositories/memory_repository.dart';
import '../../../shared/models/calendar_event.dart';
import '../../../shared/models/memory.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/memory_card.dart';
import '../../../shared/widgets/section_title.dart';

/// Unified bottom sheet displaying both scheduled Calendar Events and
/// personal Memories for the selected day.
class DayAgendaSheet extends StatelessWidget {
  const DayAgendaSheet({
    super.key,
    required this.date,
    required this.memories,
    required this.events,
    required this.onAddMemory,
    required this.onAddEvent,
    required this.onOpenMemory,
    required this.onOpenEvent,
  });

  final DateTime date;
  final List<Memory> memories;
  final List<CalendarEvent> events;
  final VoidCallback onAddMemory;
  final VoidCallback onAddEvent;
  final ValueChanged<Memory> onOpenMemory;
  final ValueChanged<CalendarEvent> onOpenEvent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([
        MemoryRepository.instance,
        CalendarEventRepository.instance,
      ]),
      builder: (context, _) {
        final activeMemories = MemoryRepository.instance.onDate(date);
        final activeEvents = CalendarEventRepository.instance.onDate(date);

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            AppSpacing.stackLg,
          ),
          children: [
            // Side-by-side action buttons
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    label: 'Add Memory',
                    icon: Icons.add_photo_alternate_outlined,
                    variant: GlassButtonVariant.primary,
                    onPressed: onAddMemory,
                  ),
                ),
                const SizedBox(width: AppSpacing.stackSm),
                Expanded(
                  child: GlassButton(
                    label: 'Add Event',
                    icon: Icons.calendar_today_outlined,
                    variant: GlassButtonVariant.secondary,
                    onPressed: onAddEvent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackLg),

            // Section: Calendar Events
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle('SCHEDULE & EVENTS'),
                Text(
                  '${activeEvents.length} ${activeEvents.length == 1 ? 'Event' : 'Events'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.outlineVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackSm),
            if (activeEvents.isEmpty)
              const EmptyState('No events scheduled for this day.')
            else
              for (final event in activeEvents) ...[
                _EventCard(event: event, onTap: () => onOpenEvent(event)),
                const SizedBox(height: AppSpacing.stackSm),
              ],
            const SizedBox(height: AppSpacing.stackLg),

            // Section: Memories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle('MEMORIES'),
                Text(
                  '${activeMemories.length} ${activeMemories.length == 1 ? 'Memory' : 'Memories'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.outlineVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackSm),
            if (activeMemories.isEmpty)
              const EmptyState('No memories recorded on this day yet.')
            else
              for (final memory in activeMemories) ...[
                MemoryCard(memory: memory, onTap: () => onOpenMemory(memory)),
                const SizedBox(height: AppSpacing.stackMd),
              ],
          ],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    Color eventColor = colors.primary;
    if (event.calendarColorHex != null && event.calendarColorHex!.isNotEmpty) {
      try {
        final hex = event.calendarColorHex!.replaceFirst('#', '');
        eventColor = Color(int.parse('0xFF$hex'));
      } catch (_) {}
    }

    return GlassCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.stackSm,
          vertical: AppSpacing.stackSm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar accent strip
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: eventColor,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            const SizedBox(width: AppSpacing.stackSm),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 13,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.formatTimeRange(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      if (event.calendarSummary != null &&
                          event.calendarSummary!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '·',
                          style: TextStyle(color: colors.outlineVariant),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            event.calendarSummary!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.outlineVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (event.location.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: colors.outlineVariant,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            event.location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.outlineVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Sync status badge
            if (event.isPending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: colors.surfaceContainer,
                  border: Border.all(
                    color: colors.glassBorder.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync, size: 11, color: colors.outlineVariant),
                    const SizedBox(width: 4),
                    Text(
                      'Pending',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: colors.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
