import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/splash/controllers/subscription_controller.dart';
import 'package:template/features/splash/widgets/subscription_card.dart';
import 'package:template/widget/custome_button.dart';

class SubscriptionPackageScreen extends StatelessWidget {
  SubscriptionPackageScreen({super.key});

  // Get the SubscriptionController instance
  final controller = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [
            //<---------------------- Skip to Login ----------------------->
            SizedBox(height: 68.h),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  //<---------- Navigate to Login Screen --------->
                },
                child: Text(
                  'Already have an account?',
                  style: AppTextStyles.s14w4i(),
                ),
              ),
            ),

            //<---------------------- Brand Logo ----------------------->
            Image.asset(
              "assets/icons/brandLogo.png",
              height: 100.h,
              fit: BoxFit.contain,
            ),

            //<---------------------- Title ----------------------->
            Text(
              "Start your balance journey today".toUpperCase(),
              textAlign: TextAlign.center,
              style: AppTextStyles.s30w8i(),
            ),

            //<---------------------- Description ----------------------->
            SizedBox(height: 12.h),
            Text(
              "✨ Automatic meal adjustment",
              textAlign: TextAlign.center,
              style: AppTextStyles.s30w8i(
                fontSize: 12,
                fontweight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "📊 Track your weekly progress",
              textAlign: TextAlign.center,
              style: AppTextStyles.s30w8i(
                fontSize: 12,
                fontweight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "💪 Keep your results without extra effort",
              textAlign: TextAlign.center,
              style: AppTextStyles.s30w8i(
                fontSize: 12,
                fontweight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "🥑 No calorie counting",
              textAlign: TextAlign.center,
              style: AppTextStyles.s30w8i(
                fontSize: 12,
                fontweight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "🔓 Cancel anytime, no hidden fees",
              textAlign: TextAlign.center,
              style: AppTextStyles.s30w8i(
                fontSize: 12,
                fontweight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 24.h),

            //<---------------------- Subscription Packages ----------------------->
            // Subscription Cards
            Obx(
              () => Column(
                spacing: 16,
                children: controller.plans
                    .map(
                      (plan) => SubscriptionCard(
                        plan: plan,
                        isSelected: controller.isSelected(plan.id),
                        onTap: () => controller.selectPlan(plan.id),
                      ),
                    )
                    .toList(),
              ),
            ),

            SizedBox(height: 24.h),
            //<---------------------- Subscribe Button ----------------------->
            CustomeButton(
              gradient: AppColors.primaryGradient,
              onTap: () {
                debugPrint('Click : Start Your Free Trail');
              },
              title: "Start Your 7-Day Free Trial",
            ),

            //<---------------------- Terms and Conditions ----------------------->
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16.h,
                  height: 16.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: AppColors.white, size: 12.h),
                ),
                SizedBox(width: 2.w),
                Text(
                  textAlign: TextAlign.center,
                  "You won't be charged until the end of the trial. Cancel\nanytime.",
                  style: AppTextStyles.s14w4i(
                    color: const Color(0xFF4A5565),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
