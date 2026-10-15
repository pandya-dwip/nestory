import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/db/calendar/calendar_database.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_bottom_sheet.dart';
import '../../../shared/widgets/glass_card.dart';

/// Bottom sheet displaying sync conflicts where a remote event changed while
/// an offline edit was pending. Preserves recoverable information about the rejected edit.
class ConflictHistorySheet extends StatefulWidget {
  const ConflictHistorySheet({super.key});

  static Future<void> show(BuildContext context) {
    return GlassBottomSheet.show(
      context,
      title: 'SYNC CONFLICTS',
      subtitle: 'Recoverable offline edits overridden by server changes',
      builder: (context) => const ConflictHistorySheet(),
    );
  }

  @override
  State<ConflictHistorySheet> createState() => _ConflictHistorySheetState();
}

class _ConflictHistorySheetState extends State<ConflictHistorySheet> {
  List<SyncConflictEntity> _conflicts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await CalendarDatabase.instance().syncConflictsDao
        .getAllConflicts();
    if (mounted) {
      setState(() {
        _conflicts = list;
        _loading = false;
      });
    }
  }

  Future<void> _dismiss(int id) async {
    await CalendarDatabase.instance().syncConflictsDao.dismissConflict(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_conflicts.isEmpty) {
      return const EmptyState(
        'No sync conflicts. All offline edits synced cleanly.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.stackLg,
      ),
      itemCount: _conflicts.length,
      separatorBuilder: (_, index) =>
          const SizedBox(height: AppSpacing.stackSm),
      itemBuilder: (context, index) {
        final conflict = _conflicts[index];
        Map<String, dynamic> localPayload = {};
        try {
          localPayload =
              jsonDecode(conflict.localPayloadJson) as Map<String, dynamic>;
        } catch (_) {}

        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.stackSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        conflict.eventTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, size: 18),
                      tooltip: 'Dismiss conflict',
                      onPressed: () => _dismiss(conflict.id),
                    ),
                  ],
                ),
                Text(
                  conflict.conflictReason,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your rejected offline edit:',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                if (localPayload.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (localPayload['title'] != null)
                          Text(
                            'Title: ${localPayload['title']}',
                            style: theme.textTheme.bodySmall,
                          ),
                        if (localPayload['description'] != null &&
                            localPayload['description'].toString().isNotEmpty)
                          Text(
                            'Notes: ${localPayload['description']}',
                            style: theme.textTheme.bodySmall,
                          ),
                        if (localPayload['location'] != null &&
                            localPayload['location'].toString().isNotEmpty)
                          Text(
                            'Location: ${localPayload['location']}',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
