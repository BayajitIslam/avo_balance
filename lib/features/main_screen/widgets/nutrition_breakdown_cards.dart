// widgets/nutrition_breakdown_cards.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/widgets/multi_segment_circular_progress.dart';

class NutritionBreakdownCards extends StatelessWidget {
  final List<NutritionSegment> segments;
  final int? selectedIndex;

  const NutritionBreakdownCards({
    super.key,
    required this.segments,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null || selectedIndex! >= segments.length) {
      return SizedBox.shrink();
    }

    final segment = segments[selectedIndex!];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        // Clamp opacity to ensure it's between 0.0 and 1.0
        final clampedOpacity = value.clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(-(1 - value) * 50.w, 0),
          child: Opacity(
            opacity: clampedOpacity, // Fixed: clamped opacity
            child: child,
          ),
        );
      },
      child: Stack(
        children: [
          // Arrow background
          CustomPaint(
            painter: ArrowBadgePainter(color: segment.color, isSelected: true),
            child: Container(
              height: 40.h,
              padding: EdgeInsets.only(left: 24.w, right: 16.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(segment.percentage * 100).toInt()}% ${segment.name}',
                    style: AppTextStyles.s14w4i(
                      color: Colors.white,
                      fontweight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Glow effect - with safe opacity
          Positioned.fill(
            child: CustomPaint(
              painter: ArrowBadgePainter(
                color: segment.color.withOpacity(0.3.clamp(0.0, 1.0)), // Fixed
                isSelected: true,
                isGlow: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Arrow Badge Painter (LEFT ARROW pointing RIGHT)
class ArrowBadgePainter extends CustomPainter {
  final Color color;
  final bool isSelected;
  final bool isGlow;

  ArrowBadgePainter({
    required this.color,
    required this.isSelected,
    this.isGlow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (isGlow) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
    }

    final path = Path();

    final arrowWidth = 12.w;
    final cornerRadius = 8.r;

    // Start from arrow point (LEFT SIDE)
    path.moveTo(arrowWidth, size.height / 2 - 6.h);

    // Arrow point
    path.lineTo(0, size.height / 2);
    path.lineTo(arrowWidth, size.height / 2 + 6.h);

    // Left edge from arrow
    path.lineTo(arrowWidth, size.height - cornerRadius);

    // Bottom-left rounded corner
    path.arcToPoint(
      Offset(arrowWidth + cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
    );

    // Bottom edge
    path.lineTo(size.width - cornerRadius, size.height);

    // Bottom-right rounded corner
    path.arcToPoint(
      Offset(size.width, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Right edge
    path.lineTo(size.width, cornerRadius);

    // Top-right rounded corner
    path.arcToPoint(
      Offset(size.width - cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    // Top edge
    path.lineTo(arrowWidth + cornerRadius, 0);

    // Top-left rounded corner
    path.arcToPoint(
      Offset(arrowWidth, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    path.close();

    canvas.drawPath(path, paint);

    // Add shadow
    if (!isGlow && isSelected) {
      final shadowPaint = Paint()
        ..color = Colors.black
            .withOpacity(0.2.clamp(0.0, 1.0)) // Fixed
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawPath(path, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
