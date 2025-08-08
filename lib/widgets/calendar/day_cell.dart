import 'package:flutter/material.dart';
import 'ring_painter.dart';

class DayCell extends StatelessWidget {
  final DateTime date;
  final List<Color> colors;
  const DayCell({super.key, required this.date, required this.colors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final side = constraints.biggest.shortestSide - 2;
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size.square(side),
              painter: RingPainter(colors),
            ),
            Text(
              '${date.day}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
