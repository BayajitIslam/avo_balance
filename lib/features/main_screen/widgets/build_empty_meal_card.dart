import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class BuildEmptyMealCard extends StatelessWidget {
  final String mealType;
  final VoidCallback onTap;
  final List<Color> borderGradient;
  const BuildEmptyMealCard({
    super.key,
    required this.borderGradient,
    required this.onTap,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 124.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 8),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Left gradient border
            Positioned(
              left: -24.w,
              top: 14,
              bottom: 14,
              child: Container(
                width: 4.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: borderGradient,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(33554400),
                    bottomRight: Radius.circular(33554400),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    mealType,
                    style: AppTextStyles.s22w7i(
                      fontweight: FontWeight.w900,
                      fontSize: 20.sp,
                    ),
                  ),

                  // Add button with text
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: AppColors.container,
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: const Color(0xFFAD46FF).withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: -4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          'Upload Your Free Meal',
                          style: AppTextStyles.s16w5i(
                            color: const Color(0xFFB9B9B9),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
