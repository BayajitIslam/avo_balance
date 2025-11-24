// screens/signin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';
import 'package:template/routes/routes_name.dart';
import 'package:template/widget/custome_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
            SizedBox(height: 70.h),

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
            Row(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn, // This is important!
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'Sign in',
                    style: AppTextStyles.s22w7i(color: AppColors.brand),
                  ),
                ),
              ],
            ),

            SizedBox(height: 26.h),

            // Email Field
            _buildTextField(
              controller: controller.loginEmailController,
              label: 'Email Addess',
              icon: Icons.email_outlined,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 16.h),

            // Password Field
            Obx(
              () => _buildTextField(
                controller: controller.loginPasswordController,
                label: 'Password',
                forgotPasswordButton: true,
                icon: Icons.lock_outline,
                hint: 'Enter your password',
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  color: const Color(0xFF6C6F72),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),

            SizedBox(height: 8.5.h),

            // ERROR MESSAGE
            Obx(
              () => controller.errorMessageSignIn.isNotEmpty
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          //ICON
                          Icon(
                            Icons.warning,
                            color: AppColors.error,
                            size: 16.sp,
                          ),

                          //ERROR
                          SizedBox(width: 4.w),
                          Text(
                            controller.errorMessageSignIn.value,
                            style: AppTextStyles.s14w4i(
                              fontSize: 12.sp,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),

            SizedBox(height: 16.h),

            // Sign In Button
            Obx(
              () => CustomeButton(
                title: controller.isLoading.value ? 'Signing In...' : 'Sign In',
                gradient: AppColors.primaryGradient,
                onTap: controller.isLoading.value ? null : controller.signIn,
              ),
            ),

            SizedBox(height: 24.h),

            // Don't have account
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: AppTextStyles.s14w4i(
                    fontweight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(RoutesName.signup),
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.s14w4i(
                      fontweight: FontWeight.w800,
                      color: AppColors.brand,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 51.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool forgotPasswordButton = false,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.s16w5i()),

            // Forgot Password
            forgotPasswordButton
                ? InkWell(
                    onTap: () {
                      //ROUTE TO FORGOT PASSWORD SCREEN
                      Get.toNamed(RoutesName.forgotPassword);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.s16w5i(
                        fontSize: 14,
                        color: const Color(0xFF1443C3),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
             height: 56.h,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
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
                borderSide: BorderSide.none,
              ),
              // Border when not focused (enabled state)
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(
                  color: AppColors.border, // Border color when not focused
                  width: 1,
                ),
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
