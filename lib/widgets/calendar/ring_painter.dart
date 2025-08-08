import 'package:flutter/material.dart';

class RingPainter extends CustomPainter {
  static const innerRadius = 12;

  final List<Color> colors;
  RingPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    final thickness   = (size.width / 2 - innerRadius) / colors.length;

    for (var i = 0; i < colors.length; i++) {
      final radius = innerRadius + thickness * (i + 0.5);
      canvas.drawCircle(
        size.center(Offset.zero),
        radius,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness * 0.9,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RingPainter old) => old.colors != colors;
}
