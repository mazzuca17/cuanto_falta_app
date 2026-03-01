import 'dart:convert';

import 'package:cuanto_falta_app/src/l10n/app_strings.dart';
import 'package:cuanto_falta_app/src/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ProgressRange { day, week, month, year }

extension ProgressRangeX on ProgressRange {
  String get storageKey => name;

  DateTime periodStart(DateTime now) {
    switch (this) {
      case ProgressRange.day:
        return DateTime(now.year, now.month, now.day);
      case ProgressRange.week:
        final mondayOffset = now.weekday - DateTime.monday;
        return DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: mondayOffset));
      case ProgressRange.month:
        return DateTime(now.year, now.month, 1);
      case ProgressRange.year:
        return DateTime(now.year, 1, 1);
    }
  }

  DateTime nextPeriodStart(DateTime now) {
    switch (this) {
      case ProgressRange.day:
        return DateTime(now.year, now.month, now.day + 1);
      case ProgressRange.week:
        return periodStart(now).add(const Duration(days: 7));
      case ProgressRange.month:
        return DateTime(now.year, now.month + 1, 1);
      case ProgressRange.year:
        return DateTime(now.year + 1, 1, 1);
    }
  }

  String localizedLabel(AppStrings strings) => strings.labelForRange(name);
}

class CountdownEvent {
  CountdownEvent({
    required this.id,
    required this.title,
    required this.targetDate,
    this.notify = false,
    this.color = Colors.deepPurple,
  });

  final String id;
  final String title;
  final DateTime targetDate;
  final bool notify;
  final Color color;

  bool get isNewYearEvent => targetDate.month == 1 && targetDate.day == 1;

  bool get shouldNotify => notify || isNewYearEvent;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate.toIso8601String(),
      'color': color.value,
      'notify': notify,
    };
  }

  factory CountdownEvent.fromJson(Map<String, dynamic> json) {
    return CountdownEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      color: Color(json['color'] as int? ?? Colors.deepPurple.value),
      notify: json['notify'] as bool? ?? false,
    );
  }
}

class TimeController {
  static const _selectedRangeKey = 'selected_progress_range';
  static const _eventsKey = 'custom_countdown_events';
  static const _selectedEventIdKey = 'selected_event_id';

  ProgressRange selectedRange = ProgressRange.year;
  List<CountdownEvent> events = <CountdownEvent>[];
  String? selectedEventId;

  DateTime _now() => DateTime.now();

  Future<void> init(AppStrings strings) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRange = prefs.getString(_selectedRangeKey);
    final eventsRaw = prefs.getStringList(_eventsKey) ?? <String>[];

    selectedRange = ProgressRange.values.firstWhere(
      (range) => range.storageKey == savedRange,
      orElse: () => ProgressRange.year,
    );

    events = eventsRaw
        .map((raw) => CountdownEvent.fromJson(jsonDecode(raw)))
        .toList()
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));

    selectedEventId = prefs.getString(_selectedEventIdKey);
    if (selectedEventId != null &&
        !events.any((event) => event.id == selectedEventId)) {
      selectedEventId = null;
    }

    await _schedulePendingNotifications(strings);
    await scheduleNewYearReminder(strings);
    await updateWidgetData(strings);
  }

  Future<void> saveSelectedRange(ProgressRange range, AppStrings strings) async {
    selectedRange = range;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedRangeKey, range.storageKey);
    await updateWidgetData(strings);
  }

  Future<void> saveSelectedEvent(String? id, AppStrings strings) async {
    selectedEventId = id;
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_selectedEventIdKey);
    } else {
      await prefs.setString(_selectedEventIdKey, id);
    }
    await updateWidgetData(strings);
  }

  Future<void> addEvent(
    String title,
    DateTime targetDate,
    AppStrings strings, {
    bool notify = false,
    Color? color,
  }) async {
    final event = CountdownEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      targetDate: targetDate,
      notify: notify,
      color: color ?? Colors.deepPurple,
    );
    events.add(event);
    events.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    selectedEventId = event.id;
    await _persistEvents();
    if (event.shouldNotify) {
      await _scheduleEventNotification(event, strings);
    }
    await saveSelectedEvent(event.id, strings);
  }

  Future<void> deleteEvent(String id, AppStrings strings) async {
    final deleted = events.where((event) => event.id == id).toList();
    events.removeWhere((event) => event.id == id);
    if (selectedEventId == id) {
      selectedEventId = null;
    }
    await _persistEvents();
    for (final event in deleted) {
      await NotificationService.instance.cancel(_notificationId(event.id));
    }
    await saveSelectedEvent(selectedEventId, strings);
  }

  CountdownEvent? get selectedEvent {
    if (selectedEventId == null) return null;
    try {
      return events.firstWhere((event) => event.id == selectedEventId);
    } catch (_) {
      return null;
    }
  }

  double calculateRangeProgress() {
    final now = _now();
    final start = selectedRange.periodStart(now);
    final end = selectedRange.nextPeriodStart(now);
    final elapsedMs = now.difference(start).inMilliseconds;
    final totalMs = end.difference(start).inMilliseconds;
    return (elapsedMs / totalMs * 100).clamp(0, 100).toDouble();
  }

  Duration getRemainingInRange() {
    final now = _now();
    final end = selectedRange.nextPeriodStart(now);
    return end.difference(now);
  }

  Duration getRemainingToEvent(CountdownEvent event) {
    return event.targetDate.difference(_now());
  }

  String formatDuration(Duration duration) {
    final positive = duration.isNegative ? Duration.zero : duration;
    final days = positive.inDays;
    final hours = positive.inHours.remainder(24);
    final minutes = positive.inMinutes.remainder(60);
    final seconds = positive.inSeconds.remainder(60);
    return '$days d : $hours h : $minutes m : $seconds s';
  }

  String formatDate(DateTime date, Locale locale) {
    return DateFormat('dd/MM/yyyy HH:mm', locale.languageCode).format(date);
  }

  Future<void> _persistEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = events.map((event) => jsonEncode(event.toJson())).toList();
    await prefs.setStringList(_eventsKey, payload);
  }

  Future<void> updateWidgetData(AppStrings strings) async {
    final progress = calculateRangeProgress();
    final remainingRange = formatDuration(getRemainingInRange());
    final event = selectedEvent;
    final eventText =
        event == null ? strings.noSelectedEvent : formatDuration(getRemainingToEvent(event));

    await HomeWidget.saveWidgetData<String>(
      'rangeTitle',
      '${strings.progressOf} ${selectedRange.localizedLabel(strings)}',
    );
    await HomeWidget.saveWidgetData<String>(
      'rangeProgress',
      '${progress.toStringAsFixed(1)}%',
    );
    await HomeWidget.saveWidgetData<String>('rangeRemaining', remainingRange);
    await HomeWidget.saveWidgetData<String>('eventTitle', event?.title ?? strings.newEvent);
    await HomeWidget.saveWidgetData<String>('eventRemaining', eventText);
    await HomeWidget.updateWidget(androidName: 'CountdownWidgetProvider');
  }

  Future<void> _schedulePendingNotifications(AppStrings strings) async {
    for (final event in events) {
      if (event.shouldNotify) {
        await _scheduleEventNotification(event, strings);
      }
    }
  }

  Future<void> _scheduleEventNotification(
    CountdownEvent event,
    AppStrings strings,
  ) async {
    await NotificationService.instance.scheduleEventNotification(
      id: _notificationId(event.id),
      title: strings.eventFinishedTitle,
      body: event.title,
      scheduledAt: event.targetDate,
    );
  }

  Future<void> scheduleNewYearReminder(AppStrings strings) async {
    final now = DateTime.now();
    final nextYear = DateTime(now.year + 1, 1, 1);
    await NotificationService.instance.scheduleEventNotification(
      id: 1,
      title: strings.newYearTitle,
      body: strings.newYearBody,
      scheduledAt: nextYear,
    );
  }

  int _notificationId(String eventId) => eventId.hashCode.abs() % 2147483647;
}
