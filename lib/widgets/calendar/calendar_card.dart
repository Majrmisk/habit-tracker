import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/habit.dart';
import 'day_logs/day_logs_sheet.dart';
import 'day_cell.dart';

class CalendarCard extends StatefulWidget {
  final List<Habit> habits;
  const CalendarCard({super.key, required this.habits});

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  final DateTime _focused = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TableCalendar<Color>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focused,
        shouldFillViewport: true,

        eventLoader: (day) => getColorsForDay(day),

        onDaySelected: (selectedDay, _) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => DayLogsSheet(date: selectedDay),
          );
        },

        calendarBuilders: CalendarBuilders(
          defaultBuilder:  getCell,
          todayBuilder:    getCell,
          selectedBuilder: getCell,

          // Remove event dots
          markerBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),

        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarStyle: const CalendarStyle(outsideDaysVisible: false),
      ),
    );
  }

  List<Color> getColorsForDay(DateTime day) {
    final k = roundDay(day);
    return widget.habits
        .where((h) => h.datesDone
        .any((d) => roundDay(d) == k))
        .map((h) => h.color)
        .toList();
  }

  DateTime roundDay(DateTime d) => DateTime(d.year, d.month, d.day);

  Widget getCell(BuildContext ctx, DateTime day, DateTime _) =>
      DayCell(date: day, colors: getColorsForDay(day));
}
