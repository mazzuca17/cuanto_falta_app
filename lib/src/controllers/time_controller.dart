import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ProgressRange { day, week, month, year }

extension ProgressRangeX on ProgressRange {
  String get storageKey => name;

  String get label {
    switch (this) {
      case ProgressRange.day:
        return 'Día';
      case ProgressRange.week:
        return 'Semana';
      case ProgressRange.month:
        return 'Mes';
      case ProgressRange.year:
        return 'Año';
    }
  }

  DateTime periodStart(DateTime now) {
    switch (this) {
      case ProgressRange.day:
        return DateTime(now.year, now.month, now.day);
      case ProgressRange.week:
        final mondayOffset = now.weekday - DateTime.monday;
        final monday = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: mondayOffset));
        return monday;
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
        final start = periodStart(now);
        return start.add(const Duration(days: 7));
      case ProgressRange.month:
        return DateTime(now.year, now.month + 1, 1);
      case ProgressRange.year:
        return DateTime(now.year + 1, 1, 1);
    }
  }
}

class CountdownEvent {
  CountdownEvent({
    required this.id,
    required this.title,
    required this.targetDate,
    this.color = Colors.deepPurple,
  });

  final String id;
  final String title;
  final DateTime targetDate;
  final Color color;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate.toIso8601String(),
      'color': color.value,
    };
  }

  factory CountdownEvent.fromJson(Map<String, dynamic> json) {
    return CountdownEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      color: Color(json['color'] as int? ?? Colors.deepPurple.value),
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

  Future<void> init() async {
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

    await updateWidgetData();
  }

  Future<void> saveSelectedRange(ProgressRange range) async {
    selectedRange = range;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedRangeKey, range.storageKey);
    await updateWidgetData();
  }

  Future<void> saveSelectedEvent(String? id) async {
    selectedEventId = id;
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_selectedEventIdKey);
    } else {
      await prefs.setString(_selectedEventIdKey, id);
    }
    await updateWidgetData();
  }

  Future<void> addEvent(String title, DateTime targetDate, {Color? color}) async {
    final event = CountdownEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      targetDate: targetDate,
      color: color ?? Colors.deepPurple,
    );
    events.add(event);
    events.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    selectedEventId = event.id;
    await _persistEvents();
    await saveSelectedEvent(event.id);
  }

  Future<void> deleteEvent(String id) async {
    events.removeWhere((event) => event.id == id);
    if (selectedEventId == id) {
      selectedEventId = null;
    }
    await _persistEvents();
    await saveSelectedEvent(selectedEventId);
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
    return '$days d : $hours hs : $minutes min : $seconds seg';
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<void> _persistEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = events.map((event) => jsonEncode(event.toJson())).toList();
    await prefs.setStringList(_eventsKey, payload);
  }

  Future<void> updateWidgetData() async {
    final progress = calculateRangeProgress();
    final remainingRange = formatDuration(getRemainingInRange());
    final event = selectedEvent;
    final eventText = event == null
        ? 'Sin evento seleccionado'
        : formatDuration(getRemainingToEvent(event));

    await HomeWidget.saveWidgetData<String>(
        'rangeTitle', 'Progreso ${selectedRange.label}');
    await HomeWidget.saveWidgetData<String>(
        'rangeProgress', '${progress.toStringAsFixed(1)}%');
    await HomeWidget.saveWidgetData<String>('rangeRemaining', remainingRange);
    await HomeWidget.saveWidgetData<String>('eventTitle', event?.title ?? 'Mi evento');
    await HomeWidget.saveWidgetData<String>('eventRemaining', eventText);
    await HomeWidget.updateWidget(
      androidName: 'CountdownWidgetProvider',
    );
  }
}
