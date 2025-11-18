// screens/image_preview_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/widget/custome_button.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File image;
  final String mealType;

  const ImagePreviewScreen({
    Key? key,
    required this.image,
    required this.mealType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image Preview
          Positioned.fill(
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(image, fit: BoxFit.cover),
              ),
            ),
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    InkWell(
                      onTap: () => Get.back(result: null),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Actions
          Positioned(
            bottom: -25,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Submit Button
                    CustomeButton(
                      gradient: AppColors.primaryGradient,
                      onTap: () => Get.back(result: image),
                      title: "Submit",
                    ),

                    SizedBox(height: 16.h),

                    // Retake Button
                    CustomeButton(
                      gradient: AppColors.transparentGradiant,
                      onTap: () => Get.back(result: 'retake'),
                      title: "Retake",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
