import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Habit extends HiveObject {
  String name;
  int colorInt;
  List<DateTime> datesDone;

  Habit({
    required this.name,
    required Color color,
    List<DateTime>? datesDone,
  })  : colorInt = color.toARGB32(),
        datesDone = datesDone ?? [];

  Color get color => Color(colorInt);
}