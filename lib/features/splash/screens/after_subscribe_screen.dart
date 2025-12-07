import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/diet_controller.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/screens/diet/diet_screen.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/routes/routes_name.dart';

class AfterSubscribeScreen extends StatelessWidget {
  AfterSubscribeScreen({super.key});

  final controller = Get.find<DietController>();

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      showBottomNav: false,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    //Title
                    Text(
                      "Upload Your First Meal Plan",
                      style: AppTextStyles.s18w5i(fontSize: 20),
                    ),

                    //Sub Title
                    SizedBox(height: 12),
                    Text(
                      "This is where your personalized experience begins",
                      style: AppTextStyles.s14w4i(
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Upload button
              SizedBox(height: 26.h),
              Expanded(
                child: InkWell(
                  onTap: () => _handleUploadDiet(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
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
                ),
              ),

              // I'll do it later
              SizedBox(height: 34.h),
              InkWell(
                onTap: () {
                  final navController = Get.find<NavigationController>();
                  navController.currentIndex(0);
                  Get.offAllNamed(RoutesName.home);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.brand),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      " I'll do it later",
                      style: AppTextStyles.s22w7i(
                        fontSize: 16,
                        color: AppColors.brand,
                      ),
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
