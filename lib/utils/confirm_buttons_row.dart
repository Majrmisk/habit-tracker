import 'package:flutter/material.dart';

class ButtonsRow extends StatelessWidget {
  final String confirmText;
  final VoidCallback onConfirm;
  const ButtonsRow({
    super.key,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: scheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ),
        ),
      ],
    );
  }
}
