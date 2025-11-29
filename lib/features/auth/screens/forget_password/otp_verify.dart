// screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/otp_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custom_text_field.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/routes/routes_name.dart';
import 'package:template/widget/custome_button.dart';

class OtpVerify extends StatelessWidget {
  OtpVerify({super.key});

  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OTPController(
        verificationType: "forgot_password",
        email: "email@gmail.com",
      ),
    );

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

                            CustomTextField(
                              label: "Enter the OTP code",
                              hintText: 'OTP',
                              controller: otpController,
                            ),
                            //  // Resend Text with Timer
                            SizedBox(height: 20),
                            Obx(
                              () => RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  style: AppTextStyles.s14w4i(
                                    color: AppColors.black,
                                    fontweight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          'We sent a verification code to your email. Please check. If not, resend in ',
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
                                                : AppColors.black.withOpacity(
                                                    0.3,
                                                  ),
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
                    onTap: () => Get.toNamed(RoutesName.passwordSaved),
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
