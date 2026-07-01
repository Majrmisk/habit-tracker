import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/utils/confirm_buttons_row.dart';
import 'package:provider/provider.dart';

import '../../../model/habit.dart';
import '../../../provider/habits_provider.dart';
import '../../../utils/utils.dart';
import '../../../utils/grid_color_picker.dart';

enum _IntervalUnit { minutes, hours, days }

extension _IntervalUnitLabel on _IntervalUnit {
  String get label {
    switch (this) {
      case _IntervalUnit.minutes:
        return 'minutes';
      case _IntervalUnit.hours:
        return 'hours';
      case _IntervalUnit.days:
        return 'days';
    }
  }

  int get multiplier {
    switch (this) {
      case _IntervalUnit.minutes:
        return 1;
      case _IntervalUnit.hours:
        return 60;
      case _IntervalUnit.days:
        return 1440;
    }
  }
}

class ManageHabitSheet extends StatefulWidget {
  final Habit? habit;
  const ManageHabitSheet({super.key, this.habit});

  @override
  State<ManageHabitSheet> createState() => _ManageHabitSheetState();
}

class _ManageHabitSheetState extends State<ManageHabitSheet> {
  late TextEditingController _nameController;
  late TextEditingController _intervalValueController;
  late Color _picked;
  late bool _isRoutine;
  late _IntervalUnit _intervalUnit;
  late TimeOfDay _startTime;

  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    _nameController = TextEditingController(text: habit?.name ?? '');
    _picked = habit?.color ?? Colors.deepPurple;
    _isRoutine = habit?.isRoutine ?? false;

    if (habit != null && habit.isRoutine && habit.intervalMinutes != null) {
      final mins = habit.intervalMinutes!;
      if (mins % 1440 == 0) {
        _intervalUnit = _IntervalUnit.days;
        _intervalValueController =
            TextEditingController(text: (mins ~/ 1440).toString());
      } else if (mins % 60 == 0) {
        _intervalUnit = _IntervalUnit.hours;
        _intervalValueController =
            TextEditingController(text: (mins ~/ 60).toString());
      } else {
        _intervalUnit = _IntervalUnit.minutes;
        _intervalValueController =
            TextEditingController(text: mins.toString());
      }
    } else {
      _intervalUnit = _IntervalUnit.hours;
      _intervalValueController = TextEditingController(text: '1');
    }

    final startMins = habit?.notificationStartMinutes ?? 480; // default 8:00 AM
    _startTime = TimeOfDay(hour: startMins ~/ 60, minute: startMins % 60);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _intervalValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: scheme.surfaceContainerHighest,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: scheme.surfaceContainerLow,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Habit')),
                    ButtonSegment(value: true, label: Text('Routine')),
                  ],
                  showSelectedIcon: false,
                  selected: {_isRoutine},
                  onSelectionChanged: (s) =>
                      setState(() => _isRoutine = s.first),
                  style: ButtonStyle(
                    textStyle: const WidgetStatePropertyAll(
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    backgroundColor:
                        WidgetStateProperty.resolveWith((states) {
                      return states.contains(WidgetState.selected)
                          ? scheme.primary
                          : scheme.surfaceContainerLow;
                    }),
                    foregroundColor:
                        WidgetStateProperty.resolveWith((states) {
                      return states.contains(WidgetState.selected)
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant;
                    }),
                    side: const WidgetStatePropertyAll(
                        BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              GridColorPicker(
                palette: habitsPalette,
                picked: _picked,
                onPick: (color) => setState(() => _picked = color),
              ),

              if (_isRoutine) ...[
                const SizedBox(height: 16),
                _buildRoutineSettings(scheme),
              ],

              const SizedBox(height: 16),

              ButtonsRow(
                confirmText: widget.habit == null ? 'Add' : 'Save',
                onConfirm: _onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineSettings(ColorScheme scheme) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder',
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // "Every [N] [unit]" row
        Row(
          children: [
            Text('Every', style: TextStyle(color: scheme.onSurface)),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              child: TextField(
                controller: _intervalValueController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                decoration: inputDecoration,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<_IntervalUnit>(
                initialValue: _intervalUnit,
                decoration: inputDecoration,
                borderRadius: BorderRadius.circular(12),
                items: _IntervalUnit.values
                    .map((u) => DropdownMenuItem(
                          value: u,
                          child: Text(u.label),
                        ))
                    .toList(),
                onChanged: (u) {
                  if (u != null) setState(() => _intervalUnit = u);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // "Starting at [time]" row
        Row(
          children: [
            Text('Starting at', style: TextStyle(color: scheme.onSurface)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _pickStartTime,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _startTime.format(context),
                  style: TextStyle(color: scheme.onSurface),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _onConfirm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    int? intervalMinutes;
    int? notificationStartMinutes;

    if (_isRoutine) {
      final raw = int.tryParse(_intervalValueController.text.trim()) ?? 1;
      intervalMinutes = (raw.clamp(1, 99999)) * _intervalUnit.multiplier;
      notificationStartMinutes =
          _startTime.hour * 60 + _startTime.minute;
    }

    final provider = context.read<HabitsProvider>();

    if (widget.habit == null) {
      await provider.addHabit(Habit(
        name: name,
        color: _picked,
        isRoutine: _isRoutine,
        intervalMinutes: intervalMinutes,
        notificationStartMinutes: notificationStartMinutes,
      ));
    } else {
      widget.habit!
        ..name = name
        ..colorInt = _picked.toARGB32()
        ..isRoutine = _isRoutine
        ..intervalMinutes = intervalMinutes
        ..notificationStartMinutes = notificationStartMinutes;
      await provider.updateHabit(widget.habit!);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
}
