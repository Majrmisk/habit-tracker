import 'package:flutter/material.dart';

import '../model/habit.dart';

const themePalette = [
  Colors.red,
  Colors.pinkAccent,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.lime,
  Colors.amber,
  Colors.deepOrange,
];

const habitsPalette = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.black,
  Colors.white,
];

DateTime roundDay(DateTime d) => DateTime(d.year, d.month, d.day);

Color contrastTextColor(Color background) {
  final brightness = ThemeData.estimateBrightnessForColor(background);
  return brightness == Brightness.dark ? Colors.white : Colors.black;
}

String formatElapsedTime(DateTime lastDone) {
  final diff = DateTime.now().difference(lastDone);

  if (diff.inMinutes == 0) return 'Last done just now';
  return 'Last done ${formatDuration(diff)} ago';
}

DateTime? nextDueTime(Habit routine) {
  final interval = routine.intervalMinutes;
  final startMins = routine.notificationStartMinutes;
  if (interval == null || interval <= 0 || startMins == null) return null;

  final now = DateTime.now();
  final anchor = DateTime(
    routine.created.year,
    routine.created.month,
    routine.created.day,
    startMins ~/ 60,
    startMins % 60,
  );

  if (anchor.isAfter(now)) return anchor;

  final elapsed = now.difference(anchor).inMinutes;
  final steps = (elapsed / interval).ceil();
  return anchor.add(Duration(minutes: steps * interval));
}

String formatDueTime(Habit routine) {
  final next = nextDueTime(routine);
  if (next == null) return 'No schedule set';
  final diff = next.difference(DateTime.now());
  return 'Due in ${formatDuration(diff)}';
}

String formatDuration(Duration d) {
  if (d.inMinutes < 1) return 'less than a minute';
  if (d.inMinutes < 60) return '${d.inMinutes} min(s)';
  if (d.inHours < 24) return '${d.inHours} hour(s)';
  return '${d.inDays} day(s)';
}

String formatInterval(Habit routine) {
  final interval = routine.intervalMinutes;
  if (interval == null || interval <= 0) return '';
  return 'every ${formatDuration(Duration(minutes: interval))}';
}