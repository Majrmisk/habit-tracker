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
            child: Text(
              habit.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: contrastTextColor(habit.color),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: contrastTextColor(habit.color)),
            constraints: const BoxConstraints(minWidth: 55, minHeight: 55),
            onPressed: openEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: contrastTextColor(habit.color)),
            constraints: const BoxConstraints(minWidth: 55, minHeight: 55),
            onPressed: openDelete,
          ),
        ],
      ),
    );
  }
}