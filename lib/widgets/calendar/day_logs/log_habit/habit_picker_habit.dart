import 'package:flutter/material.dart';

import '../../../../model/habit.dart';
import '../../../../utils/utils.dart';

class HabitPickerHabit extends StatelessWidget {
  final Habit habit;
  final bool selected;
  const HabitPickerHabit({super.key, required this.habit, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: selected ? 10 : 6,
        ),
        decoration: BoxDecoration(
          color: habit.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          habit.name,
          style: TextStyle(
            color: contrastTextColor(habit.color),
            fontSize: selected ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
