// widgets/multi_segment_circular_progress.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'dart:math' as math;

import 'package:template/core/themes/app_text_style.dart';

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
              strokeWidth: 14.w,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF9810FA),
                    Color(0xFFE60076),
                    Color(0xFFFF6900),
                  ],
                ).createShader(bounds),
                child: Text(
                  '$totalCalories',
                  style: AppTextStyles.s22w7i(color: AppColors.white),
                ),
              ),
              Text(
                'kcal',
                style: AppTextStyles.s14w4i(
                  fontSize: 12.sp,
                  fontweight: FontWeight.w700,
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
      ..color = const Color(0xFFF5F5F5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (segments.isEmpty) return;

    double startAngle = -math.pi / 2;
    final gapAngle = 0.33; // Gap between segments

    for (var segment in segments) {
      if (segment.percentage <= 0) continue;

      final sweepAngle = (2 * math.pi * segment.percentage) - gapAngle;

      // Shadow for 3D effect
      final shadowPaint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + 1),
        startAngle,
        sweepAngle,
        false,
        shadowPaint,
      );

      // Main segment
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

      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
