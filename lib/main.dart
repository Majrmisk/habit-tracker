import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/habits_provider.dart';
import 'package:hive_flutter/adapters.dart';

import 'model/habit.dart';
import 'model/habit_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>(HabitsProvider.boxName);
  await Hive.openBox(ThemeProvider.boxName);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();

    return DynamicColorBuilder(
      builder: (ColorScheme? dynamicLight, ColorScheme? dynamicDark) {
        final useDynamic = themeProv.useDynamic
            && dynamicLight != null
            && dynamicDark != null;

        ColorScheme light;
        ColorScheme dark;
        if (useDynamic) {
          light = dynamicLight;
          dark = dynamicDark;
        }
        else {
          light = ColorScheme.fromSeed(seedColor: themeProv.seed, brightness: Brightness.light);
          dark = ColorScheme.fromSeed(seedColor: themeProv.seed, brightness: Brightness.dark);
        }

        return MaterialApp(
          themeMode: themeProv.mode,
          theme: ThemeData(colorScheme: light),
          darkTheme: ThemeData(colorScheme: dark),
          home: const HomePage(),
        );
      },
    );
  }
}
