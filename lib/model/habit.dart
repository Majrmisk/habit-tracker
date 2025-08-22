import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Habit extends HiveObject {
  String name;
  int colorInt;
  List<DateTime> datesDone;
  DateTime created;

  Habit({
    required this.name,
    required Color color,
    List<DateTime>? datesDone,
    DateTime? created
  })  : colorInt = color.toARGB32(),
        datesDone = datesDone ?? [],
        created = created ?? DateTime.now();

  Color get color => Color(colorInt);
}