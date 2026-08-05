import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/memory_repository.dart';
import '../../shared/widgets/glass_button.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../../shared/widgets/profile_avatar.dart';
import '../../shared/widgets/stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Alex Rivera');
  final _bioController = TextEditingController(text: 'Collector of quiet mornings and mountain air.');

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.unit),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                  GlassIconButton(icon: Icons.edit_outlined, onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.stackMd),
                children: [
                  const Center(child: ProfileAvatar()),
                  const SizedBox(height: AppSpacing.unit),
                  Center(
                    child: Text(
                      'Tap to change photo',
                      style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant.withValues(alpha: 0.6)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  ),
                  const SizedBox(height: AppSpacing.stackSm),
                  TextField(
                    controller: _bioController,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: theme.textTheme.bodyMedium,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  ListenableBuilder(
                    listenable: MemoryRepository.instance,
                    builder: (context, _) {
                      final repo = MemoryRepository.instance;
                      return GlassContainer(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.stackMd),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          children: [
                            StatCard(icon: Icons.auto_awesome_mosaic_outlined, value: '${repo.totalMemories}', label: 'Memories'),
                            StatCard(icon: Icons.photo_library_outlined, value: '${repo.totalPhotos}', label: 'Photos'),
                            StatCard(icon: Icons.sell_outlined, value: '${repo.totalTags}', label: 'Tags'),
                            StatCard(
                              icon: Icons.calendar_month_outlined,
                              value: '${repo.firstMemoryYear ?? '—'}',
                              label: 'First Memory',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  Row(
                    children: [
                      Expanded(child: GlassButton(label: 'Backup', icon: Icons.backup_outlined, expand: true, onPressed: () {})),
                      const SizedBox(width: AppSpacing.stackSm),
                      Expanded(child: GlassButton(label: 'Restore', icon: Icons.restore_outlined, expand: true, onPressed: () {})),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  GlassContainer(
                    borderRadius: AppRadius.md,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.stackMd),
                    child: Column(
                      children: [
                        Text('NESTORY', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 3)),
                        const SizedBox(height: 4),
                        Text('Version 1.0.0', style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant.withValues(alpha: 0.5))),
                      ],
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
