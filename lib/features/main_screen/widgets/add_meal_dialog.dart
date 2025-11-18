// widgets/add_meal_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class AddMealDialog extends StatelessWidget {
  final String mealType;
  final VoidCallback onCapture;
  final VoidCallback onGallery;

  const AddMealDialog({
    super.key,
    required this.mealType,
    required this.onCapture,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text('Add $mealType', style: AppTextStyles.s22w7i()),

          SizedBox(height: 8.h),

          Text(
            'Upload your prescription photo',
            style: AppTextStyles.s14w4i(color: Colors.grey),
          ),

          SizedBox(height: 24.h),

          // Capture Photo Option
          InkWell(
            onTap: onCapture,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capture Photo',
                          style: AppTextStyles.s16w5i(
                            color: AppColors.white,
                            fontweight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Take a photo now',
                          style: AppTextStyles.s14w4i(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Select from Gallery Option
          InkWell(
            onTap: onGallery,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.brand.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: AppColors.brand,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select from Gallery',
                          style: AppTextStyles.s16w5i(
                            fontweight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Choose existing photo',
                          style: AppTextStyles.s14w4i(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.brand,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Cancel Button
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.s16w5i(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
