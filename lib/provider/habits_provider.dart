import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/habit.dart';
import '../utils/utils.dart';

class HabitsProvider extends ChangeNotifier {
  static const boxName = 'habit_tracker_habits';

  final Box<Habit> _box = Hive.box<Habit>(boxName);

  List<Habit> get habits => _box.values.toList();

  final Map<DateTime, List<Color>> _dayColors = {};
  List<Color> colorsForDay(DateTime day) => _dayColors[roundDay(day)] ?? [];

  HabitsProvider() {
    _rebuildDayColors();
  }

  Future<void> addHabit(Habit habit) async {
    await _box.add(habit);
    _rebuildDayColors();
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await habit.save();
    _rebuildDayColors();
    notifyListeners();
  }

  Future<void> deleteHabit(Habit habit) async {
    await habit.delete();
    _rebuildDayColors();
    notifyListeners();
  }

  Future<void> logNow(Habit habit) async {
    final now = DateTime.now();
    habit.datesDone.add(now);
    await habit.save();
    _rebuildDayColorsForDate(now);
    notifyListeners();
  }

  Future<void> logAt(Habit habit, DateTime date) async {
    habit.datesDone.add(date);
    await habit.save();
    _rebuildDayColorsForDate(date);
    notifyListeners();
  }

  Future<void> removeLog(Habit habit, DateTime date) async {
    habit.datesDone.remove(date);
    await habit.save();
    _rebuildDayColorsForDate(date);
    notifyListeners();
  }

  void _rebuildDayColors() {
    _dayColors.clear();
    for (final habit in habits) {
      final seen = <DateTime>{};
      for (final date in habit.datesDone) {
        final rounded = roundDay(date);
        if (seen.add(rounded)) {
          final list = _dayColors.putIfAbsent(rounded, () => <Color>[]);
          if (!list.contains(habit.color)) {
            list.add(habit.color);
          }
        }
      }
    }
  }

  void _rebuildDayColorsForDate(DateTime date) {
    final rounded = roundDay(date);
    final colors = <Color>{};
    for (final habit in habits) {
      if (habit.datesDone.any((d) => roundDay(d) == rounded)) {
        colors.add(habit.color);
      }
    }
    if (colors.isEmpty) {
      _dayColors.remove(rounded);
    } else {
      _dayColors[rounded] = colors.toList();
    }
  }
}
