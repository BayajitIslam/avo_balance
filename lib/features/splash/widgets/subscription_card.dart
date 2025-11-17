// widgets/subscription_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/splash/models/subscription_model.dart';
import 'package:template/widget/gradientborder_painter.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: GradientBorderPainter(
          gradient: AppColors.primaryGradient,
          strokeWidth: isSelected ? 6 : 3,
          radius: 16,
        ),

        child: Container(
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: AppColors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Content
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 6), // Bottom shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(plan.icon, style: TextStyle(fontSize: 28)),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                plan.title,
                                style: AppTextStyles.s16w5i(
                                  fontweight: FontWeight.w700,
                                ),
                              ),
                              ShaderMask(
                                blendMode:
                                    BlendMode.srcIn, // This is important!
                                shaderCallback: (bounds) => AppColors
                                    .primaryGradient
                                    .createShader(bounds),
                                child: Text(
                                  plan.displayPrice,
                                  style: AppTextStyles.s16w5i(
                                    fontweight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8.h),
                          // Description
                          Text(
                            plan.description,
                            style: AppTextStyles.s14w4i(
                              fontSize: 12,
                              fontweight: FontWeight.w500,
                              color: const Color(0XFF636363),
                            ),
                          ),

                          SizedBox(height: 2.h),
                          // Daily Cost (if available)
                          if (plan.dailyCost != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              plan.dailyCost!,
                              style: AppTextStyles.s14w4i(
                                fontweight: FontWeight.w600,
                                fontSize: 12,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Best Value Badge
              if (plan.isBestValue)
                Positioned(
                  top: -8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.secondaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      'Best Value',
                      style: AppTextStyles.s14w4i(
                        color: AppColors.white,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
