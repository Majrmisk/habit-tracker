import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/confirm_buttons_row.dart';
import 'package:provider/provider.dart';

import '../../../model/habit.dart';
import '../../../provider/habits_provider.dart';
import '../../../utils/utils.dart';
import '../../../utils/grid_color_picker.dart';

class ManageHabitSheet extends StatefulWidget {
  final Habit? habit;
  const ManageHabitSheet({super.key, this.habit});

  @override
  State<ManageHabitSheet> createState() => _ManageHabitSheetState();
}

class _ManageHabitSheetState extends State<ManageHabitSheet> {
  late TextEditingController _controller;
  late Color _picked;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.habit?.name ?? '');
    _picked = widget.habit?.color ?? Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: scheme.surfaceContainerHighest,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Habit name',
                filled: true,
                fillColor: scheme.surfaceContainerLow,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            GridColorPicker(
              palette: habitsPalette,
              picked: _picked,
              onPick: (color) => setState(() => _picked = color),
            ),

            const SizedBox(height: 16),

            ButtonsRow(
              confirmText: widget.habit == null ? 'Add' : 'Save',
              onConfirm: _onConfirm,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final provider = context.read<HabitsProvider>();

    if (widget.habit == null) {
      await provider.addHabit(Habit(name: name, color: _picked));
    } else {
      widget.habit!
        ..name = name
        ..colorInt = _picked.toARGB32();
      await provider.updateHabit(widget.habit!);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }
}
