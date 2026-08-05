import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/repositories/memory_repository.dart';
import '../../shared/widgets/glass_bottom_sheet.dart';
import '../../shared/widgets/glass_dialog.dart';
import '../../shared/widgets/glass_icon_button.dart';
import 'widgets/settings_tile.dart';

const _themeModeLabels = {
  ThemeMode.dark: 'Dark',
  ThemeMode.light: 'Light',
  ThemeMode.system: 'System',
};

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                children: [
                  GlassIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                  Expanded(
                    child: Text('SETTINGS', textAlign: TextAlign.center, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, letterSpacing: 4)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.stackMd),
                children: [
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeModeNotifier,
                    builder: (context, mode, _) => SettingsSection(
                      title: 'Appearance',
                      tiles: [
                        SettingsTile(
                          icon: Icons.palette_outlined,
                          title: 'Theme',
                          subtitle: _themeModeLabels[mode],
                          onTap: () => _showThemePicker(context, mode),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  SettingsSection(
                    title: 'Memories',
                    tiles: [
                      SettingsTile(icon: Icons.cloud_upload_outlined, title: 'Backup Memories', subtitle: 'Secure your vault', onTap: () {}),
                      SettingsTile(icon: Icons.cloud_download_outlined, title: 'Restore Memories', onTap: () {}),
                      SettingsTile(icon: Icons.delete_outline, title: 'Deleted Memories', subtitle: 'Recently removed', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  SettingsSection(
                    title: 'Demo Data',
                    tiles: [
                      SettingsTile(
                        icon: Icons.auto_awesome_outlined,
                        title: 'Set Demo Data',
                        subtitle: 'Populate the calendar with sample memories',
                        onTap: () => _setDemoData(context),
                      ),
                      SettingsTile(
                        icon: Icons.delete_sweep_outlined,
                        title: 'Clear Demo Data',
                        subtitle: 'Remove sample memories only',
                        onTap: () => _clearDemoData(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  SettingsSection(
                    title: 'Storage',
                    tiles: [
                      SettingsTile(icon: Icons.data_usage_outlined, title: 'Storage Usage', subtitle: '148 Memories, 624 Photos, 2.3 GB', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  SettingsSection(
                    title: 'Privacy',
                    tiles: [
                      SettingsTile(
                        icon: Icons.lock_outline,
                        title: 'App Lock',
                        subtitle: 'Coming soon',
                        enabled: false,
                        trailing: Switch(value: false, onChanged: null),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  SettingsSection(
                    title: 'About',
                    tiles: [
                      SettingsTile(icon: Icons.info_outline, title: 'About Nestory', onTap: () {}),
                      SettingsTile(icon: Icons.policy_outlined, title: 'Privacy Policy', trailing: const Icon(Icons.open_in_new), onTap: () {}),
                      SettingsTile(icon: Icons.star_outline, title: 'Rate App', trailing: const Icon(Icons.open_in_new), onTap: () {}),
                      SettingsTile(icon: Icons.bug_report_outlined, title: 'Report Bug', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.auto_awesome_outlined, color: colors.onSurfaceVariant.withValues(alpha: 0.5)),
                        const SizedBox(height: AppSpacing.stackSm),
                        Text('NESTORY', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 4)),
                        const SizedBox(height: 4),
                        Text('Version 1.0.0', style: theme.textTheme.labelSmall?.copyWith(color: colors.outlineVariant)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setDemoData(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final added = await MemoryRepository.instance.seedDemoDataIfNeeded();
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(added ? 'Demo data added.' : 'Demo data already added.')),
    );
  }

  Future<void> _clearDemoData(BuildContext context) async {
    final confirmed = await GlassDialog.show(
      context,
      title: 'Clear Demo Data',
      message: 'Remove all demo memories?\n\nYour personal memories will remain untouched.',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    await MemoryRepository.instance.clearDemoData();
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo data removed.')));
  }

  void _showThemePicker(BuildContext context, ThemeMode current) {
    GlassBottomSheet.show(
      context,
      title: 'Theme',
      heightFactor: 0.32,
      builder: (context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        children: [
          for (final mode in ThemeMode.values)
            SettingsTile(
              icon: switch (mode) {
                ThemeMode.dark => Icons.dark_mode_outlined,
                ThemeMode.light => Icons.light_mode_outlined,
                ThemeMode.system => Icons.smartphone_outlined,
              },
              title: _themeModeLabels[mode]!,
              trailing: mode == current ? const Icon(Icons.check) : const SizedBox.shrink(),
              onTap: () {
                themeModeNotifier.value = mode;
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
