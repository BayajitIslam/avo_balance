// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/splash/controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // PageView (NO SWIPING)
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (context, index) {
                return _buildPageContent(controller.pages[index]);
              },
            ),
          ),

          // Smooth Page Indicator
          SmoothPageIndicator(
            controller: controller.pageController,
            count: controller.pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.primaryGradient.colors.first,
              dotColor: AppColors.textGray,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
              spacing: 8,
            ),
          ),

          // Continue Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Obx(
              () => Container(
                width: double.infinity,
                height: 45.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    controller.currentPage.value == controller.pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(OnboardingData page) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 68.h),
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                // Call skip onboarding
              },
              child: Text(
                'Already have a account?',
                style: AppTextStyles.s14w4i(),
              ),
            ),
          ),

          SizedBox(height: 30.h),
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.s30w8i(),
          ),

          SizedBox(height: 51.h),
          // Image
          Image.asset(page.imagePath, height: 361.h, fit: BoxFit.contain),

          Spacer(),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.s16w5i(),
          ),

          // Additional Description
          page.description2.isEmpty
              ? SizedBox.shrink()
              : SizedBox(height: 16.h),
          Text(
            page.description2.isEmpty ? '' : page.description2,
            textAlign: TextAlign.center,
            style: AppTextStyles.s14w4i(
              fontSize: 12,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}
