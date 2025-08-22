import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../provider/habits_provider.dart';
import 'day_logs/day_logs_sheet.dart';
import 'day_cell.dart';

class CalendarCard extends StatefulWidget {
  const CalendarCard({super.key});

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  final DateTime _focused = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final habitsProv = context.watch<HabitsProvider>();
    List<Color> colorsForDay(day) => habitsProv.colorsForDay(day);
    Widget cell(_, day, __) => DayCell(date: day, colors: colorsForDay(day));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TableCalendar<Color>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focused,
        shouldFillViewport: true,

        eventLoader: colorsForDay,

        onDaySelected: (selectedDay, _) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => DayLogsSheet(date: selectedDay),
          );
        },

        calendarBuilders: CalendarBuilders(
          defaultBuilder:  cell,
          todayBuilder:    cell,
          selectedBuilder: cell,

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
}
