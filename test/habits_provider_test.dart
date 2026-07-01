import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/model/habit_adapter.dart';
import 'package:habit_tracker/provider/habits_provider.dart';
import 'package:habit_tracker/utils/utils.dart';
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
        prov.colorsForDay(d1).toSet(), {Color(Colors.red.toARGB32())});
    expect(
        prov.colorsForDay(d2).toSet(), {Color(Colors.red.toARGB32())});
  });

  test('removeLog - colorsForDay', () async {
    final h1 = Habit(name: 'Test1', color: Colors.red);
    final h2 = Habit(name: 'Test2', color: Colors.blue);
    await prov.addHabit(h1);
    await prov.addHabit(h2);

    final d = DateTime(2025, 8, 12);
    await prov.logAt(h1, d);
    await prov.logAt(h2, d);

    expect(prov.colorsForDay(d).toSet(),
        {Color(Colors.red.toARGB32()), Color(Colors.blue.toARGB32())});

    await prov.removeLog(h1, d);
    expect(
        prov.colorsForDay(d).toSet(), {Color(Colors.blue.toARGB32())});
  });

  test('deleteHabit - colorsForDay', () async {
    final h = Habit(name: 'Test', color: Colors.red);
    await prov.addHabit(h);

    final d = DateTime(2025, 8, 12);
    await prov.logAt(h, d);

    expect(
        prov.colorsForDay(d).toSet(), {Color(Colors.red.toARGB32())});

    await prov.deleteHabit(h);
    expect(prov.colorsForDay(d), isEmpty);
  });

  test('updateHabit - colorsForDay', () async {
    final h = Habit(name: 'Test', color: Colors.red);
    await prov.addHabit(h);

    final d = DateTime(2025, 8, 13);
    await prov.logAt(h, d);
    expect(
        prov.colorsForDay(d).toSet(), {Color(Colors.red.toARGB32())});

    h.colorInt = Colors.purple.toARGB32();
    await prov.updateHabit(h);
    expect(
        prov.colorsForDay(d).toSet(), {Color(Colors.purple.toARGB32())});
  });

  test('addHabit - routine fields persisted', () async {
    final r = Habit(
      name: 'Morning Run',
      color: Colors.green,
      isRoutine: true,
      intervalMinutes: 1440,
      notificationStartMinutes: 480,
    );

    await prov.addHabit(r);

    expect(prov.habits.length, 1);
    expect(prov.habits.first.isRoutine, isTrue);
    expect(prov.habits.first.intervalMinutes, 1440);
    expect(prov.habits.first.notificationStartMinutes, 480);
  });

  test('routines getter - returns only routines', () async {
    final h = Habit(name: 'Meditate', color: Colors.blue);
    final r = Habit(
      name: 'Stretch',
      color: Colors.orange,
      isRoutine: true,
      intervalMinutes: 120,
      notificationStartMinutes: 360,
    );

    await prov.addHabit(h);
    await prov.addHabit(r);

    expect(prov.habits.length, 2);
    expect(prov.routines.length, 1);
    expect(prov.routines.first.name, 'Stretch');
  });

  test('updateHabit - routine can be changed to habit', () async {
    final r = Habit(
      name: 'Walk',
      color: Colors.teal,
      isRoutine: true,
      intervalMinutes: 60,
      notificationStartMinutes: 720,
    );
    await prov.addHabit(r);
    expect(prov.routines.length, 1);

    r
      ..isRoutine = false
      ..intervalMinutes = null
      ..notificationStartMinutes = null;
    await prov.updateHabit(r);

    expect(prov.routines, isEmpty);
    expect(prov.habits.first.isRoutine, isFalse);
  });

  test('deleteHabit - routine removed', () async {
    final r = Habit(
      name: 'Yoga',
      color: Colors.pink,
      isRoutine: true,
      intervalMinutes: 1440,
      notificationStartMinutes: 360,
    );
    await prov.addHabit(r);
    expect(prov.habits.length, 1);

    await prov.deleteHabit(r);
    expect(prov.habits, isEmpty);
    expect(prov.routines, isEmpty);
  });

  group('formatInterval', () {
    Habit makeRoutine(int mins) => Habit(
          name: 'x',
          color: Colors.red,
          isRoutine: true,
          intervalMinutes: mins,
          notificationStartMinutes: 0,
        );

    test('minutes', () {
      expect(formatInterval(makeRoutine(30)), allOf(contains('30'), contains('min')));
      expect(formatInterval(makeRoutine(1)), allOf(contains('1'), contains('min')));
    });

    test('hours', () {
      expect(formatInterval(makeRoutine(60)), allOf(contains('1'), contains('hour')));
      expect(formatInterval(makeRoutine(120)), allOf(contains('2'), contains('hour')));
    });

    test('days', () {
      expect(formatInterval(makeRoutine(1440)), allOf(contains('1'), contains('day')));
      expect(formatInterval(makeRoutine(2880)), allOf(contains('2'), contains('day')));
    });

    test('non-routine returns empty', () {
      final h = Habit(name: 'x', color: Colors.red);
      expect(formatInterval(h), '');
    });
  });

  Habit makeScheduled({required int intervalMinutes, DateTime? created}) {
    final t = created ?? DateTime.now();
    return Habit(
      name: 'x',
      color: Colors.red,
      isRoutine: true,
      intervalMinutes: intervalMinutes,
      notificationStartMinutes: t.hour * 60 + t.minute,
      created: t,
    );
  }

  group('nextDueTime', () {
    test('returns null when no schedule', () {
      expect(nextDueTime(Habit(name: 'x', color: Colors.red)), isNull);
    });

    test('future anchor returns future time', () {
      final r = makeScheduled(
        intervalMinutes: 60,
        created: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(nextDueTime(r), isNotNull);
      expect(nextDueTime(r)!.isAfter(DateTime.now()), isTrue);
    });

    test('past anchor advances within one interval of now', () {
      final r = makeScheduled(
        intervalMinutes: 60,
        created: DateTime.now().subtract(const Duration(hours: 25)),
      );
      final diff = nextDueTime(r)!.difference(DateTime.now()).inMinutes;
      expect(diff, inInclusiveRange(0, 60));
    });
  });

  group('formatDueTime', () {
    test('scheduled routine contains due', () {
      final r = makeScheduled(
        intervalMinutes: 1440,
        created: DateTime.now().add(const Duration(hours: 2)),
      );
      expect(formatDueTime(r), contains('Due'));
    });

    test('no schedule contains fallback message', () {
      expect(formatDueTime(Habit(name: 'x', color: Colors.red)),
          contains('No schedule'));
    });
  });
}
