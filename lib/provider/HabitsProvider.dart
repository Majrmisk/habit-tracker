import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/habit.dart';

class HabitsProvider extends ChangeNotifier {
  static const boxName = 'habit_tracker_habits';

  final Box<Habit> _box = Hive.box<Habit>(boxName);

  List<Habit> get habits => _box.values.toList();

  Future<void> addHabit(Habit habit) async {
    await _box.add(habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await habit.save();
    notifyListeners();
  }

  Future<void> deleteHabit(Habit habit) async {
    await habit.delete();
    notifyListeners();
  }

  Future<void> logNow(Habit habit) async {
    habit.datesDone.add(DateTime.now());
    await habit.save();
    notifyListeners();
  }

  Future<void> logAt(Habit habit, DateTime date) async {
    habit.datesDone.add(date);
    await habit.save();
    notifyListeners();
  }

  Future<void> removeLog(Habit habit, DateTime date) async {
    habit.datesDone.remove(date);
    await habit.save();
    notifyListeners();
  }
}
