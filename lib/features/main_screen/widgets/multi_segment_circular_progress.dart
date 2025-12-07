// // widgets/multi_segment_circular_progress.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:template/core/constants/app_colors.dart';
// import 'dart:math' as math;

// import 'package:template/core/themes/app_text_style.dart';

// class MultiSegmentCircularProgress extends StatelessWidget {
//   final double size;
//   final int totalCalories;
//   final List<MealSegment> segments;

//   const MultiSegmentCircularProgress({
//     super.key,
//     required this.size,
//     required this.totalCalories,
//     required this.segments,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: size.w,
//       height: size.w,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CustomPaint(
//             size: Size(size.w, size.w),
//             painter: MultiSegmentProgressPainter(
//               segments: segments,
//               strokeWidth: 14.w,
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ShaderMask(
//                 shaderCallback: (bounds) => LinearGradient(
//                   colors: [
//                     Color(0xFF9810FA),
//                     Color(0xFFE60076),
//                     Color(0xFFFF6900),
//                   ],
//                 ).createShader(bounds),
//                 child: Text(
//                   '$totalCalories',
//                   style: AppTextStyles.s22w7i(color: AppColors.white),
//                 ),
//               ),
//               Text(
//                 'kcal',
//                 style: AppTextStyles.s14w4i(
//                   fontSize: 12.sp,
//                   fontweight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MealSegment {
//   final Color color;
//   final double percentage;

//   MealSegment({required this.color, required this.percentage});
// }

// class MultiSegmentProgressPainter extends CustomPainter {
//   final List<MealSegment> segments;
//   final double strokeWidth;

//   MultiSegmentProgressPainter({
//     required this.segments,
//     required this.strokeWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;

//     final backgroundPaint = Paint()
//       ..color = const Color(0xFFF5F5F5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.butt;

//     canvas.drawCircle(center, radius, backgroundPaint);

//     if (segments.isEmpty) return;

//     double startAngle = -math.pi / 2;
//     final gapAngle = 0.33; // Gap between segments

//     for (var segment in segments) {
//       if (segment.percentage <= 0) continue;

//       final sweepAngle = (2 * math.pi * segment.percentage) - gapAngle;

//       // Shadow for 3D effect
//       final shadowPaint = Paint()
//         ..color = segment.color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = strokeWidth
//         ..strokeCap = StrokeCap.butt
//         ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

//       canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius + 1),
//         startAngle,
//         sweepAngle,
//         false,
//         shadowPaint,
//       );

//       // Main segment
//       final segmentPaint = Paint()
//         ..color = segment.color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = strokeWidth
//         ..strokeCap = StrokeCap.round;

//       canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius),
//         startAngle,
//         sweepAngle,
//         false,
//         segmentPaint,
//       );

//       startAngle += sweepAngle + gapAngle;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// widgets/multi_segment_circular_progress.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'dart:math' as math;
import 'package:template/core/themes/app_text_style.dart';

class MultiSegmentCircularProgress extends StatelessWidget {
  final double size;
  final int totalCalories;
  final List<NutritionSegment> segments;
  final Function(int? index)? onSegmentChange;
  final int? selectedIndex;

  const MultiSegmentCircularProgress({
    super.key,
    required this.size,
    required this.totalCalories,
    required this.segments,
    this.onSegmentChange,
    this.selectedIndex,
  });

  int? _detectSegment(Offset localPosition) {
    final center = Offset(size.w / 2, size.w / 2);

    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    final radius = (size.w - 14.w) / 2;
    if (distance >= radius - 14.w && distance <= radius + 14.w) {
      var angle = math.atan2(dy, dx);
      angle = angle + math.pi / 2;
      if (angle < 0) angle += 2 * math.pi;

      double startAngle = 0;
      final gapAngle = 0.33;

      for (int i = 0; i < segments.length; i++) {
        final segment = segments[i];
        final sweepAngle = (2 * math.pi * segment.percentage) - gapAngle;

        if (angle >= startAngle && angle <= startAngle + sweepAngle) {
          return i;
        }

        startAngle += sweepAngle + gapAngle;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final segmentIndex = _detectSegment(localPosition);

        if (segmentIndex != null) {
          onSegmentChange?.call(segmentIndex);
        }
      },
      onTapUp: (details) {
        onSegmentChange?.call(null);
      },
      onTapCancel: () {
        onSegmentChange?.call(null);
      },
      child: SizedBox(
        width: size.w,
        height: size.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Circular Progress
            CustomPaint(
              size: Size(size.w, size.w),
              painter: MultiSegmentProgressPainter(
                segments: segments,
                strokeWidth: 14.w,
                selectedIndex: selectedIndex,
              ),
            ),

            // Center Text
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

            // Nutrition Card - ALWAYS ON LEFT SIDE
            if (selectedIndex != null && selectedIndex! < segments.length)
              Positioned(
                right: size.w + 10.w, // Position to LEFT of circle
                top: size.w / 2 - 20.h, // Center vertically
                child: _buildNutritionCard(segments[selectedIndex!]),
              ),
          ],
        ),
      ),
    );
  }

  // Build nutrition card with arrow on RIGHT side
  Widget _buildNutritionCard(NutritionSegment segment) {
    return CustomPaint(
      painter: ArrowBadgePainter(color: segment.color),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 28.w,
        ), // Extra padding for arrow
        child: Center(
          child: Text(
            '${(segment.percentage * 100).toInt()}% ${segment.name}',
            style: AppTextStyles.s14w4i(
              color: Colors.white,
              fontweight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}

// Arrow Badge Painter - Arrow on RIGHT pointing to circle
class ArrowBadgePainter extends CustomPainter {
  final Color color;

  ArrowBadgePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final arrowWidth = 12.w;
    final cornerRadius = 8.r;

    // Start from top-left
    path.moveTo(cornerRadius, 0);

    // Top edge to arrow start (RIGHT SIDE)
    path.lineTo(size.width - arrowWidth - cornerRadius, 0);

    // Top-right corner before arrow
    path.arcToPoint(
      Offset(size.width - arrowWidth, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Right edge to arrow point
    path.lineTo(size.width - arrowWidth, size.height / 2 - 8.h);

    // Arrow pointing RIGHT
    path.lineTo(size.width, size.height / 2); // Arrow tip
    path.lineTo(size.width - arrowWidth, size.height / 2 + 8.h);

    // Right edge from arrow
    path.lineTo(size.width - arrowWidth, size.height - cornerRadius);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - arrowWidth - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
    );

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Left edge
    path.lineTo(0, cornerRadius);

    // Top-left corner
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    path.close();

    // Draw shadow first
    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 4, true);

    // Draw main shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NutritionSegment {
  final String name;
  final Color color;
  final double percentage;
  final int grams;

  NutritionSegment({
    required this.name,
    required this.color,
    required this.percentage,
    required this.grams,
  });
}

class MultiSegmentProgressPainter extends CustomPainter {
  final List<NutritionSegment> segments;
  final double strokeWidth;
  final int? selectedIndex;

  MultiSegmentProgressPainter({
    required this.segments,
    required this.strokeWidth,
    this.selectedIndex,
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
    final gapAngle = 0.33;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      if (segment.percentage <= 0) continue;

      final sweepAngle = (2 * math.pi * segment.percentage) - gapAngle;
      final isSelected = selectedIndex == i;

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

      final segmentPaint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 2 : strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: isSelected ? radius + 1 : radius,
        ),
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
