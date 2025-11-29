import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';

class CustomeSwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;

  const CustomeSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36.w,
        height: 20.h,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          // color:  AppColors.ash,
          gradient: value ? AppColors.secondaryGradient : AppColors.ashGradiant,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16.w,
            height: 16.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
