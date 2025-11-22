import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/routes/routes_name.dart';

class CustomeHeader extends StatelessWidget {
  CustomeHeader({super.key, required this.title});

  final canGoBack = Navigator.of(Get.context!).canPop();
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Conditional Back Button
          canGoBack
              ? InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                )
              : SizedBox(width: 36.w), // Empty space to maintain alignment

          Text(
            title,
            style: AppTextStyles.s22w7i(
              fontSize: 20.sp,
              fontweight: FontWeight.w700,
            ),
          ),

          Row(
            children: [
              InkWell(
                onTap: () {
                  // Register the NavigationController lazily using a builder function
                  NavigationController controller =
                      Get.find<NavigationController>();

                  controller.clearSelection();
                  Get.toNamed(RoutesName.trackingScreen);
                },
                child: Icon(Icons.notifications_outlined, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              InkWell(
                onTap: () {
                  // Register the NavigationController lazily using a builder function
                  NavigationController controller =
                      Get.find<NavigationController>();

                  controller.clearSelection();
                  Get.toNamed(RoutesName.shoppingList);
                },
                child: Icon(Icons.shopping_cart_outlined, size: 24.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
