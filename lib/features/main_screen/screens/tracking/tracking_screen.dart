// screens/tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/tracking_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/features/main_screen/widgets/notification_card_widget.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackingController>();

    return MainScreen(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(height: 24),
            CustomeHeader(title: "Tracking"),

            // Notifications List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.brand),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No notifications yet',
                          style: AppTextStyles.s16w5i(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 23.h,
                  ),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return NotificationCardWidget(
                      notification: notification,
                      onYes: () => controller.respondToNotification(
                        notification.id,
                        true,
                      ),
                      onNo: () => controller.respondToNotification(
                        notification.id,
                        false,
                      ),
                      onOptions: () =>
                          controller.showNotificationOptions(notification.id),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
            ),
          ),
          Text(
            'Tracking',
            style: AppTextStyles.s22w7i(
              fontweight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 24.sp),
              SizedBox(width: 12.w),
              Icon(Icons.shopping_cart_outlined, size: 24.sp),
            ],
          ),
        ],
      ),
    );
  }
}
