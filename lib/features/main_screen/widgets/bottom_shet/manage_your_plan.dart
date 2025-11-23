// widgets/manage_your_plan_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';

class ManageYourPlan extends StatelessWidget {
  const ManageYourPlan({super.key});

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
                          LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)],
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Manage Your Plan',
                        style: AppTextStyles.s22w7i(
                          color: Colors.white,
                          fontSize: 22.sp,
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

                // Subtitle
                Text(
                  'Continue your current plan or schedule your next one.',
                  style: AppTextStyles.s14w4i(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 24.h),

                // Meal Plan 1 (Current Plan)
                _buildPlanCard(
                  context: context,
                  title: 'Meal Plan 1',
                  badge: '(Current Plan)',
                  subtitle: 'Current plan ends on Nov 30, 2025.',
                  buttonText: 'Continue Plan',
                  onTap: () {
                    // Just close bottom sheet
                    Navigator.pop(context);

                    Get.snackbar(
                      'Success',
                      'Continuing with current plan',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // Schedule Next Plan (Upload)
                _buildPlanCard(
                  context: context,
                  title: 'Schedule next plan',
                  subtitle: 'Upload a new plan to start later.',
                  buttonText: 'Upload New Plan',
                  onTap: () {
                    // Close bottom sheet and navigate to camera
                    Navigator.pop(context);

                    // Navigate to camera screen
                    Get.to(
                      () => CameraCaptureScreen(mealType: 'Plan Upload'),
                      transition: Transition.downToUp,
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // Replace Current Plan
                _buildPlanCard(
                  context: context,
                  title: 'Replace current plan',
                  subtitle: 'Instantly replace with new plan.',
                  buttonText: 'Replace Plan Now',
                  onTap: () {
                    // Close bottom sheet and navigate to replace screen
                    Navigator.pop(context);

                    // Navigate to replace plan screen
                    // TODO: Replace with your actual screen
                    Get.toNamed('/replace-plan');

                    // Or use Get.to():
                    // Get.to(() => ReplacePlanScreen());
                  },
                ),

                SizedBox(height: 24.h),
                // Bottom Buttons
                Row(
                  children: [
                    // Back Button
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
                            child: Text(
                              'Back',
                              style: AppTextStyles.s14w4i(
                                color: Colors.black87,
                                fontweight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Log Meal Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, {});
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
                            child: Text(
                              'Save changes',
                              style: AppTextStyles.s14w4i(
                                color: Colors.white,
                                fontweight: FontWeight.w700,
                              ),
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

  // Plan Card Widget
  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    String? badge,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.3), blurRadius: 2),
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Badge
          Row(
            children: [
              Text(
                title,
                style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
              ),
              if (badge != null) ...[
                SizedBox(width: 6.w),
                Text(badge, style: AppTextStyles.s14w4i(fontSize: 15.sp)),
              ],
            ],
          ),

          SizedBox(height: 6.h),

          // Subtitle
          Text(subtitle, style: AppTextStyles.s14w4i()),

          SizedBox(height: 12.h),

          // Button
          InkWell(
            onTap: onTap,
            child: Container(
              height: 37.h,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.25),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: AppTextStyles.s14w4i(
                    color: Colors.white,
                    fontweight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
