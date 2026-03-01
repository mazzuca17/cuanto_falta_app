import 'dart:async';

import 'package:cuanto_falta_app/src/controllers/time_controller.dart';
import 'package:cuanto_falta_app/src/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.currentThemeMode,
    required this.currentLocale,
  });

  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode currentThemeMode;
  final Locale currentLocale;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TimeController timeController = TimeController();
  Timer? timer;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted || loading) return;
      setState(() {});
      await timeController.updateWidgetData(AppStrings.of(context));
    });
  }

  Future<void> _loadData() async {
    await timeController.init(AppStrings.of(context));
    if (!mounted) return;
    setState(() => loading = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _openAddEventDialog(AppStrings strings) async {
    final titleController = TextEditingController();
    DateTime? pickedDate;
    bool notify = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.newEvent),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              final isNewYear =
                  pickedDate != null && pickedDate!.month == 1 && pickedDate!.day == 1;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: strings.eventHint),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final date = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: DateTime(now.year + 10),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time == null) return;
                      setDialogState(() {
                        pickedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                        if (pickedDate!.month == 1 && pickedDate!.day == 1) {
                          notify = true;
                        }
                      });
                    },
                    icon: const Icon(Icons.event),
                    label: Text(
                      pickedDate == null
                          ? strings.pickDateTime
                          : timeController.formatDate(
                              pickedDate!,
                              Localizations.localeOf(context),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isNewYear ? true : notify,
                    onChanged: isNewYear
                        ? null
                        : (value) => setDialogState(() => notify = value ?? false),
                    title: Text(strings.notifyWhenFinished),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty || pickedDate == null) return;
                await timeController.addEvent(
                  title,
                  pickedDate!,
                  strings,
                  notify: notify,
                );
                if (!mounted) return;
                setState(() {});
                Navigator.pop(context);
              },
              child: Text(strings.save),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    if (loading) {
      return Scaffold(body: Center(child: Text(strings.loading)));
    }

    final progress = timeController.calculateRangeProgress();
    final selectedEvent = timeController.selectedEvent;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
        actions: [_buildThemeAndLanguageMenus(strings)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddEventDialog(strings),
        icon: const Icon(Icons.add),
        label: Text(strings.newEvent),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildRangeSelector(strings),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('${strings.progressOf} ${timeController.selectedRange.localizedLabel(strings)}'),
                    const SizedBox(height: 20),
                    CircularPercentIndicator(
                      radius: 120,
                      lineWidth: 14,
                      percent: progress / 100,
                      animation: false,
                      progressColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      center: Text(
                        '${progress.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${strings.remaining} ${timeController.formatDuration(timeController.getRemainingInRange())}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildEventSection(selectedEvent, strings),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeAndLanguageMenus(AppStrings strings) {
    return Row(
      children: [
        PopupMenuButton<ThemeMode>(
          tooltip: strings.theme,
          initialValue: widget.currentThemeMode,
          onSelected: widget.onThemeChanged,
          itemBuilder: (_) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Text(strings.system),
            ),
            PopupMenuItem(value: ThemeMode.light, child: Text(strings.light)),
            PopupMenuItem(value: ThemeMode.dark, child: Text(strings.dark)),
          ],
          icon: const Icon(Icons.palette_outlined),
        ),
        PopupMenuButton<Locale>(
          tooltip: strings.language,
          initialValue: widget.currentLocale,
          onSelected: widget.onLocaleChanged,
          itemBuilder: (_) => const [
            PopupMenuItem(value: Locale('es'), child: Text('Español')),
            PopupMenuItem(value: Locale('en'), child: Text('English')),
          ],
          icon: const Icon(Icons.language),
        ),
      ],
    );
  }

  Widget _buildRangeSelector(AppStrings strings) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ProgressRange.values.map((range) {
        final selected = range == timeController.selectedRange;
        return ChoiceChip(
          label: Text(range.localizedLabel(strings)),
          selected: selected,
          onSelected: (_) async {
            await timeController.saveSelectedRange(range, strings);
            setState(() {});
          },
        );
      }).toList(),
    );
  }

  Widget _buildEventSection(CountdownEvent? selectedEvent, AppStrings strings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.myCountdowns, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            if (timeController.events.isEmpty)
              Text(strings.noEvents)
            else
              ...timeController.events.map(
                (event) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(event.title),
                  subtitle: Text(
                    '${timeController.formatDate(event.targetDate, Localizations.localeOf(context))}\n${strings.remaining} ${timeController.formatDuration(timeController.getRemainingToEvent(event))}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        event.shouldNotify
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                      ),
                      Radio<String>(
                        value: event.id,
                        groupValue: timeController.selectedEventId,
                        onChanged: (value) async {
                          await timeController.saveSelectedEvent(value, strings);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await timeController.deleteEvent(event.id, strings);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (selectedEvent != null) ...[
              const Divider(),
              Text(
                '${strings.activeEvent}: ${selectedEvent.title}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${strings.remaining} ${timeController.formatDuration(timeController.getRemainingToEvent(selectedEvent))}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
