import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/habit.dart';
import '../provider/HabitsProvider.dart';
import '../widgets/habits/manage_habit/manage_habit_sheet.dart';
import '../widgets/calendar/calendar_card.dart';
import '../widgets/habits/habit_details/habit_details_sheet.dart';
import '../widgets/habits/habit_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeScaffold(
        habits: context.watch<HabitsProvider>().habits,
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  final List<Habit> _habits;
  const _HomeScaffold({required List<Habit> habits}) : _habits = habits;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: scheme.surfaceContainerHighest,
        height: 50,
        child: Center(
          child: IconButton(
            iconSize: 30,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add, color: scheme.primary),
            onPressed: () async {
              final habitsProv = context.read<HabitsProvider>();
              final newHabit = await showModalBottomSheet<Habit>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const ManageHabitSheet(),
              );
              if (newHabit != null) {
                habitsProv.addHabit(newHabit);
              }
            },
          ),
        ),
      ),

      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final axis = orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal;
            return Flex(
              direction: axis,
              children: [
                Flexible(
                  flex: 7,
                  child: CalendarCard(habits: _habits),
                ),
                Flexible(
                  flex: 5,
                  child: HabitList(
                    habits: _habits,
                    onHabitDone: (habit) {
                      context.read<HabitsProvider>().logNow(habit);
                    },
                    onHabitTap: (h) async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => HabitDetailsSheet(habit: h),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}