// screens/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';
import 'package:template/widget/custome_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80.h),

            // Logo with Gradient Background
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Icon(
                  Icons.lock_outline,
                  size: 40.sp,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Title
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text(
                'Reset Your Password',
                style: AppTextStyles.s22w7i(color: AppColors.brand),
              ),
            ),

            SizedBox(height: 26.h),

            // Password Field
            Obx(
              () => _buildTextField(
                controller: controller.newPasswordController,
                label: 'Password',
                hint: '••••••••',
                obscureText: !controller.isNewPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isNewPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF6C6F72),
                  ),
                  onPressed: controller.toggleNewPasswordVisibility,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Re-Type Password Field
            Obx(
              () => _buildTextField(
                controller: controller.confirmNewPasswordController,
                label: 'Re Type Password',
                hint: '••••••••',
                obscureText: !controller.isConfirmNewPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmNewPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF6C6F72),
                  ),
                  onPressed: controller.toggleConfirmNewPasswordVisibility,
                ),
              ),
            ),

            // Error Message
            SizedBox(height: 8.5.h),

            Obx(
              () => controller.errorMessageResetPassword.isNotEmpty
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: AppColors.error,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              controller.errorMessageResetPassword.value,
                              style: AppTextStyles.s14w4i(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),

            SizedBox(height: 32.h),

            // Confirm Button
            Obx(
              () => CustomeButton(
                title: controller.isLoading.value ? 'Confirming...' : 'Confirm',
                gradient: AppColors.primaryGradient,
                onTap: controller.isLoading.value
                    ? null
                    : controller.resetPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.s16w5i()),
        SizedBox(height: 8.h),
        SizedBox(
          height: 56.h,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              color: const Color(0xFFBABABA),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFFBABABA),
                fontSize: 16.sp,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: AppColors.brand, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
