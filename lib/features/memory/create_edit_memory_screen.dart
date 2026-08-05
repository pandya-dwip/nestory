import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/memory_repository.dart';
import '../../data/services/image_storage_service.dart';
import '../../shared/models/memory.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../../shared/widgets/glass_text_field.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/tag_chip.dart';
import 'widgets/image_source_sheet.dart';
import 'widgets/photo_picker_grid.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Create a new memory, or edit an existing one when [memory] is passed.
class CreateEditMemoryScreen extends StatefulWidget {
  const CreateEditMemoryScreen({super.key, this.memory, this.initialDate});

  final Memory? memory;
  final DateTime? initialDate;

  @override
  State<CreateEditMemoryScreen> createState() => _CreateEditMemoryScreenState();
}

class _CreateEditMemoryScreenState extends State<CreateEditMemoryScreen> {
  late final _titleController = TextEditingController(text: widget.memory?.title ?? '');
  late final _descriptionController = TextEditingController(text: widget.memory?.description ?? '');
  late final _tagInputController = TextEditingController();

  late List<String> _photoUrls = [...?widget.memory?.photoUrls];
  late List<String> _tags = [...?widget.memory?.tags];
  late DateTime _date = widget.memory?.date ?? widget.initialDate ?? DateTime.now();

  bool _addingPhoto = false;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    if (_photoUrls.length >= maxMemoryPhotos || _addingPhoto) return;

    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;

    setState(() => _addingPhoto = true);
    try {
      final picked = await ImagePicker().pickImage(source: source, imageQuality: 90);
      if (picked == null) return;
      final localPath = await ImageStorageService.copyIntoAppStorage(picked.path);
      if (!mounted) return;
      setState(() => _photoUrls = [..._photoUrls, localPath]);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not add that photo.')));
      }
    } finally {
      if (mounted) setState(() => _addingPhoto = false);
    }
  }

  void _removePhoto(int index) {
    setState(() => _photoUrls = [..._photoUrls]..removeAt(index));
  }

  void _makeCover(int index) {
    if (index == 0) return;
    setState(() {
      final urls = [..._photoUrls];
      final cover = urls.removeAt(index);
      _photoUrls = [cover, ...urls];
    });
  }

  void _addTag(String value) {
    final tag = value.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() => _tags = [..._tags, tag]);
    _tagInputController.clear();
  }

  void _removeTag(String tag) {
    setState(() => _tags = [..._tags]..remove(tag));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_saving) return;

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Give this memory a title.')));
      return;
    }

    setState(() => _saving = true);
    try {
      final existing = widget.memory;
      if (existing == null) {
        await MemoryRepository.instance.create(
          title: title,
          description: _descriptionController.text.trim(),
          date: _date,
          tags: _tags,
          photoPaths: _photoUrls,
        );
      } else {
        await MemoryRepository.instance.update(
          id: existing.id,
          title: title,
          description: _descriptionController.text.trim(),
          date: _date,
          tags: _tags,
          photoPaths: _photoUrls,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memory saved.')));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save this memory.')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.unit),
              child: Row(
                children: [
                  GlassIconButton(icon: Icons.arrow_back, glass: true, onPressed: () => Navigator.of(context).pop()),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: _saving ? null : _save,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackMd, vertical: AppSpacing.stackSm),
                        decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(AppRadius.full)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SAVE', style: theme.textTheme.labelSmall?.copyWith(color: colors.onPrimary)),
                            const SizedBox(width: AppSpacing.unit),
                            if (_saving)
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: colors.onPrimary),
                              )
                            else
                              Icon(Icons.check, size: 16, color: colors.onPrimary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.stackSm,
                  AppSpacing.gutter,
                  AppSpacing.stackLg,
                ),
                children: [
                  PhotoPickerGrid(
                    photoUrls: _photoUrls,
                    onAddPhoto: _addPhoto,
                    onRemovePhoto: _removePhoto,
                    onMakeCover: _makeCover,
                    busy: _addingPhoto,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  GlassTextField(
                    label: 'Title',
                    controller: _titleController,
                    hint: 'My Favorite Day',
                    textStyle: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  GlassTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    hint: 'What made this day special?',
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  const SectionTitle('Date', dim: true),
                  const SizedBox(height: AppSpacing.stackSm),
                  GestureDetector(
                    onTap: _pickDate,
                    child: GlassContainer(
                      active: true,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackMd, vertical: AppSpacing.stackMd),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDate(_date), style: theme.textTheme.bodyLarge),
                          Icon(Icons.calendar_today_outlined, color: colors.onSurfaceVariant, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  const SectionTitle('Tags', dim: true),
                  const SizedBox(height: AppSpacing.stackSm),
                  GlassContainer(
                    padding: const EdgeInsets.all(AppSpacing.stackMd),
                    child: Wrap(
                      spacing: AppSpacing.stackSm,
                      runSpacing: AppSpacing.stackSm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final tag in _tags) TagChip(label: tag, onRemove: () => _removeTag(tag)),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _tagInputController,
                            style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurface),
                            cursorColor: colors.onSurface,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Add tag...',
                              hintStyle: theme.textTheme.labelSmall?.copyWith(color: colors.onSurface.withValues(alpha: 0.3)),
                            ),
                            onSubmitted: _addTag,
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

  static String _formatDate(DateTime date) => '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
}
