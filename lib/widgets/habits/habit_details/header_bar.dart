import 'package:flutter/material.dart';

import '../../../model/habit.dart';
import '../../../utils/utils.dart';

class HeaderBar extends StatelessWidget {
  final Habit habit;
  final VoidCallback openEdit;
  final VoidCallback openDelete;

  const HeaderBar({
    super.key,
    required this.habit,
    required this.openEdit,
    required this.openDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = contrastTextColor(habit.color);
    final intervalLabel = habit.isRoutine ? formatInterval(habit) : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: habit.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  habit.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (intervalLabel != null && intervalLabel.isNotEmpty)
                  Text(
                    intervalLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withAlpha(200),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            constraints: const BoxConstraints(minWidth: 55, minHeight: 55),
            onPressed: openEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: textColor),
            constraints: const BoxConstraints(minWidth: 55, minHeight: 55),
            onPressed: openDelete,
          ),
        ],
      ),
    );
  }
}
