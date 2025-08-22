import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/habits_provider.dart';
import 'log_habit/add_day_log_sheet.dart';
import 'log_info.dart';
import 'log_row.dart';

class DayLogsSheet extends StatefulWidget {
  final DateTime date;
  const DayLogsSheet({super.key, required this.date});

  @override
  State<DayLogsSheet> createState() => _DayLogsSheetState();
}

class _DayLogsSheetState extends State<DayLogsSheet> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final provider = context.watch<HabitsProvider>();

    final logs = [];
    for (final habit in provider.habits) {
      for (final date in habit.datesDone) {
        if (date.year == widget.date.year &&
            date.month == widget.date.month &&
            date.day == widget.date.day) {
          logs.add(LogInfo(habit: habit, time: date));
        }
      }
    }
    logs.sort((a, b) => a.time.compareTo(b.time));

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: scheme.primaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    MaterialLocalizations.of(context)
                        .formatMediumDate(widget.date),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: logs.isEmpty
                  ? Center(
                      child: Text(
                        'No logs for this day',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    )
                  : ListView.separated(
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) => LogRow(log: logs[i]),
                    ),
              ),

              SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  color: scheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.add, color: scheme.primary),
                      onPressed: _pickHabit,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Future<void> _pickHabit() async {
    final habitsProv = context.read<HabitsProvider>();
    if (habitsProv.habits.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('No habits to log'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddDayLogSheet(date: widget.date),
    );
  }
}
