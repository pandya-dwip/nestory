import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/memory.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_button.dart';
import '../../../shared/widgets/memory_card.dart';

/// Scrollable body of the Memory Bottom Sheet: an "Add Memory" action
/// followed by the list of memories saved on the selected date.
class MemorySheetContent extends StatelessWidget {
  const MemorySheetContent({
    super.key,
    required this.memories,
    required this.onAddMemory,
    required this.onOpenMemory,
  });

  final List<Memory> memories;
  final VoidCallback onAddMemory;
  final ValueChanged<Memory> onOpenMemory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.stackLg,
      ),
      children: [
        GlassButton(
          label: 'Add Memory',
          icon: Icons.add,
          variant: GlassButtonVariant.primary,
          expand: true,
          onPressed: onAddMemory,
        ),
        const SizedBox(height: AppSpacing.stackMd),
        if (memories.isEmpty)
          const EmptyState('No memories saved on this day yet.')
        else
          for (final memory in memories) ...[
            MemoryCard(memory: memory, onTap: () => onOpenMemory(memory)),
            const SizedBox(height: AppSpacing.stackMd),
          ],
      ],
    );
  }
}
