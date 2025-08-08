import 'package:flutter/material.dart';
import 'package:habit_tracker/widgets/habits/habit_details/header_bar.dart';
import 'package:habit_tracker/widgets/habits/habit_details/log_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/habit.dart';
import '../../../provider/HabitsProvider.dart';
import '../manage_habit/manage_habit_sheet.dart';

class HabitDetailsSheet extends StatefulWidget {
  final Habit habit;
  const HabitDetailsSheet({super.key, required this.habit});

  @override
  State<HabitDetailsSheet> createState() => _HabitDetailsSheetState();
}

class _HabitDetailsSheetState extends State<HabitDetailsSheet> {
  final _formatter = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final history = widget.habit.datesDone.toList()
      ..sort((a, b) => b.compareTo(a));

    return SizedBox(
      height: maxHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          color: scheme.surfaceContainerHighest,
          child: Column(
            children: [
              HeaderBar(
                  habit: widget.habit,
                  openEdit: _openEdit,
                  openDelete: _openDelete
              ),
              Expanded(
                child: history.isEmpty
                  ? Center(
                      child: Text(
                        'Never done',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final label = _formatter.format(history[i]);
                        return ListTile(
                          title: Text(label),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: scheme.secondary,
                            onPressed: () => setState(() {
                              context
                                  .read<HabitsProvider>()
                                  .removeLog(widget.habit, history[i]);
                            }),
                          ),
                        );
                      },
                    ),
              ),

              LogBar(
                habit: widget.habit,
                addSpecific: _addSpecific,
                addNow: _addNow,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEdit() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ManageHabitSheet(habit: widget.habit),
    );

    setState(() {
    });
  }

  Future<void> _openDelete() async {
    final habitsProv = context.read<HabitsProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Habit?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(100, 50),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(100, 50),
              backgroundColor: Color(0xFF9A3D3D),
              foregroundColor: Color(0xFFFFE5E5),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      habitsProv.deleteHabit(widget.habit);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _addNow() async {
    setState(() {
      context.read<HabitsProvider>().logNow(widget.habit);
    });
  }

  Future<void> _addSpecific() async {
    final habitsProv = context.read<HabitsProvider>();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    await habitsProv.logAt(
        widget.habit,
        DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
        ),
    );
    setState(() {});
  }
}
