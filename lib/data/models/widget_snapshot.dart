import 'dart:convert';

import '../../shared/models/calendar_event.dart';
import '../../shared/models/memory.dart';

/// Contract Version for the Native Android Widget Snapshot.
/// Increment whenever the schema changes.
const int kWidgetSnapshotVersion = 3;

/// Represents an event summary optimized for native widget presentation.
class WidgetEventItem {
  const WidgetEventItem({
    required this.id,
    required this.title,
    required this.timeFormatted,
    required this.isAllDay,
    this.calendarColorHex,
  });

  final int id;
  final String title;
  final String timeFormatted;
  final bool isAllDay;
  final String? calendarColorHex;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'timeFormatted': timeFormatted,
        'isAllDay': isAllDay,
        'calendarColorHex': calendarColorHex,
      };

  factory WidgetEventItem.fromJson(Map<String, dynamic> json) {
    return WidgetEventItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '(No title)',
      timeFormatted: json['timeFormatted'] as String? ?? 'All day',
      isAllDay: json['isAllDay'] as bool? ?? false,
      calendarColorHex: json['calendarColorHex'] as String?,
    );
  }

  factory WidgetEventItem.fromCalendarEvent(CalendarEvent event) {
    String formattedTime;
    if (event.isAllDay) {
      formattedTime = 'All day';
    } else if (event.startDateTime != null) {
      final local = event.startDateTime!.toLocal();
      final hour = local.hour;
      final minute = local.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final h12 = hour % 12 == 0 ? 12 : hour % 12;
      formattedTime = '$h12:$minute $period';
    } else {
      formattedTime = 'Scheduled';
    }

    return WidgetEventItem(
      id: event.id,
      title: event.title.isEmpty ? '(No title)' : event.title,
      timeFormatted: formattedTime,
      isAllDay: event.isAllDay,
      calendarColorHex: event.calendarColorHex,
    );
  }
}

/// Represents a memory highlight for a date in the widget.
class WidgetMemoryItem {
  const WidgetMemoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.photoCount,
    this.imagePath,
  });

  final int id;
  final String title;
  final String description;
  final int photoCount;
  final String? imagePath;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'photoCount': photoCount,
        'imagePath': imagePath,
      };

  factory WidgetMemoryItem.fromJson(Map<String, dynamic> json) {
    return WidgetMemoryItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photoCount: json['photoCount'] as int? ?? 0,
      imagePath: json['imagePath'] as String?,
    );
  }

  factory WidgetMemoryItem.fromMemory(Memory memory) {
    return WidgetMemoryItem(
      id: memory.id,
      title: memory.title.isEmpty ? 'Memory' : memory.title,
      description: memory.description,
      photoCount: memory.photoCount,
      imagePath: memory.photoUrls.isNotEmpty ? memory.photoUrls.first : null,
    );
  }
}

/// Durable snapshot payload delivered to Android SharedPreferences for the native widget.
class WidgetSnapshot {
  const WidgetSnapshot({
    required this.version,
    required this.updatedAtIso,
    required this.year,
    required this.month,
    required this.day,
    required this.weekday,
    required this.formattedDate,
    required this.formattedMonthYear,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.upcomingEvents,
    this.todayMemory,
    this.eventsByDate = const {},
    this.memoriesByDate = const {},
  });

  final int version;
  final String updatedAtIso;
  final int year;
  final int month;
  final int day;
  final int weekday;
  final String formattedDate;
  final String formattedMonthYear;
  final int daysInMonth;
  final int firstWeekday; // Sunday = 0, Monday = 1, etc.
  final List<WidgetEventItem> upcomingEvents;
  final WidgetMemoryItem? todayMemory;
  final Map<String, List<WidgetEventItem>> eventsByDate;
  final Map<String, WidgetMemoryItem> memoriesByDate;

  static const _monthAbbrs = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String _formatDateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Builds a snapshot from the current device time and hydrated repository items.
  factory WidgetSnapshot.build({
    required DateTime now,
    List<CalendarEvent>? todayEvents,
    List<Memory>? todayMemories,
    List<CalendarEvent>? allEvents,
    List<Memory>? allMemories,
  }) {
    final daysInCurrentMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayWeekday = DateTime(now.year, now.month, 1).weekday % 7;

    final monthAbbr = _monthAbbrs[now.month - 1];
    final formattedDate = '${now.day} $monthAbbr.';
    final formattedMonthYear = '${_monthNames[now.month - 1].toUpperCase()} ${now.year}';

    final groupedEvents = <String, List<WidgetEventItem>>{};
    final eventsToProcess = allEvents ?? todayEvents ?? const <CalendarEvent>[];

    for (final event in eventsToProcess) {
      if (event.isAllDay) {
        if (event.startDate != null) {
          final start = DateTime.tryParse(event.startDate!);
          final end = event.endDate != null ? DateTime.tryParse(event.endDate!) : null;
          if (start != null) {
            final actualEnd = end ?? start.add(const Duration(days: 1));
            var cur = DateTime(start.year, start.month, start.day);
            final stop = DateTime(actualEnd.year, actualEnd.month, actualEnd.day);
            while (cur.isBefore(stop)) {
              final key = _formatDateKey(cur);
              groupedEvents.putIfAbsent(key, () => []).add(WidgetEventItem.fromCalendarEvent(event));
              cur = cur.add(const Duration(days: 1));
            }
          }
        }
      } else if (event.startDateTime != null) {
        final localStart = event.startDateTime!.toLocal();
        final localEnd = (event.endDateTime ?? event.startDateTime)!.toLocal();
        var cur = DateTime(localStart.year, localStart.month, localStart.day);
        final stopDay = DateTime(localEnd.year, localEnd.month, localEnd.day);
        final endLimit = stopDay.isAfter(cur) ? stopDay : cur;
        while (!cur.isAfter(endLimit)) {
          final key = _formatDateKey(cur);
          groupedEvents.putIfAbsent(key, () => []).add(WidgetEventItem.fromCalendarEvent(event));
          cur = cur.add(const Duration(days: 1));
        }
      }
    }

    // Sort every date's events: all-day first, then by startDateTime
    for (final list in groupedEvents.values) {
      list.sort((a, b) {
        if (a.isAllDay && !b.isAllDay) return -1;
        if (!a.isAllDay && b.isAllDay) return 1;
        return 0;
      });
    }

    final groupedMemories = <String, WidgetMemoryItem>{};
    final memoriesToProcess = allMemories ?? todayMemories ?? const <Memory>[];
    for (final m in memoriesToProcess) {
      final key = _formatDateKey(m.date);
      groupedMemories[key] = WidgetMemoryItem.fromMemory(m);
    }

    final todayKey = _formatDateKey(now);
    final upcoming = todayEvents != null
        ? (List<CalendarEvent>.from(todayEvents)
            ..sort((a, b) {
              if (a.isAllDay && !b.isAllDay) return -1;
              if (!a.isAllDay && b.isAllDay) return 1;
              final aTime = a.startDateTime ?? DateTime(now.year, now.month, now.day);
              final bTime = b.startDateTime ?? DateTime(now.year, now.month, now.day);
              return aTime.compareTo(bTime);
            }))
            .take(5)
            .map(WidgetEventItem.fromCalendarEvent)
            .toList()
        : (groupedEvents[todayKey] ?? const <WidgetEventItem>[]).take(5).toList();

    final memoryItem = todayMemories != null
        ? (todayMemories.isNotEmpty ? WidgetMemoryItem.fromMemory(todayMemories.first) : null)
        : groupedMemories[todayKey];

    return WidgetSnapshot(
      version: kWidgetSnapshotVersion,
      updatedAtIso: now.toIso8601String(),
      year: now.year,
      month: now.month,
      day: now.day,
      weekday: now.weekday % 7,
      formattedDate: formattedDate,
      formattedMonthYear: formattedMonthYear,
      daysInMonth: daysInCurrentMonth,
      firstWeekday: firstDayWeekday,
      upcomingEvents: upcoming,
      todayMemory: memoryItem,
      eventsByDate: groupedEvents,
      memoriesByDate: groupedMemories,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'updatedAtIso': updatedAtIso,
        'currentDate': {
          'year': year,
          'month': month,
          'day': day,
          'weekday': weekday,
          'formattedDate': formattedDate,
          'formattedMonthYear': formattedMonthYear,
        },
        'monthGrid': {
          'daysInMonth': daysInMonth,
          'firstWeekday': firstWeekday,
          'todayDay': day,
        },
        'upcomingEvents': [for (final e in upcomingEvents) e.toJson()],
        'todayMemory': todayMemory?.toJson(),
        'eventsByDate': {
          for (final entry in eventsByDate.entries)
            entry.key: [for (final e in entry.value) e.toJson()],
        },
        'memoriesByDate': {
          for (final entry in memoriesByDate.entries)
            entry.key: entry.value.toJson(),
        },
        'stats': {
          'totalEventsToday': upcomingEvents.length,
          'hasMemoryToday': todayMemory != null,
        },
      };

  factory WidgetSnapshot.fromJson(Map<String, dynamic> json) {
    final curr = json['currentDate'] as Map<String, dynamic>? ?? {};
    final grid = json['monthGrid'] as Map<String, dynamic>? ?? {};
    final eventsJson = json['upcomingEvents'] as List<dynamic>? ?? const [];
    final memoryJson = json['todayMemory'] as Map<String, dynamic>?;
    final eventsByDateJson = json['eventsByDate'] as Map<String, dynamic>? ?? {};
    final memoriesByDateJson = json['memoriesByDate'] as Map<String, dynamic>? ?? {};

    final parsedEventsByDate = <String, List<WidgetEventItem>>{
      for (final entry in eventsByDateJson.entries)
        if (entry.value is List)
          entry.key: [
            for (final item in entry.value as List)
              if (item is Map<String, dynamic>) WidgetEventItem.fromJson(item),
          ],
    };

    final parsedMemoriesByDate = <String, WidgetMemoryItem>{
      for (final entry in memoriesByDateJson.entries)
        if (entry.value is Map<String, dynamic>)
          entry.key: WidgetMemoryItem.fromJson(entry.value as Map<String, dynamic>),
    };

    return WidgetSnapshot(
      version: json['version'] as int? ?? 1,
      updatedAtIso: json['updatedAtIso'] as String? ?? '',
      year: curr['year'] as int? ?? DateTime.now().year,
      month: curr['month'] as int? ?? DateTime.now().month,
      day: curr['day'] as int? ?? DateTime.now().day,
      weekday: curr['weekday'] as int? ?? 0,
      formattedDate: curr['formattedDate'] as String? ?? '',
      formattedMonthYear: curr['formattedMonthYear'] as String? ?? '',
      daysInMonth: grid['daysInMonth'] as int? ?? 30,
      firstWeekday: grid['firstWeekday'] as int? ?? 0,
      upcomingEvents: [
        for (final item in eventsJson)
          if (item is Map<String, dynamic>) WidgetEventItem.fromJson(item),
      ],
      todayMemory:
          memoryJson != null ? WidgetMemoryItem.fromJson(memoryJson) : null,
      eventsByDate: parsedEventsByDate,
      memoriesByDate: parsedMemoriesByDate,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static WidgetSnapshot? fromJsonString(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) {
        return WidgetSnapshot.fromJson(decoded);
      }
    } catch (_) {}
    return null;
  }
}
