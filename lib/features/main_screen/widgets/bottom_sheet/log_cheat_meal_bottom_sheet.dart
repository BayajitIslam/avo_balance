// // widgets/replace_meal_bottom_sheet.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:template/core/constants/app_colors.dart';
// import 'package:template/core/themes/app_text_style.dart';

// class LogCheatMealBottomSheet extends StatelessWidget {
//   final void Function()? replaceMealTap;
//   final void Function()? extraMealTap;

//   const LogCheatMealBottomSheet({
//     super.key,
//     required this.replaceMealTap,
//     required this.extraMealTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.r),
//           topRight: Radius.circular(24.r),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(24.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Close Button & Title
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ShaderMask(
//                       blendMode: BlendMode.srcIn,
//                       shaderCallback: (bounds) =>
//                           AppColors.secondaryGradient.createShader(
//                             Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                           ),
//                       child: Text(
//                         'Log Cheat Meal',
//                         style: AppTextStyles.s22w7i(
//                           color: const Color(0xFFFFFFFF),
//                           fontSize: 24.sp,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Icon(
//                         Icons.close,
//                         size: 24.sp,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 8.h),

//                 Text(
//                   'Choose how to log this meal',
//                   style: AppTextStyles.s14w4i(fontSize: 13.sp),
//                 ),

//                 SizedBox(height: 59.h),
//                 // Bottom Buttons
//                 Row(
//                   children: [
//                     // Log Meal Button
//                     Expanded(
//                       child: InkWell(
//                         onTap: replaceMealTap,
//                         child: Container(
//                           height: 50.h,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 2,
//                               ),
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                             gradient: AppColors.secondaryGradient,
//                             borderRadius: BorderRadius.circular(16.r),
//                           ),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Image.asset("assets/icons/ix_replace.png"),
//                                 Text(
//                                   'Replace Meal',
//                                   style: AppTextStyles.s14w4i(
//                                     color: Colors.white,
//                                     fontweight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // RePLACE Button
//                     SizedBox(width: 12.w),

//                     Expanded(
//                       child: InkWell(
//                         onTap: extraMealTap,
//                         child: Container(
//                           height: 50.h,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 2,
//                               ),
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16.r),
//                             border: Border.all(
//                               color: const Color(0xFFFB2C36),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Icon(Icons.add, color: const Color(0xFFFB2C36)),
//                                 ShaderMask(
//                                   blendMode: BlendMode.srcIn,
//                                   shaderCallback: (bounds) =>
//                                       AppColors.secondaryGradient.createShader(
//                                         Rect.fromLTWH(
//                                           0,
//                                           0,
//                                           bounds.width,
//                                           bounds.height,
//                                         ),
//                                       ),
//                                   child: Text(
//                                     'Add as Extra',
//                                     style: AppTextStyles.s14w4i(
//                                       color: Colors.black87,
//                                       fontweight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// widgets/bottom_shet/log_cheat_meal_bottom_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/screens/diet/analyzing_meal_screen.dart.dart';

class LogCheatMealBottomSheet extends StatelessWidget {
  const LogCheatMealBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Log Cheat Meal',
            style: AppTextStyles.s18w5i(fontweight: FontWeight.w700),
          ),

          SizedBox(height: 24.h),

          // Camera Option
          _buildOption(
            context: context,
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            onTap: () => _takePhoto(context),
          ),

          SizedBox(height: 16.h),

          // Gallery Option
          _buildOption(
            context: context,
            icon: Icons.photo_library_outlined,
            title: 'Choose from Gallery',
            onTap: () => _pickFromGallery(context),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              title,
              style: AppTextStyles.s16w5i(fontweight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto(BuildContext context) async {
    Navigator.pop(context); // Close bottom sheet

    final result = await Get.to(
      () => CameraCaptureScreen(mealType: 'Cheat Meal'),
      transition: Transition.downToUp,
    );

    if (result != null && result is File) {
      _navigateToAnalyzing(result);
    }
  }

  void _pickFromGallery(BuildContext context) async {
    Navigator.pop(context); // Close bottom sheet

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        _navigateToAnalyzing(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select photo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToAnalyzing(File imageFile) {
    Get.to(
      () => AnalyzingMealScreen(imageFile: imageFile),
      transition: Transition.fadeIn,
    );
  }
}
