// screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/otp_controller.dart';
import 'package:template/widget/custome_button.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String verificationType; // 'signup' or 'forgot_password'
  final String? email;

  const OTPVerificationScreen({
    super.key,
    required this.verificationType,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OTPController(verificationType: verificationType, email: email),
    );

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
          children: [
            SizedBox(height: 80.h),

            // Logo
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/logo.png"),
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),

            SizedBox(height: 26.h),

            // Title
            Row(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'Enter Your OTP',
                    style: AppTextStyles.s22w7i(color: AppColors.brand),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // "Enter Code" Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter Code',
                style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
              ),
            ),

            SizedBox(height: 12.h),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => _buildOTPBox(controller, index),
              ),
            ),

            // Error Message
            SizedBox(height: 8.5.h),

            Obx(
              () => controller.errorMessage.isNotEmpty
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
                              controller.errorMessage.value,
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

            SizedBox(height: 28.h),

            // Submit Button
            Obx(
              () => CustomeButton(
                title: controller.isLoading.value ? 'Verifying...' : 'Submit',
                gradient: AppColors.primaryGradient,
                onTap: controller.isLoading.value ? null : controller.verifyOTP,
              ),
            ),

            SizedBox(height: 24.h),

            // Resend Text with Timer
            Obx(
              () => RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.s14w4i(
                    color: AppColors.black,
                    fontweight: FontWeight.w800,
                    fontSize: 12.sp,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'We sent a verification code to your email. Please check.\nIf not, resend in ',
                    ),
                    TextSpan(
                      text: controller.formatTime(
                        controller.remainingTime.value,
                      ),
                      style: AppTextStyles.s14w4i(
                        fontSize: 12.sp,
                        fontweight: FontWeight.w800,
                        color: AppColors.brand,
                      ),
                    ),
                    TextSpan(text: ' minutes. '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: controller.canResend.value
                            ? controller.resendOTP
                            : null,
                        child: Text(
                          'Resend',
                          style: AppTextStyles.s14w4i(
                            fontSize: 12.sp,
                            fontweight: FontWeight.w700,
                            color: controller.canResend.value
                                ? AppColors.brand
                                : AppColors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPBox(OTPController controller, int index) {
    return Container(
      width: 56.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 4) {
              controller.focusNodes[index + 1].requestFocus();
            } else {
              FocusScope.of(Get.context!).unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
