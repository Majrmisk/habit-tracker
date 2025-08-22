import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'habit.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    return Habit(
      name: reader.readString(),
      color: Color(reader.readInt()),
      datesDone: reader.readList().cast<DateTime>(),
      created: reader.read()
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.colorInt);
    writer.writeList(obj.datesDone);
    writer.write(obj.created);
  }
}