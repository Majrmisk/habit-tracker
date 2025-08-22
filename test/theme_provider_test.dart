import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/provider/theme_provider.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tmp;
  late Box box;
  late ThemeProvider prov;

  setUpAll(() async {
    tmp = await Directory.systemTemp.createTemp('theme_hive_test');
    Hive.init(tmp.path);
  });

  tearDownAll(() async {
    await Hive.close();
    await tmp.delete(recursive: true);
  });

  setUp(() async {
    box = await Hive.openBox(ThemeProvider.boxName);
    prov = ThemeProvider();
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  test('mode persists', () async {
    prov.setMode(ThemeMode.dark);

    await box.flush();
    await box.close();

    box = await Hive.openBox(ThemeProvider.boxName);
    final prov2 = ThemeProvider();

    expect(prov2.mode, ThemeMode.dark);
  });

  test('useDynamic persists', () async {
    prov.setUseDynamic(false);

    await box.flush();
    await box.close();

    box = await Hive.openBox(ThemeProvider.boxName);
    final prov2 = ThemeProvider();

    expect(prov2.useDynamic, false);
  });

  test('seed color persists', () async {
    prov.setSeed(Colors.red);

    await box.flush();
    await box.close();

    box = await Hive.openBox(ThemeProvider.boxName);
    final prov2 = ThemeProvider();

    expect(prov2.seed.toARGB32(), Colors.red.toARGB32());
  });
}
