// Create new file: widgets/multi_segment_circular_progress.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class MultiSegmentCircularProgress extends StatelessWidget {
  final double size;
  final int totalCalories;
  final List<MealSegment> segments;

  const MultiSegmentCircularProgress({
    super.key,
    required this.size,
    required this.totalCalories,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size.w, size.w),
            painter: MultiSegmentProgressPainter(
              segments: segments,
              strokeWidth: 8.w,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: segments.isNotEmpty
                      ? [segments.first.color, segments.last.color]
                      : [Color(0xFFE91E63), Color(0xFF9C27B0)],
                ).createShader(bounds),
                child: Text(
                  '$totalCalories',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'kcal',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MealSegment {
  final Color color;
  final double percentage;

  MealSegment({required this.color, required this.percentage});
}

class MultiSegmentProgressPainter extends CustomPainter {
  final List<MealSegment> segments;
  final double strokeWidth;

  MultiSegmentProgressPainter({
    required this.segments,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Color(0xFFF5F5F5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (segments.isEmpty) return;

    double startAngle = -math.pi / 2;

    for (var segment in segments) {
      if (segment.percentage <= 0) continue;

      final sweepAngle = 2 * math.pi * segment.percentage;

      final segmentPaint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
