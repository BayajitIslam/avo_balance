import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class ActionButton extends StatelessWidget {
  final String leftIcon;
  final Color? rightIconbgColor;
  final Gradient? leftIconbgColor;
  final String title;
  final Color titleColor;
  final Color descColor;
  final String desc;
  final Gradient? gradient;
  final IconData? rightIcon;
  final Color? rightIconColor;
  final void Function()? onTap;
  final bool borderEnbale;
  final bool iconBorderEnable;
  final bool shadowOn;
  const ActionButton({
    super.key,
    required this.onTap,
    required this.leftIcon,
    this.rightIcon,
    required this.title,
    this.desc = "",
    this.gradient = AppColors.secondaryGradient,
    this.rightIconbgColor = const Color(0XffF3F4F6),
    this.leftIconbgColor,
    this.descColor = AppColors.white,
    this.titleColor = AppColors.white,
    this.rightIconColor,
    this.iconBorderEnable = false,
    this.borderEnbale = false,
    this.shadowOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          boxShadow: shadowOn
              ? [
                  BoxShadow(
                    color: Color(0xFFFF6900),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.inner,
                  ),
                ]
              : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(16.r),
          border: borderEnbale
              ? Border.all(color: const Color(0xFFC9C9C9), width: 1)
              : null,
        ),
        child: Row(
          children: [
            //LEFT ICON
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                gradient: leftIconbgColor,
                borderRadius: BorderRadius.circular(12),
                border: iconBorderEnable
                    ? Border.all(
                        color: AppColors.white.withOpacity(0.30),
                        width: 1,
                      )
                    : null,
              ),
              child: Icon(Icons.fastfood, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.s16w5i(
                      color: titleColor,
                      fontweight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    desc,
                    style: AppTextStyles.s14w4i(
                      color: descColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: rightIconbgColor,
              child: Icon(
                Icons.arrow_forward,
                color: rightIconColor,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
