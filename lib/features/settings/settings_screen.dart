import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/db/calendar/calendar_database.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../data/repositories/calendar_event_repository.dart';
import '../../data/repositories/memory_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/backup_service.dart';
import '../../data/services/calendar_sync_service.dart';
import '../../data/services/google_auth_service.dart';
import '../../data/services/storage_stats_service.dart';
import '../../shared/widgets/glass_bottom_sheet.dart';
import '../../shared/widgets/glass_dialog.dart';
import '../../shared/widgets/glass_icon_button.dart';
import 'screens/about_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'widgets/calendar_selection_sheet.dart';
import 'widgets/conflict_history_sheet.dart';
import 'widgets/settings_tile.dart';

const _themeModeLabels = {
  ThemeMode.dark: 'Dark',
  ThemeMode.light: 'Light',
  ThemeMode.system: 'System',
};

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  StorageStats? _storageStats;

  @override
  void initState() {
    super.initState();
    MemoryRepository.instance.addListener(_refreshStorageStats);
    _refreshStorageStats();
  }

  @override
  void dispose() {
    MemoryRepository.instance.removeListener(_refreshStorageStats);
    super.dispose();
  }

  Future<void> _refreshStorageStats() async {
    final stats = await StorageStatsService.compute();
    if (mounted) setState(() => _storageStats = stats);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final stats = _storageStats;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
                vertical: AppSpacing.unit,
              ),
              child: Row(
                children: [
                  GlassIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'SETTINGS',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                  vertical: AppSpacing.stackMd,
                ),
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
                      SettingsTile(
                        icon: Icons.cloud_upload_outlined,
                        title: 'Backup Memories',
                        subtitle: 'Secure your vault',
                        onTap: () => _backup(context),
                      ),
                      SettingsTile(
                        icon: Icons.cloud_download_outlined,
                        title: 'Restore Memories',
                        onTap: () => _restore(context),
                      ),
                      SettingsTile(
                        icon: Icons.delete_forever_outlined,
                        title: 'Delete All Memories',
                        subtitle: 'Keeps your profile and settings',
                        onTap: () => _deleteAllMemories(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      GoogleAuthService.instance,
                      CalendarSyncService.instance,
                    ]),
                    builder: (context, _) {
                      final auth = GoogleAuthService.instance;
                      final sync = CalendarSyncService.instance;
                      final isSignedIn = auth.isSignedIn;

                      return SettingsSection(
                        title: 'Google Calendar',
                        tiles: [
                          if (!isSignedIn)
                            SettingsTile(
                              icon: Icons.account_circle_outlined,
                              title: 'Connect Google Calendar',
                              subtitle: 'Sync events with your monthly vault',
                              onTap: () => _connectGoogle(context),
                            )
                          else ...[
                            SettingsTile(
                              icon: Icons.account_circle,
                              title: auth.displayName?.isNotEmpty == true
                                  ? auth.displayName!
                                  : (auth.userEmail ?? 'Connected Account'),
                              subtitle: auth.userEmail ?? 'Connected',
                              trailing: IconButton(
                                icon: const Icon(Icons.sync, size: 20),
                                onPressed: sync.isSyncing
                                    ? null
                                    : () => _syncNow(context),
                              ),
                            ),
                            SettingsTile(
                              icon: Icons.sync,
                              title: 'Sync Status',
                              subtitle: sync.isSyncing
                                  ? 'Synchronizing...'
                                  : (sync.lastSyncTime != null
                                        ? 'Last synced: ${_formatTimeAgo(sync.lastSyncTime!)}${sync.pendingOutboxCount > 0 ? ' · ${sync.pendingOutboxCount} pending' : ''}'
                                        : (sync.pendingOutboxCount > 0
                                              ? '${sync.pendingOutboxCount} changes pending'
                                              : 'Never synced')),
                              trailing: sync.isSyncing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () => _syncNow(context),
                                      child: const Text('Sync Now'),
                                    ),
                            ),
                            SettingsTile(
                              icon: Icons.calendar_month_outlined,
                              title: 'Manage Calendars',
                              subtitle: 'Choose which calendars appear',
                              onTap: () => CalendarSelectionSheet.show(context),
                            ),
                            SettingsTile(
                              icon: Icons.history_toggle_off_outlined,
                              title: 'Sync Conflicts',
                              subtitle: 'View saved offline edits',
                              onTap: () => ConflictHistorySheet.show(context),
                            ),
                            SettingsTile(
                              icon: Icons.link_off,
                              title: 'Disconnect Calendar',
                              subtitle: 'Manage local cache on disconnect',
                              onTap: () => _disconnectGoogle(context),
                            ),
                          ],
                        ],
                      );
                    },
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
                      SettingsTile(
                        icon: Icons.data_usage_outlined,
                        title: 'Storage Usage',
                        subtitle: stats == null
                            ? 'Calculating…'
                            : '${stats.totalMemories} Memories, ${stats.totalPhotos} Photos, ${stats.formattedSize}',
                      ),
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
                      SettingsTile(
                        icon: Icons.info_outline,
                        title: 'About Nestory',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        ),
                      ),
                      SettingsTile(
                        icon: Icons.policy_outlined,
                        title: 'Privacy Policy',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.stackSm),
                        Text(
                          'NESTORY',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.outlineVariant,
                          ),
                        ),
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
    await _withLoadingDialog(
      context,
      MemoryRepository.instance.seedDemoDataIfNeeded(),
    ).then((added) {
      if (added == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added ? 'Demo data added.' : 'Demo data already added.',
          ),
        ),
      );
    });
  }

  Future<void> _clearDemoData(BuildContext context) async {
    final confirmed = await GlassDialog.show(
      context,
      title: 'Clear Demo Data',
      message:
          'Remove all demo memories?\n\nYour personal memories will remain untouched.',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    await _withLoadingDialog(
      context,
      MemoryRepository.instance.clearDemoData(),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Demo data removed.')));
    }
  }

  Future<void> _deleteAllMemories(BuildContext context) async {
    final confirmed = await GlassDialog.show(
      context,
      title: 'Delete All Memories?',
      message:
          'This will permanently delete all memories stored in Nestory.\n\nThis action cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    await _withLoadingDialog(
      context,
      MemoryRepository.instance.deleteAllMemories(),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All memories deleted.')));
    }
  }

  Future<void> _backup(BuildContext context) async {
    try {
      final bytes = await _withLoadingDialog(
        context,
        BackupService.buildArchive(),
      );
      if (bytes == null || !context.mounted) return;

      final stamp = DateTime.now();
      String two(int n) => n.toString().padLeft(2, '0');
      final fileName =
          'nestory_backup_${stamp.year}${two(stamp.month)}${two(stamp.day)}_${two(stamp.hour)}${two(stamp.minute)}.zip';

      final savedPath = await FilePicker.saveFile(
        dialogTitle: 'Save Nestory backup',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: const ['zip'],
        bytes: bytes,
      );
      if (savedPath == null || !context.mounted) return;

      await AppSettingsRepository.instance.setLastBackupDate(DateTime.now());
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Backup saved.')));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup failed. Please try again.')),
        );
      }
    }
  }

  Future<void> _restore(BuildContext context) async {
    try {
      final picked = await FilePicker.pickFiles(
        dialogTitle: 'Choose a Nestory backup',
        type: FileType.custom,
        allowedExtensions: const ['zip'],
        withData: true,
      );
      if (picked == null || picked.files.isEmpty || !context.mounted) return;

      final file = picked.files.single;
      final bytes =
          file.bytes ??
          (file.path != null ? await File(file.path!).readAsBytes() : null);
      if (bytes == null) return;

      if (!BackupService.looksLikeValidBackup(bytes)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('That file is not a valid Nestory backup.'),
            ),
          );
        }
        return;
      }

      if (!context.mounted) return;
      final confirmed = await GlassDialog.show(
        context,
        title: 'Restore Backup?',
        message:
            'This replaces every memory, photo, and setting currently on this device with the contents of this backup.\n\nThis cannot be undone.',
        confirmLabel: 'Restore',
        destructive: true,
      );
      if (confirmed != true || !context.mounted) return;

      await _withLoadingDialog(context, _performRestore(bytes));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Backup restored.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore failed. Please try again.')),
        );
      }
    }
  }

  Future<void> _performRestore(Uint8List bytes) async {
    await BackupService.restoreArchive(bytes);
    await MemoryRepository.instance.reload();
    if (ProfileRepository.instance.isReady) {
      await ProfileRepository.instance.reload();
    }
    if (AppSettingsRepository.instance.isReady) {
      await AppSettingsRepository.instance.reload();
    }
  }

  /// Shows a non-dismissible spinner while [future] runs, always closing it
  /// afterward (success or failure) before returning the result.
  Future<T?> _withLoadingDialog<T>(
    BuildContext context,
    Future<T> future,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final result = await future;
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      return result;
    } catch (_) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      rethrow;
    }
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
              trailing: mode == current
                  ? const Icon(Icons.check)
                  : const SizedBox.shrink(),
              onTap: () {
                themeModeNotifier.value = mode;
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  Future<void> _connectGoogle(BuildContext context) async {
    try {
      final account = await GoogleAuthService.instance.signIn();
      if (account != null && context.mounted) {
        await CalendarDatabase.instance().calendarAccountsDao.upsertAccount(
          email: account.email,
          displayName: account.displayName ?? '',
          photoUrl: account.photoUrl,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected as ${account.email}')),
        );
        CalendarSyncService.instance.syncAll(isManual: true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
      }
    }
  }

  Future<void> _disconnectGoogle(BuildContext context) async {
    final pendingCount = await CalendarDatabase.instance().calendarOutboxDao
        .countPending();
    String warning =
        'Would you like to clear cached Google events from this device, or retain them as a read-only historical copy?';
    if (pendingCount > 0) {
      warning +=
          '\n\nNotice: You have $pendingCount unsynchronized offline changes that will be permanently lost if cache is cleared.';
    }

    if (!context.mounted) return;

    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surfaceContainer,
        title: const Text('Disconnect Google Calendar'),
        content: Text(warning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('keep'),
            child: const Text('Keep Read-Only'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('clear'),
            child: const Text(
              'Clear Cache',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (choice == null || choice == 'cancel') return;

    if (choice == 'clear') {
      await CalendarEventRepository.instance.clearAll();
    }
    await GoogleAuthService.instance.disconnect();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Calendar disconnected.')),
    );
  }

  Future<void> _syncNow(BuildContext context) async {
    await CalendarSyncService.instance.syncAll(isManual: true);
    if (!context.mounted) return;
    final err = CalendarSyncService.instance.syncError;
    if (err != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sync failed: $err')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync completed successfully.')),
      );
    }
  }

  String _formatTimeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
