import 'package:flutter/foundation.dart';

/// Representation of a calendar event for the UI layer.
/// Decoupled from both raw Drift row entities and Google API response objects.
@immutable
class CalendarEvent {
  const CalendarEvent({
    required this.id,
    this.googleEventId,
    required this.googleCalendarId,
    required this.title,
    this.description = '',
    this.location = '',
    this.isAllDay = false,
    this.startDate,
    this.endDate,
    this.startDateTime,
    this.endDateTime,
    this.timeZone = 'UTC',
    this.syncStatus = 'synced',
    this.remoteETag,
    this.calendarSummary,
    this.calendarColorHex,
  });

  final int id;
  final String? googleEventId;
  final String googleCalendarId;
  final String title;
  final String description;
  final String location;

  final bool isAllDay;

  /// 'YYYY-MM-DD' start date for all-day events.
  final String? startDate;

  /// 'YYYY-MM-DD' exclusive end date for all-day events: `[startDate, endDate)`.
  final String? endDate;

  /// UTC DateTime instant for timed events.
  final DateTime? startDateTime;

  /// UTC DateTime instant for timed events.
  final DateTime? endDateTime;

  final String timeZone;

  /// 'synced', 'pendingCreate', 'pendingUpdate', 'pendingDelete', 'failed'
  final String syncStatus;

  final String? remoteETag;

  /// Display metadata from parent calendar
  final String? calendarSummary;
  final String? calendarColorHex;

  bool get isPending =>
      syncStatus == 'pendingCreate' ||
      syncStatus == 'pendingUpdate' ||
      syncStatus == 'pendingDelete';

  bool get isFailed => syncStatus == 'failed';

  /// Evaluates whether this event occurs on [date].
  ///
  /// For all-day events, checks half-open interval `startDate <= dateString && endDate > dateString`.
  /// For timed events, checks if the local start/end interval overlaps the local day.
  bool occursOn(DateTime date) {
    if (isAllDay) {
      if (startDate == null || endDate == null) return false;
      final dateString =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return startDate!.compareTo(dateString) <= 0 &&
          endDate!.compareTo(dateString) > 0;
    } else {
      if (startDateTime == null || endDateTime == null) return false;
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final localStart = startDateTime!.toLocal();
      final localEnd = endDateTime!.toLocal();
      return localStart.isBefore(dayEnd) && localEnd.isAfter(dayStart);
    }
  }

  /// Formatted time range string for display in agenda cards.
  String formatTimeRange() {
    if (isAllDay) return 'All day';
    if (startDateTime == null) return '';
    final localStart = startDateTime!.toLocal();
    final localEnd = endDateTime?.toLocal();

    String formatSingle(DateTime d) {
      final hour12 = d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
      final minute = d.minute.toString().padLeft(2, '0');
      final period = d.hour >= 12 ? 'PM' : 'AM';
      return '$hour12:$minute $period';
    }

    if (localEnd == null) return formatSingle(localStart);
    return '${formatSingle(localStart)} – ${formatSingle(localEnd)}';
  }

  CalendarEvent copyWith({
    int? id,
    String? googleEventId,
    String? googleCalendarId,
    String? title,
    String? description,
    String? location,
    bool? isAllDay,
    String? startDate,
    String? endDate,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? timeZone,
    String? syncStatus,
    String? remoteETag,
    String? calendarSummary,
    String? calendarColorHex,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      googleEventId: googleEventId ?? this.googleEventId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      timeZone: timeZone ?? this.timeZone,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteETag: remoteETag ?? this.remoteETag,
      calendarSummary: calendarSummary ?? this.calendarSummary,
      calendarColorHex: calendarColorHex ?? this.calendarColorHex,
    );
  }
}
