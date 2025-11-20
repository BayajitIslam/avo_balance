import 'dart:math' as math;
import 'package:flutter/material.dart';

class SemiCircularGaugePainter extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;

  SemiCircularGaugePainter({
    required this.percentage,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 5);
    final radius = 50.99;
    final strokeWidth = 22.0;

    // Background arc (inactive)
    final backgroundPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left (180 degrees)
      math.pi, // Draw 180 degrees (semicircle)
      false,
      backgroundPaint,
    );

    // Active arc (progress) with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);

    final activePaint = Paint()
      ..shader = SweepGradient(
        startAngle: math.pi,
        endAngle: math.pi + (math.pi * percentage),
        colors: [Color(0xFF00BFA5), Color(0xFF00E676)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      rect,
      math.pi, // Start from left
      math.pi * percentage, // Draw based on percentage
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
