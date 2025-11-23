// widgets/replace_meal_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/replace_meal_bottom_sheet.dart';

class LogCheatMealBottomSheet extends StatelessWidget {
  const LogCheatMealBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppColors.secondaryGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Log Cheat Meal',
                        style: AppTextStyles.s22w7i(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 24.sp,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                Text(
                  'Choose how to log this meal',
                  style: AppTextStyles.s14w4i(fontSize: 13.sp),
                ),

                SizedBox(height: 59.h),
                // Bottom Buttons
                Row(
                  children: [
                    // Log Meal Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: Get.context!,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => ReplaceMealBottomSheet(
                              initialMealType: "Breakfast",
                            ),
                          );
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                            gradient: AppColors.secondaryGradient,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset("assets/icons/ix_replace.png"),
                                Text(
                                  'Replace Meal',
                                  style: AppTextStyles.s14w4i(
                                    color: Colors.white,
                                    fontweight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // RePLACE Button
                    SizedBox(width: 12.w),

                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFFB2C36),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.add, color: const Color(0xFFFB2C36)),
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) =>
                                      AppColors.secondaryGradient.createShader(
                                        Rect.fromLTWH(
                                          0,
                                          0,
                                          bounds.width,
                                          bounds.height,
                                        ),
                                      ),
                                  child: Text(
                                    'Add as Extra',
                                    style: AppTextStyles.s14w4i(
                                      color: Colors.black87,
                                      fontweight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
