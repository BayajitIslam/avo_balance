// screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/change_password_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custom_text_field.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/routes/routes_name.dart';
import 'package:template/widget/custome_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return MainScreen(
      child: Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Header (You already have this)
              SizedBox(height: 25.h),
              CustomeHeader(title: "Password Changes"),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),

                      // Password Form Card
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCFCFCF),
                              blurRadius: 10,
                              offset: Offset(0, 1),
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),
                            Obx(
                              () => CustomTextField(
                                label: "Enter your old password",
                                hintText: 'Old Password',
                                controller:
                                    controller.currentPasswordController,
                                obscureText:
                                    !controller.showCurrentPassword.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.showCurrentPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                  onPressed: controller.toggleCurrentPassword,
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            Obx(
                              () => CustomTextField(
                                label: "Enter New Password",
                                hintText: 'New Password',
                                controller: controller.newPasswordController,
                                obscureText: !controller.showNewPassword.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.showNewPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                  onPressed: controller.toggleNewPassword,
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            Obx(
                              () => CustomTextField(
                                label: "Re-Enter New Password",
                                hintText: 'New Password',
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.showConfirmPassword.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.showConfirmPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                  onPressed: controller.toggleConfirmPassword,
                                ),
                              ),
                            ),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () =>
                                    Get.toNamed(RoutesName.forgotPassword),
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextStyles.s14w4i(
                                    fontweight: FontWeight.w800,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(
                  () => CustomeButton(
                    gradient: AppColors.primaryGradient,
                    onTap: controller.isLoading.value
                        ? () {}
                        : controller.changePassword,
                    title: controller.isLoading.value ? "Saving..." : "Save",
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
