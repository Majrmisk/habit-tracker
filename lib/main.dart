import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/HabitsProvider.dart';
import 'package:hive_flutter/adapters.dart';

import 'model/habit.dart';
import 'model/habit_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>(HabitsProvider.boxName);

  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
