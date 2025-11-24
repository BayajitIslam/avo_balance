// widgets/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller;

    try {
      controller = Get.find<NavigationController>();
    } catch (e) {
      controller = Get.put(NavigationController(), permanent: true);
    }

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 10,
        //     offset: Offset(0, -2),
        //   ),
        // ],
      ),
      child: Obx(
        () => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Bottom Nav Items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  isLogo: false,
                  isSvg: true,
                  imagePath: 'assets/icons/home.svg', // Replace with your image
                  label: 'Home',
                  index: 0,
                  isActive: controller.currentIndex.value == 0,
                  onTap: () => controller.changePage(0),
                ),
                _buildNavItem(
                  isLogo: true,
                  isSvg: false,
                  weight: 42.w,
                  height: 42.h,
                  imagePath: 'assets/icons/icon.png', // Replace with your image
                  label: 'Diet',
                  index: 1,
                  isActive: controller.currentIndex.value == 1,
                  onTap: () => controller.changePage(1),
                ),
                _buildNavItem(
                  isLogo: false,

                  isSvg: true,
                  imagePath:
                      'assets/icons/user_avo.svg', // Replace with your image
                  label: 'User',
                  index: 2,
                  isActive: controller.currentIndex.value == 2,
                  onTap: () => controller.changePage(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required bool isSvg,
    required String imagePath,
    required String label,
    required int index,
    required bool isActive,
    required bool isLogo,
    double? weight,
    double? height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isActive ? -20.h : 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Button
            Container(
              width: isActive ? 66.w : 48.w,
              height: isActive ? 66.h : 48.h,
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                color: isActive ? null : Colors.transparent,
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(color: Colors.white, width: 4)
                    : Border.all(color: AppColors.transparent),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFFE6E6E6),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isActive ? Colors.white : Colors.grey.shade600,
                    BlendMode.srcIn,
                  ),
                  child: isSvg
                      ? SvgPicture.asset(imagePath)
                      : Image.asset(
                          imagePath,
                          width: isLogo
                              ? weight
                              : isActive
                              ? 24.w
                              : 23.w,
                          height: isLogo
                              ? height
                              : isActive
                              ? 24.h
                              : 23.h,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),

            SizedBox(height: 5.h),

            // Label
            Text(
              label,
              style: AppTextStyles.s14w4i(
                fontSize: 12.sp,
                fontweight: isActive ? FontWeight.w500 : FontWeight.w700,
                color: isActive ? AppColors.brand : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
