// widgets/notification_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/models/notification_model.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final VoidCallback onOptions;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onYes,
    required this.onNo,
    required this.onOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCFCFCF),
            blurRadius: 10,
            spreadRadius: -5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row - Icon, Message, Options
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEDED),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/notification.png",
                    fit: BoxFit.cover,
                    width: 34,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      notification.message,
                      style: AppTextStyles.s16w5i(
                        fontweight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                    !notification.isResponded
                        ? SizedBox(height: 10.h)
                        : SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          notification.time,
                          style: AppTextStyles.s14w4i(fontSize: 10.sp),
                        ),
                        if (notification.isResponded) ...[
                          Text(' • ', style: TextStyle(color: Colors.grey)),
                          Text(
                            'Responded',
                            style: AppTextStyles.s14w4i(fontSize: 10.sp),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Three Dots Menu
              InkWell(
                onTap: onOptions,
                child: Icon(
                  Icons.more_vert,
                  size: 20.sp,
                  color: AppColors.black,
                ),
              ),
            ],
          ),

          // Buttons (only show if not responded)
          if (!notification.isResponded) ...[
            SizedBox(
              child: Row(
                children: [
                  //
                  SizedBox(height: 50.h, width: 50.w),
                  // Yes Button
                  Expanded(
                    child: InkWell(
                      onTap: onYes,
                      child: Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              'Yes',
                              style: AppTextStyles.s14w4i(
                                color: Colors.white,
                                fontweight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // No Button
                  Expanded(
                    child: InkWell(
                      onTap: onNo,
                      child: Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.white, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              'No',
                              style: AppTextStyles.s14w4i(
                                color: Colors.white,
                                fontweight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
