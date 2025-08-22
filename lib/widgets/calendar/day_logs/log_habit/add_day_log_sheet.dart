import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/habit.dart';
import '../../../../provider/habits_provider.dart';
import '../../../../utils/confirm_buttons_row.dart';
import 'habit_picker.dart';

class AddDayLogSheet extends StatefulWidget {
  final DateTime date;
  const AddDayLogSheet({super.key, required this.date});

  @override
  State<AddDayLogSheet> createState() => _AddDayLogSheetState();
}

class _AddDayLogSheetState extends State<AddDayLogSheet> {
  late TimeOfDay _time;
  late Habit _selected;

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final habits = context.watch<HabitsProvider>().habits;

    _selected = habits.first;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Container(
        color: scheme.surfaceContainerHighest,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(
                      _time.format(context),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: HabitPicker(
                  habits: habits,
                  onChanged: (habit) => _selected = habit,
                ),
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ButtonsRow(
                    confirmText: 'Add',
                    onConfirm: () async {
                      final provider = context.read<HabitsProvider>();
                      final d = widget.date;
                      final t = _time;
                      await provider.logAt(
                        _selected,
                        DateTime(d.year, d.month, d.day, t.hour, t.minute),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      )
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }
}