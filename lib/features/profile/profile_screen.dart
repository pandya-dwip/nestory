import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/memory_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/image_storage_service.dart';
import '../../shared/widgets/glass_button.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../../shared/widgets/profile_avatar.dart';
import '../../shared/widgets/stat_card.dart';
import '../memory/widgets/image_source_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _nameController = TextEditingController(
    text: ProfileRepository.instance.name,
  );
  late final _bioController = TextEditingController(
    text: ProfileRepository.instance.about,
  );
  final _nameFocus = FocusNode();
  final _bioFocus = FocusNode();

  bool _changingPhoto = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_onFocusChange);
    _bioFocus.addListener(_onFocusChange);
    ProfileRepository.instance.init().then((_) {
      if (!mounted) return;
      _nameController.text = ProfileRepository.instance.name;
      _bioController.text = ProfileRepository.instance.about;
    });
  }

  void _onFocusChange() {
    if (!_nameFocus.hasFocus && !_bioFocus.hasFocus) _save();
  }

  Future<void> _save() async {
    await ProfileRepository.instance.save(
      name: _nameController.text.trim(),
      about: _bioController.text.trim(),
      photoPath: ProfileRepository.instance.photoPath,
    );
  }

  Future<void> _changePhoto() async {
    if (_changingPhoto) return;
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;

    setState(() => _changingPhoto = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 90,
      );
      if (picked == null) return;
      final localPath = await ImageStorageService.copyIntoAppStorage(
        picked.path,
      );
      await ProfileRepository.instance.save(
        name: _nameController.text.trim(),
        about: _bioController.text.trim(),
        photoPath: localPath,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update your photo.')),
        );
      }
    } finally {
      if (mounted) setState(() => _changingPhoto = false);
    }
  }

  @override
  void dispose() {
    _nameFocus.removeListener(_onFocusChange);
    _bioFocus.removeListener(_onFocusChange);
    _nameFocus.dispose();
    _bioFocus.dispose();
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
                  ListenableBuilder(
                    listenable: ProfileRepository.instance,
                    builder: (context, _) => Center(
                      child: _changingPhoto
                          ? const SizedBox(
                              width: 140,
                              height: 140,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : ProfileAvatar(
                              photoUrl: ProfileRepository.instance.photoPath,
                              onTap: _changePhoto,
                            ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.unit),
                  Center(
                    child: Text(
                      'Tap to change photo',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _save(),
                  ),
                  const SizedBox(height: AppSpacing.stackSm),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _bioController,
                      focusNode: _bioFocus,
                      textAlign: TextAlign.center,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: theme.textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  ListenableBuilder(
                    listenable: MemoryRepository.instance,
                    builder: (context, _) {
                      final repo = MemoryRepository.instance;
                      return GlassContainer(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.stackMd,
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          children: [
                            StatCard(
                              icon: Icons.auto_awesome_mosaic_outlined,
                              value: '${repo.totalMemories}',
                              label: 'Memories',
                            ),
                            StatCard(
                              icon: Icons.photo_library_outlined,
                              value: '${repo.totalPhotos}',
                              label: 'Photos',
                            ),
                            StatCard(
                              icon: Icons.sell_outlined,
                              value: '${repo.totalTags}',
                              label: 'Tags',
                            ),
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
                      Expanded(
                        child: GlassButton(
                          label: 'Backup',
                          icon: Icons.backup_outlined,
                          expand: true,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: AppSpacing.stackSm),
                      Expanded(
                        child: GlassButton(
                          label: 'Restore',
                          icon: Icons.restore_outlined,
                          expand: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  GlassContainer(
                    borderRadius: AppRadius.md,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.stackMd,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'NESTORY',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
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
