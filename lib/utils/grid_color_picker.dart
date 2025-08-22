import 'package:flutter/material.dart';

import 'utils.dart';

class GridColorPicker extends StatelessWidget {
  final List<Color> palette;
  final Color picked;
  final ValueChanged<Color> onPick;
  const GridColorPicker({
    super.key,
    required this.palette,
    required this.picked,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: palette.map((color) {
            final selected = color == picked;
            return GestureDetector(
              onTap: () => onPick(color),
              child: Container(
                width: (constraints.maxWidth - gap * 4) / 5,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                selected
                  ? Icon(
                      Icons.check,
                      color: contrastTextColor(color),
                      size: 30,
                    )
                  : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}