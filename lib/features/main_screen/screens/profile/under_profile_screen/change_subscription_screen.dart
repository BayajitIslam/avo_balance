// screens/change_subscription_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/features/splash/controllers/subscription_controller.dart';
import 'package:template/features/splash/widgets/subscription_card.dart';
import 'package:template/widget/custome_button.dart';

class ChangeSubscriptionScreen extends StatelessWidget {
  const ChangeSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());

    return MainScreen(
      child: Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              SizedBox(height: 25.h),
              CustomeHeader(title: "Subscriptions"),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Brand Icon
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/brandLogo.png",
                            width: 72.w,
                            height: 72.h,
                            color: AppColors.brand,
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Title
                      Text(
                        "Choose your new plan",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.s30w8i(
                          fontweight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 62.h),

                      // Subscription Cards (NO Recommended badge)
                      Obx(
                        () => Column(
                          children: controller.plans
                              .map(
                                (plan) => Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: SubscriptionCard(
                                    plan: plan,
                                    isSelected: controller.isSelected(plan.id),
                                    onTap: () => controller.selectPlan(plan.id),
                                    isCurrentPlan: controller.isCurrentPlan(
                                      plan.id,
                                    ),
                                    showRecommended:
                                        false, // Don't show Recommended
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      // Change Plan Button
                      SizedBox(height: 62),
                      Obx(
                        () => CustomeButton(
                          gradient: AppColors.secondaryGradient,
                          onTap: controller.isLoading.value
                              ? () {}
                              : controller.changePlan,
                          title: controller.isLoading.value
                              ? "Processing..."
                              : "Change Your Plan",
                        ),
                      ),

                      SizedBox(height: 10.h),
                    ],
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
