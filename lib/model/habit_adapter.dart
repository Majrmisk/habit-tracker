import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'habit.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final name = reader.readString();
    final color = Color(reader.readInt());
    final datesDone = reader.readList().cast<DateTime>();
    final created = reader.read() as DateTime;

    bool isRoutine = false;
    int? intervalMinutes;
    int? notificationStartMinutes;

    try {
      isRoutine = reader.readBool();
      final rawInterval = reader.readInt();
      intervalMinutes = rawInterval <= 0 ? null : rawInterval;
      final rawStart = reader.readInt();
      notificationStartMinutes = rawStart < 0 ? null : rawStart;
    } catch (_) {
      // For old records without routine fields
    }

    return Habit(
      name: name,
      color: color,
      datesDone: datesDone,
      created: created,
      isRoutine: isRoutine,
      intervalMinutes: intervalMinutes,
      notificationStartMinutes: notificationStartMinutes,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.colorInt);
    writer.writeList(obj.datesDone);
    writer.write(obj.created);
    writer.writeBool(obj.isRoutine);
    writer.writeInt(obj.intervalMinutes ?? -1);
    writer.writeInt(obj.notificationStartMinutes ?? -1);
  }
}