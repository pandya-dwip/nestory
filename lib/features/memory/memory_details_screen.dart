import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/memory_repository.dart';
import '../../shared/models/memory.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_dialog.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../../shared/widgets/photo_carousel.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/tag_chip.dart';
import 'create_edit_memory_screen.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Shows [initialMemory] and stays live-synced to the repository by id, so
/// an edit made on the Create/Edit screen (or a favorite toggle here)
/// reflects immediately without needing to re-navigate.
class MemoryDetailsScreen extends StatelessWidget {
  const MemoryDetailsScreen({super.key, required Memory memory}) : initialMemory = memory;

  final Memory initialMemory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: MemoryRepository.instance,
      builder: (context, _) {
        final memory = MemoryRepository.instance.byId(initialMemory.id) ?? initialMemory;

        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.unit),
                      child: Row(
                        children: [
                          GlassIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                          Expanded(
                            child: Text(
                              'NESTORY',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, letterSpacing: 4),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.stackSm),
                    PhotoCarousel(photoUrls: memory.photoUrls),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.gutter,
                          AppSpacing.stackMd,
                          AppSpacing.gutter,
                          140,
                        ),
                        children: [
                          Text(memory.title, style: theme.textTheme.headlineLarge),
                          const SizedBox(height: 8),
                          Text(_formatDate(memory.date), style: theme.textTheme.labelSmall),
                          const SizedBox(height: AppSpacing.stackMd),
                          const SectionTitle('Description', dim: true),
                          const SizedBox(height: AppSpacing.stackSm),
                          Text(memory.description, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.stackMd),
                          const SectionTitle('Tags', dim: true),
                          const SizedBox(height: AppSpacing.stackSm),
                          Wrap(
                            spacing: AppSpacing.stackSm,
                            runSpacing: AppSpacing.stackSm,
                            children: [for (final tag in memory.tags) TagChip(label: tag)],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: AppSpacing.stackMd,
                left: 0,
                right: 0,
                child: Center(
                  child: GlassContainer(
                    active: true,
                    borderRadius: AppRadius.full,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackLg, vertical: AppSpacing.stackSm),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GlassIconButton(
                          icon: memory.isFavorite ? Icons.favorite : Icons.favorite_border,
                          onPressed: () => MemoryRepository.instance.toggleFavorite(memory.id),
                        ),
                        const SizedBox(width: AppSpacing.stackMd),
                        GlassIconButton(
                          icon: Icons.edit_outlined,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => CreateEditMemoryScreen(memory: memory)),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.stackMd),
                        GlassIconButton(
                          icon: Icons.delete_outline,
                          onPressed: () async {
                            final confirmed = await GlassDialog.show(
                              context,
                              title: 'Delete Memory?',
                              message: 'This will permanently remove "${memory.title}" and its photos.',
                              confirmLabel: 'Delete',
                              destructive: true,
                            );
                            if (confirmed != true) return;
                            await MemoryRepository.instance.delete(memory.id);
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]} ${date.year}'.toUpperCase();
  }
}
