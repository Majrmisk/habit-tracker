import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const boxName = 'prefs';

  final Box _box = Hive.box(boxName);

  static const _modeName = 'themeMode';
  static const _dynamicName = 'useDynamic';
  static const _seedName = 'seedColor';

  ThemeMode _mode = ThemeMode.system;
  bool _useDynamic = true;
  Color _seed = Colors.deepPurple;

  ThemeMode get mode => _mode;
  bool get useDynamic => _useDynamic;
  Color get seed => _seed;

  ThemeProvider() {
    final mode = _box.get(_modeName) as int?;
    if (mode != null) {
      _mode = ThemeMode.values[mode];
    }

    _useDynamic = _box.get(_dynamicName, defaultValue: true) as bool;

    final seed = _box.get(_seedName) as int?;
    if (seed != null) {
      _seed = Color(seed);
    }
  }

  void setMode(ThemeMode mode) {
    _mode = mode;
    _box.put(_modeName, mode.index);
    notifyListeners();
  }

  void setUseDynamic(bool useDynamic) {
    _useDynamic = useDynamic;
    _box.put(_dynamicName, useDynamic);
    notifyListeners();
  }

  void setSeed(Color seed) {
    _seed = seed;
    _box.put(_seedName, seed.toARGB32());
    notifyListeners();
  }
}
