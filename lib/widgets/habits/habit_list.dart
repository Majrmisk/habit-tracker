import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../utils/utils.dart';

class HabitList extends StatelessWidget {
  final List<Habit> habits;
  final void Function(Habit) onHabitDone;
  final void Function(Habit) onHabitTap;

  const HabitList({super.key,
    required this.habits,
    required this.onHabitDone,
    required this.onHabitTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (habits.isEmpty) {
      return Center(
        child: Text(
          'No habits yet.',
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: habits.length,
      itemBuilder: (_, i) {
        final h = habits[i];
        final lastDone = h.datesDone.isNotEmpty
            ? h.datesDone.reduce((a, b) => a.isAfter(b) ? a : b)
            : null;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            onTap: () => onHabitTap(h),
            leading: CircleAvatar(backgroundColor: h.color),
            title: Text(h.name),
            subtitle: Text(
              lastDone != null
                  ? formatElapsedTime(lastDone)
                  : 'Never done',
            ),
            trailing: IconButton(
              icon: Icon(Icons.add, color: scheme.primary),
              onPressed: () => onHabitDone(h),
            ),
          ),
        );
      },
    );
  }
}
