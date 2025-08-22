import 'package:flutter/material.dart';
import '../../../../model/habit.dart';
import 'habit_picker_habit.dart';

class HabitPicker extends StatefulWidget {
  final List<Habit> habits;
  final ValueChanged<Habit> onChanged;

  const HabitPicker({
    super.key,
    required this.habits,
    required this.onChanged,
  });

  @override
  State<HabitPicker> createState() => _HabitPickerState();
}

class _HabitPickerState extends State<HabitPicker> {
  late FixedExtentScrollController _controller;
  late int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: _index);
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      physics: const FixedExtentScrollPhysics(),
      itemExtent: 56,
      diameterRatio: 2.2,
      perspective: 0.003,
      onSelectedItemChanged: (i) {
        setState(() => _index = i);
        widget.onChanged(widget.habits[i]);
      },

      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.habits.length,
        builder: (_, i) {
          final selected = i == _index;
          return AnimatedScale(
            scale: selected ? 1.2 : 1,
            duration: const Duration(milliseconds: 150),
            child: HabitPickerHabit(
                habit: widget.habits[i],
                selected: selected,
            ),
          );
        },
      ),
    );
  }
}
