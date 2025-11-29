// screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/features/main_screen/controllers/change_password_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custom_text_field.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/routes/routes_name.dart';
import 'package:template/widget/custome_button.dart';

class EmailVerify extends StatelessWidget {
  const EmailVerify({super.key});

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
                                label: "Your Email",
                                hintText: 'Enter Your Email',
                                controller: controller.newPasswordController,
                                obscureText: !controller.showNewPassword.value,
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
                    onTap: () => Get.toNamed(RoutesName.otpVerify),
                    title: controller.isLoading.value
                        ? "Sending..."
                        : "Send Code",
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
