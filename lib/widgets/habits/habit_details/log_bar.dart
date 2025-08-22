import 'package:flutter/material.dart';
import '../../../model/habit.dart';

class LogBar extends StatelessWidget {
  final Habit habit;
  final VoidCallback addSpecific;
  final VoidCallback addNow;

  const LogBar({
    super.key,
    required this.habit,
    required this.addSpecific,
    required this.addNow,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: 50,
          color: scheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'LOG',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.primary,
                  ),
                  onPressed: addNow,
                  child: const Text('Now'),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.primary,
                  ),
                  onPressed: addSpecific,
                  child: const Text('Custom'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}