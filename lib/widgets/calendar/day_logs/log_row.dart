import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/HabitsProvider.dart';
import '../../../utils/utils.dart';
import 'log_info.dart';

class LogRow extends StatelessWidget {
  final LogInfo log;
  const LogRow({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            TimeOfDay.fromDateTime(log.time).format(context),
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: log.habit.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              log.habit.name,
              style: TextStyle(
                color: contrastTextColor(log.habit.color),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const Spacer(),

          IconButton(
            icon: Icon(Icons.delete,
                color: scheme.onSurfaceVariant),
            onPressed: () {
              context
                  .read<HabitsProvider>()
                  .removeLog(log.habit, log.time);
            },
          ),
        ],
      ),
    );
  }
}
