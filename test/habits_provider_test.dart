import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/model/habit_adapter.dart';
import 'package:habit_tracker/provider/habits_provider.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tmp;
  late Box<Habit> box;
  late HabitsProvider prov;

  setUpAll(() async {
    tmp = await Directory.systemTemp.createTemp('habits_hive_test');
    Hive.init(tmp.path);
    Hive.registerAdapter(HabitAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    await tmp.delete(recursive: true);
  });

  setUp(() async {
    box = await Hive.openBox<Habit>(HabitsProvider.boxName);
    prov = HabitsProvider();
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  test('addHabit - habit added', () async {
    final h = Habit(name: 'Test', color: Colors.red);

    await prov.addHabit(h);

    expect(prov.habits.length, 1);
    expect(prov.colorsForDay(DateTime.now()), isEmpty);
  });

  test('addHabit - colorsForDay', () async {
    final h = Habit(name: 'Test', color: Colors.red);
    final d1 = DateTime(2025, 8, 10);
    final d2 = DateTime(2025, 8, 11);

    await prov.addHabit(h);
    await prov.logAt(h, d1);
    await prov.logAt(h, d2);


    expect(
        prov.colorsForDay(d1).toSet(),
        {Color(Colors.red.toARGB32())}
    );
    expect(
        prov.colorsForDay(d2).toSet(),
        {Color(Colors.red.toARGB32())}
    );
  });

  test('removeLog - colorsForDay', () async {
    final h1 = Habit(name: 'Test1', color: Colors.red);
    final h2 = Habit(name: 'Test2', color: Colors.blue);
    await prov.addHabit(h1);
    await prov.addHabit(h2);

    final d = DateTime(2025, 8, 12);
    await prov.logAt(h1, d);
    await prov.logAt(h2, d);

    expect(
        prov.colorsForDay(d).toSet(),
        {Color(Colors.red.toARGB32()), Color(Colors.blue.toARGB32())}
    );

    await prov.removeLog(h1, d);
    expect(
        prov.colorsForDay(d).toSet(),
        {Color(Colors.blue.toARGB32())}
    );
  });

  test('deleteHabit - colorsForDay', () async {
    final h = Habit(name: 'Test', color: Colors.red);
    await prov.addHabit(h);

    final d = DateTime(2025, 8, 12);
    await prov.logAt(h, d);

    expect(
        prov.colorsForDay(d).toSet(),
        {Color(Colors.red.toARGB32())}
    );

    await prov.deleteHabit(h);
    expect(prov.colorsForDay(d), isEmpty);
  });

  test('updateHabit - colorsForDay', () async {
    final h = Habit(name: 'Test', color: Colors.red);
    await prov.addHabit(h);

    final d = DateTime(2025, 8, 13);
    await prov.logAt(h, d);
    expect(
        prov.colorsForDay(d).toSet(),
        {Color(Colors.red.toARGB32())}
    );

    h.colorInt = Colors.purple.toARGB32();
    await prov.updateHabit(h);
    expect(
        prov.colorsForDay(d).toSet(),
        {Color(Colors.purple.toARGB32())}
    );
  });
}
