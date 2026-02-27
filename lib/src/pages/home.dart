import 'dart:async';

import 'package:cuanto_falta_app/src/controllers/time_controller.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
      if (!mounted) return;
      setState(() {});
      await timeController.updateWidgetData();
    });
  }

  Future<void> _loadData() async {
    await timeController.init();
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _openAddEventDialog() async {
    final titleController = TextEditingController();
    DateTime? pickedDate;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo evento'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Ej: Juntada fin de año',
                    ),
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
                      });
                    },
                    icon: const Icon(Icons.event),
                    label: Text(
                      pickedDate == null
                          ? 'Elegir fecha y hora'
                          : timeController.formatDate(pickedDate!),
                    ),
                  )
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty || pickedDate == null) return;
                await timeController.addEvent(title, pickedDate!);
                if (!mounted) return;
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progress = timeController.calculateRangeProgress();
    final selectedEvent = timeController.selectedEvent;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0C1024),
      appBar: AppBar(
        title: const Text('Cuánto falta para...'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddEventDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo evento'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C1024), Color(0xFF1B2B5E), Color(0xFF364D9E)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildRangeSelector(),
              const SizedBox(height: 20),
              Card(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Progreso de ${timeController.selectedRange.label}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      CircularPercentIndicator(
                        radius: 120,
                        lineWidth: 14,
                        percent: progress / 100,
                        animation: false,
                        progressColor: const Color(0xFF4BF4A2),
                        backgroundColor: Colors.white24,
                        center: Text(
                          '${progress.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Faltan ${timeController.formatDuration(timeController.getRemainingInRange())}',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildEventSection(selectedEvent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRangeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ProgressRange.values.map((range) {
        final selected = range == timeController.selectedRange;
        return ChoiceChip(
          selectedColor: const Color(0xFF4BF4A2),
          backgroundColor: Colors.white12,
          labelStyle: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          label: Text(range.label),
          selected: selected,
          onSelected: (_) async {
            await timeController.saveSelectedRange(range);
            setState(() {});
          },
        );
      }).toList(),
    );
  }

  Widget _buildEventSection(CountdownEvent? selectedEvent) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mis cuentas regresivas',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            if (timeController.events.isEmpty)
              const Text(
                'Todavía no cargaste eventos personalizados.',
                style: TextStyle(color: Colors.white70),
              )
            else
              ...timeController.events.map(
                (event) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(event.title,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${timeController.formatDate(event.targetDate)}\nFaltan ${timeController.formatDuration(timeController.getRemainingToEvent(event))}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: event.id,
                        groupValue: timeController.selectedEventId,
                        onChanged: (value) async {
                          await timeController.saveSelectedEvent(value);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await timeController.deleteEvent(event.id);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (selectedEvent != null) ...[
              const Divider(color: Colors.white24),
              Text(
                'Evento activo: ${selectedEvent.title}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Text(
                'Faltan ${timeController.formatDuration(timeController.getRemainingToEvent(selectedEvent))}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
