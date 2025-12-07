// widgets/bottom_shet/manage_your_plan.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/diet_controller.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/screens/diet/diet_screen.dart';

class UploadPlan extends StatelessWidget {
  UploadPlan({super.key});

  final controller = Get.find<DietController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.black54),
                ),
              ),

              // Title
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)],
                ).createShader(bounds),
                child: Text(
                  'Manage Your Plan',
                  style: AppTextStyles.s22w7i(
                    color: Colors.yellow,
                    fontSize: 22.sp,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Subtitle
              Text(
                'Continue your current plan or schedule your next one.',
                style: AppTextStyles.s14w4i(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 20.h),

              // Upload Plan
              _uploadBox(context),

              SizedBox(height: 24.h),

              // Bottom Buttons
              _buildBottomButtons(context),

              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }

  // Upload Plan Box
  Widget _uploadBox(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _handleUploadDiet();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
            // Plan Name
            Text("Upload Your Meal Plan", style: AppTextStyles.s22w7i()),
            SizedBox(height: 20.h),

            // Current Plan Date Range with Calendar Icon
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //icon
                  CircleAvatar(
                    radius: 44.r,
                    backgroundColor: Color(0xffECFDF5),
                    child: SvgPicture.asset("assets/icons/upload.svg"),
                  ),
                  //text
                  SizedBox(height: 20),
                  Text(
                    "Upload your meal plan (PDF, photo or screenshot accepted) ",
                    style: AppTextStyles.s16w5i(
                      fontSize: 12,
                      color: AppColors.ash,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Buttons
  Widget _buildBottomButtons(BuildContext context) {
    return Row(
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
                border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
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

        // Save Button
        Expanded(
          child: InkWell(
            onTap: () => controller.savePlanChanges(),
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
    );
  }

  // Handle Upload Diet - Open Camera
  void _handleUploadDiet() async {
    // Open camera and wait for result
    final result = await Get.to(
      () => CameraCaptureScreen(mealType: 'Diet Plan'),
      transition: Transition.downToUp,
    );

    // After camera closed (back or captured photo)
    if (result != null && result is File) {
      // Show loading dialog
      _showLoadingDialog();

      try {
        // Photo captured - upload
        await controller.uploadPrescription(result, 'Diet Plan');

        // Close loading dialog
        Get.back();

        // Navigate to Diet Screen
        Get.offAll(() => DietScreen());
      } catch (e) {
        // Close loading dialog
        Get.back();

        // Show error
        Get.snackbar(
          'Error',
          'Failed to upload: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // User pressed back without capturing
      // Navigate to Diet Screen
      Get.off(() => DietScreen());
    }
  }

  // Show Loading Dialog
  void _showLoadingDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button
        child: Center(
          child: Container(
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Gradient Loader
                SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Uploading...',
                  style: AppTextStyles.s16w5i(fontweight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please wait while we process your diet plan',
                  style: AppTextStyles.s14w4i(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
