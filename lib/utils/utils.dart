import 'package:flutter/material.dart';

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

  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    if (m == 0) {
      return 'Last done just now';
    }
    return 'Last done $m minute${m == 1 ? '' : 's'} ago';
  } else if (diff.inHours < 24) {
    final h = diff.inHours;
    return 'Last done $h hour${h == 1 ? '' : 's'} ago';
  } else {
    final d = diff.inDays;
    return 'Last done $d day${d == 1 ? '' : 's'} ago';
  }
}