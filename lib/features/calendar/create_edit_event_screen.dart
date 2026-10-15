import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/db/calendar/calendar_database.dart';
import '../../data/repositories/calendar_event_repository.dart';
import '../../shared/models/calendar_event.dart';
import '../../shared/widgets/glass_button.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_dialog.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../../shared/widgets/glass_text_field.dart';
import '../../shared/widgets/section_title.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Create a new calendar event, or edit an existing one when [event] is passed.
class CreateEditEventScreen extends StatefulWidget {
  const CreateEditEventScreen({super.key, this.event, this.initialDate});

  final CalendarEvent? event;
  final DateTime? initialDate;

  @override
  State<CreateEditEventScreen> createState() => _CreateEditEventScreenState();
}

class _CreateEditEventScreenState extends State<CreateEditEventScreen> {
  late final _titleController = TextEditingController(
    text: widget.event?.title ?? '',
  );
  late final _descriptionController = TextEditingController(
    text: widget.event?.description ?? '',
  );
  late final _locationController = TextEditingController(
    text: widget.event?.location ?? '',
  );

  late bool _isAllDay = widget.event?.isAllDay ?? false;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  List<CalendarMetaEntity> _availableCalendars = [];
  String? _selectedCalendarId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _initDates();
    _loadCalendars();
  }

  void _initDates() {
    final event = widget.event;
    final now = DateTime.now();
    final base = widget.initialDate ?? now;

    if (event != null) {
      if (event.isAllDay && event.startDate != null) {
        final startParts = event.startDate!.split('-').map(int.parse).toList();
        _startDate = DateTime(startParts[0], startParts[1], startParts[2]);

        if (event.endDate != null) {
          final endParts = event.endDate!.split('-').map(int.parse).toList();
          // Subtract 1 day for inclusive UI display from exclusive stored end date
          _endDate = DateTime(
            endParts[0],
            endParts[1],
            endParts[2],
          ).subtract(const Duration(days: 1));
          if (_endDate.isBefore(_startDate)) _endDate = _startDate;
        } else {
          _endDate = _startDate;
        }
        _startTime = const TimeOfDay(hour: 9, minute: 0);
        _endTime = const TimeOfDay(hour: 10, minute: 0);
      } else {
        final startLocal = event.startDateTime?.toLocal() ?? base;
        final endLocal =
            event.endDateTime?.toLocal() ??
            startLocal.add(const Duration(hours: 1));
        _startDate = DateTime(
          startLocal.year,
          startLocal.month,
          startLocal.day,
        );
        _endDate = DateTime(endLocal.year, endLocal.month, endLocal.day);
        _startTime = TimeOfDay(
          hour: startLocal.hour,
          minute: startLocal.minute,
        );
        _endTime = TimeOfDay(hour: endLocal.hour, minute: endLocal.minute);
      }
      _selectedCalendarId = event.googleCalendarId;
    } else {
      _startDate = DateTime(base.year, base.month, base.day);
      _endDate = _startDate;
      final nextHour = now.hour + 1;
      _startTime = TimeOfDay(hour: nextHour % 24, minute: 0);
      _endTime = TimeOfDay(hour: (nextHour + 1) % 24, minute: 0);
    }
  }

  Future<void> _loadCalendars() async {
    final cals = await CalendarDatabase.instance().calendarsMetaDao
        .getAllCalendars();
    if (mounted) {
      setState(() {
        _availableCalendars = cals;
        _selectedCalendarId ??= cals
            .firstWhere(
              (c) => c.isPrimary,
              orElse: () => cals.isNotEmpty ? cals.first : cals.first,
            )
            .googleCalendarId;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDateString(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && mounted) {
      setState(() {
        _startTime = picked;
        // Keep end time after start time on same day
        if (_startDate == _endDate &&
            (picked.hour > _endTime.hour ||
                (picked.hour == _endTime.hour &&
                    picked.minute >= _endTime.minute))) {
          _endTime = TimeOfDay(
            hour: (picked.hour + 1) % 24,
            minute: picked.minute,
          );
        }
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && mounted) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an event title.')),
      );
      return;
    }

    final calendarId = _selectedCalendarId ?? 'primary';

    setState(() => _saving = true);
    try {
      if (_isAllDay) {
        final startStr = _formatDateString(_startDate);
        // Exclusive end date: add 1 day to the inclusive UI end date
        final endExclusive = _endDate.add(const Duration(days: 1));
        final endStr = _formatDateString(endExclusive);

        if (widget.event != null) {
          await CalendarEventRepository.instance.update(
            id: widget.event!.id,
            title: title,
            description: _descriptionController.text.trim(),
            location: _locationController.text.trim(),
            isAllDay: true,
            startDate: startStr,
            endDate: endStr,
          );
        } else {
          await CalendarEventRepository.instance.create(
            title: title,
            googleCalendarId: calendarId,
            description: _descriptionController.text.trim(),
            location: _locationController.text.trim(),
            isAllDay: true,
            startDate: startStr,
            endDate: endStr,
          );
        }
      } else {
        final startDateTime = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          _startTime.hour,
          _startTime.minute,
        );
        final endDateTime = DateTime(
          _endDate.year,
          _endDate.month,
          _endDate.day,
          _endTime.hour,
          _endTime.minute,
        );

        if (endDateTime.isBefore(startDateTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('End time cannot be before start time.'),
            ),
          );
          setState(() => _saving = false);
          return;
        }

        if (widget.event != null) {
          await CalendarEventRepository.instance.update(
            id: widget.event!.id,
            title: title,
            description: _descriptionController.text.trim(),
            location: _locationController.text.trim(),
            isAllDay: false,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
          );
        } else {
          await CalendarEventRepository.instance.create(
            title: title,
            googleCalendarId: calendarId,
            description: _descriptionController.text.trim(),
            location: _locationController.text.trim(),
            isAllDay: false,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
          );
        }
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save event: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final event = widget.event;
    if (event == null) return;

    final confirmed = await GlassDialog.show(
      context,
      title: 'Delete Event?',
      message: 'This event will be removed from Nestory and Google Calendar.',
      confirmLabel: 'Delete',
      destructive: true,
    );

    if (confirmed == true && mounted) {
      await CalendarEventRepository.instance.delete(event.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final isEditing = widget.event != null;

    return Scaffold(
      backgroundColor: colors.void_,
      body: SafeArea(
        child: Column(
          children: [
            // Top action bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
                vertical: AppSpacing.unit,
              ),
              child: Row(
                children: [
                  GlassIconButton(
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      isEditing ? 'EDIT EVENT' : 'NEW EVENT',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  if (_saving)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    GlassButton(
                      label: 'Save',
                      variant: GlassButtonVariant.primary,
                      onPressed: _save,
                    ),
                ],
              ),
            ),
            // Form body
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                  vertical: AppSpacing.stackMd,
                ),
                children: [
                  // Title
                  GlassTextField(
                    label: 'Title',
                    controller: _titleController,
                    hint: 'Event Title',
                    textStyle: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.stackMd),

                  // Calendar selection (if available)
                  if (_availableCalendars.isNotEmpty) ...[
                    const SectionTitle('CALENDAR'),
                    const SizedBox(height: AppSpacing.unit),
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.stackSm,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCalendarId,
                          isExpanded: true,
                          dropdownColor: colors.surfaceContainer,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: colors.onSurfaceVariant,
                          ),
                          items: _availableCalendars.map((cal) {
                            return DropdownMenuItem<String>(
                              value: cal.googleCalendarId,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cal.colorHex != null
                                          ? Color(
                                              int.parse(
                                                cal.colorHex!.replaceFirst(
                                                  '#',
                                                  '0xFF',
                                                ),
                                              ),
                                            )
                                          : colors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.stackSm),
                                  Expanded(
                                    child: Text(
                                      cal.summary,
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (cal.isPrimary)
                                    Text(
                                      ' (Primary)',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: colors.outlineVariant,
                                          ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCalendarId = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.stackMd),
                  ],

                  // Date & Time section
                  const SectionTitle('DATE & TIME'),
                  const SizedBox(height: AppSpacing.unit),
                  GlassContainer(
                    child: Column(
                      children: [
                        // All-Day Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All-day event',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Switch(
                              value: _isAllDay,
                              activeTrackColor: colors.primary,
                              onChanged: (val) =>
                                  setState(() => _isAllDay = val),
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 0.5),

                        // Start Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Starts',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _pickStartDate,
                                  child: Text(
                                    _formatDate(_startDate),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                if (!_isAllDay) ...[
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: _pickStartTime,
                                    child: Text(
                                      _formatTime(_startTime),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 16, thickness: 0.5),

                        // End Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ends',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _pickEndDate,
                                  child: Text(
                                    _formatDate(_endDate),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                if (!_isAllDay) ...[
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: _pickEndTime,
                                    child: Text(
                                      _formatTime(_endTime),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),

                  // Location
                  GlassTextField(
                    label: 'Location',
                    controller: _locationController,
                    hint: 'Add location',
                  ),
                  const SizedBox(height: AppSpacing.stackMd),

                  // Description
                  GlassTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    hint: 'Add description or notes',
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),

                  // Delete button if editing
                  if (isEditing) ...[
                    GlassButton(
                      label: 'Delete Event',
                      icon: Icons.delete_outline,
                      variant: GlassButtonVariant.secondary,
                      expand: true,
                      onPressed: _confirmDelete,
                    ),
                    const SizedBox(height: AppSpacing.stackLg),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
