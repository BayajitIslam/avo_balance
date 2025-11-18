// widgets/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller safely
    NavigationController controller;

    try {
      controller = Get.find<NavigationController>();
    } catch (e) {
      // If not found, create new one
      controller = Get.put(NavigationController(), permanent: true);
    }

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              index: 0,
              isActive: controller.currentIndex.value == 0,
              onTap: () => controller.changePage(0),
            ),
            _buildNavItem(
              icon: Icons.restaurant_menu_outlined,
              activeIcon: Icons.restaurant_menu,
              label: 'Diet',
              index: 1,
              isActive: controller.currentIndex.value == 1,
              onTap: () => controller.changePage(1),
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'User',
              index: 2,
              isActive: controller.currentIndex.value == 2,
              onTap: () => controller.changePage(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.white : Colors.grey.shade600,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.s14w4i(
                fontSize: 12.sp,
                fontweight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.brand : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
