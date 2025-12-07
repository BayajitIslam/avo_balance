import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/features/main_screen/screens/diet/meal_summary_screen.dart';

class AnalyzingMealScreen extends StatefulWidget {
  final File imageFile;

  const AnalyzingMealScreen({super.key, required this.imageFile});

  @override
  State<AnalyzingMealScreen> createState() => _AnalyzingMealScreenState();
}

class _AnalyzingMealScreenState extends State<AnalyzingMealScreen> {
  @override
  void initState() {
    super.initState();
    _startAnalyzing();
  }

  void _startAnalyzing() async {
    // Simulate AI analyzing (2 seconds)
    await Future.delayed(Duration(seconds: 2));

    // Navigate to Meal Summary Screen
    if (mounted) {
      Get.off(
        () => MealSummaryScreen(imageFile: widget.imageFile),
        transition: Transition.fadeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(widget.imageFile, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Analyzing your meal...',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
