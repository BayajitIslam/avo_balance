// controllers/diet_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';

class DietController extends GetxController {
  final RxBool hasDietPlan = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxMap<String, DayMealPlan> dietPlanData = <String, DayMealPlan>{}.obs;

  // Add to DietController class:

  final RxMap<String, bool> expandedMeals = <String, bool>{
    'breakfast': true,
    'lunch': false,
    'dinner': false,
  }.obs;

  void toggleMealExpansion(String mealId) {
    expandedMeals[mealId] = !(expandedMeals[mealId] ?? false);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    checkDietPlan();
  }

  Future<void> checkDietPlan() async {
    isLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? hasPlan = prefs.getBool('has_diet_plan') ?? false;

      hasDietPlan.value = hasPlan;

      if (hasPlan) {
        await loadDietPlanData();
      }
    } catch (e) {
      print('Error checking diet plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDietPlanData() async {
    await Future.delayed(Duration(milliseconds: 500));

    DateTime today = DateTime.now();

    // Generate dummy data for multiple scenarios
    for (int i = 0; i < 30; i++) {
      DateTime date = today.add(Duration(days: i));
      String dateKey = _getDateKey(date);

      if (i == 0) {
        // Today - Full meal plan
        dietPlanData[dateKey] = DayMealPlan(
          date: date,
          breakfast: MealData(
            name: 'Breakfast',
            items: [
              MealItem(name: 'Paratha', calories: 200, color: Colors.blue),
              MealItem(name: 'Yogurt', calories: 100, color: Colors.yellow),
              MealItem(name: 'Pickle', calories: 20, color: Colors.redAccent),
            ],
          ),
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(name: 'Paratha', calories: 300, color: Colors.black12),
              MealItem(
                name: 'Yogurt',
                calories: 100,
                color: Colors.yellowAccent,
              ),
              MealItem(name: 'Pickle', calories: 20, color: Colors.redAccent),
            ],
          ),
          dinner: MealData(
            name: 'Dinner',
            items: [
              MealItem(name: 'Dal Curry', calories: 250, color: Colors.teal),
              MealItem(name: 'Rice', calories: 300, color: Colors.blue),
            ],
          ),
          totalCalories: 1800,
        );
      } else if (i == 1) {
        // Tomorrow - Only Breakfast
        dietPlanData[dateKey] = DayMealPlan(
          date: date,
          breakfast: MealData(
            name: 'Breakfast',
            items: [
              MealItem(name: 'Paratha', calories: 300, color: Colors.blue),
              MealItem(name: 'Yogurt', calories: 100, color: Colors.yellow),
              MealItem(name: 'Pickle', calories: 20, color: Colors.redAccent),
            ],
          ),
          lunch: null,
          dinner: null,
          totalCalories: 500,
        );
      } else if (i == 2) {
        // Day 3 - Breakfast & Lunch only
        dietPlanData[dateKey] = DayMealPlan(
          date: date,
          breakfast: MealData(
            name: 'Breakfast',
            items: [
              MealItem(name: 'Dal Curry', calories: 250, color: Colors.teal),
              MealItem(name: 'Rice', calories: 300, color: Colors.blue),
            ],
          ),
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(name: 'Dal Curry', calories: 250, color: Colors.teal),
              MealItem(name: 'Rice', calories: 300, color: Colors.blue),
            ],
          ),
          dinner: null,
          totalCalories: 1080,
        );
      } else if (i % 4 == 0) {
        // Every 4th day - Full meal plan with different items
        dietPlanData[dateKey] = DayMealPlan(
          date: date,
          breakfast: MealData(
            name: 'Breakfast',
            items: [
              MealItem(name: 'Paratha', calories: 300, color: Colors.black12),
              MealItem(name: 'Yogurt', calories: 100, color: Colors.yellow),
              MealItem(name: 'Pickle', calories: 20, color: Colors.redAccent),
            ],
          ),
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(name: 'Dal Curry', calories: 250, color: Colors.teal),
              MealItem(name: 'Rice', calories: 300, color: Colors.blue),
              MealItem(
                name: 'Fish Fry',
                calories: 200,
                color: Colors.redAccent,
              ),
            ],
          ),
          dinner: MealData(
            name: 'Dinner',
            items: [
              MealItem(
                name: 'Vegetable Soup',
                calories: 150,
                color: Colors.blue,
              ),
              MealItem(
                name: 'Chicken Breast',
                calories: 250,
                color: Colors.redAccent,
              ),
            ],
          ),
          totalCalories: 1570,
        );
      } else if (i % 3 == 0) {
        // Every 3rd day - Only Lunch & Dinner
        dietPlanData[dateKey] = DayMealPlan(
          date: date,
          breakfast: null,
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(
                name: 'Pasta Carbonara',
                calories: 550,
                color: Colors.red,
              ),
              MealItem(
                name: 'Caesar Salad',
                calories: 200,
                color: Colors.yellow,
              ),
            ],
          ),
          dinner: MealData(
            name: 'Dinner',
            items: [
              MealItem(
                name: 'Grilled Salmon',
                calories: 400,
                color: Colors.blue,
              ),
              MealItem(
                name: 'Steamed Vegetables',
                calories: 100,
                color: Colors.black12,
              ),
            ],
          ),
          totalCalories: 1250,
        );
      }
      // Some days remain empty (no data)
    }

    update();
  }

  // When backend is ready, replace loadDietPlanData() with:

  // Future<void> loadDietPlanData() async {
  //   try {
  //     // API Call
  //     final response = await ApiService.getDietPlan();

  //     // Clear existing data
  //     dietPlanData.clear();

  //     // Parse response
  //     for (var dayData in response['data']) {
  //       DateTime date = DateTime.parse(dayData['date']);
  //       String dateKey = _getDateKey(date);

  //       dietPlanData[dateKey] = DayMealPlan(
  //         date: date,
  //         breakfast: dayData['breakfast'] != null
  //             ? MealData(
  //                 name: 'Breakfast',
  //                 items: (dayData['breakfast']['items'] as List)
  //                     .map((item) => MealItem(
  //                           name: item['name'],
  //                           calories: item['calories'],
  //                         ))
  //                     .toList(),
  //               )
  //             : null,
  //         lunch: dayData['lunch'] != null
  //             ? MealData(
  //                 name: 'Lunch',
  //                 items: (dayData['lunch']['items'] as List)
  //                     .map((item) => MealItem(
  //                           name: item['name'],
  //                           calories: item['calories'],
  //                         ))
  //                     .toList(),
  //               )
  //             : null,
  //         dinner: dayData['dinner'] != null
  //             ? MealData(
  //                 name: 'Dinner',
  //                 items: (dayData['dinner']['items'] as List)
  //                     .map((item) => MealItem(
  //                           name: item['name'],
  //                           calories: item['calories'],
  //                         ))
  //                     .toList(),
  //               )
  //             : null,
  //         totalCalories: dayData['total_calories'],
  //       );
  //     }

  //     update();
  //   } catch (e) {
  //     print('Error loading diet plan: $e');
  //   }
  // }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DayMealPlan? getCurrentDayPlan() {
    String dateKey = _getDateKey(selectedDate.value);
    return dietPlanData[dateKey];
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;

    // Update currentMonth if selected date is in different month
    if (date.month != currentMonth.value.month ||
        date.year != currentMonth.value.year) {
      currentMonth.value = DateTime(date.year, date.month, 1);
    }

    update();
  }

  bool hasDataForDate(DateTime date) {
    String dateKey = _getDateKey(date);
    return dietPlanData.containsKey(dateKey);
  }

  List<DateTime> getDaysInMonth() {
    DateTime today = DateTime.now();
    return List.generate(30, (index) => today.add(Duration(days: index)));
  }

  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
      1,
    );
    update();
  }

  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
      1,
    );
    update();
  }

  //Bottom Sheet
  void showAddMealDialog(String mealType) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              Text('Add $mealType', style: AppTextStyles.s22w7i()),

              SizedBox(height: 8.h),

              Text(
                'Upload your prescription photo',
                style: AppTextStyles.s14w4i(color: Colors.grey),
              ),

              SizedBox(height: 24.h),

              // Capture Photo Option
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context); // Close bottom sheet

                    // Open custom camera screen
                    final result = await Get.to(
                      () => CameraCaptureScreen(mealType: mealType),
                      transition: Transition.downToUp,
                    );

                    if (result != null && result is File) {
                      await uploadPrescription(result, mealType);
                    }
                  },
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
                                  color: Colors.white,
                                  fontweight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Take a photo now',
                                style: AppTextStyles.s14w4i(
                                  color: Colors.white.withOpacity(0.8),
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
              ),

              SizedBox(height: 12.h),

              // Select from Gallery Option
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    selectFromGallery(mealType);
                  },
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
              ),

              SizedBox(height: 16.h),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.s16w5i(color: Colors.grey),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> capturePhoto(String mealType) async {
    Get.back();

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        await uploadPrescription(File(photo.path), mealType);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture photo: $e');
    }
  }

  Future<void> selectFromGallery(String mealType) async {
    Get.back();

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await uploadPrescription(File(image.path), mealType);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select photo: $e');
    }
  }

  Future<void> uploadPrescription(File image, String mealType) async {
    isLoading.value = true;

    try {
      // TODO: Replace with actual API call
      // final response = await ApiService.uploadPrescription(
      //   image: image,
      //   mealType: mealType,
      // );

      // Simulate API delay
      await Future.delayed(Duration(seconds: 2));

      // Show success message
      Get.snackbar(
        'Success',
        'Prescription uploaded! Generating your meal plan...',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      // Save that user has diet plan
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_diet_plan', true);

      hasDietPlan.value = true;

      // Load dummy data
      await loadDietPlanData();

      Get.snackbar(
        'Ready!',
        '30-day meal plan generated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogCheatMeal() {
    // TODO: Implement log cheat meal screen
    Get.snackbar(
      'Coming Soon',
      'Log Cheat Meal feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToManagePlan() {
    // TODO: Implement manage plan screen
    Get.snackbar(
      'Coming Soon',
      'Manage Plan feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Models
class DayMealPlan {
  final DateTime date;
  final MealData? breakfast;
  final MealData? lunch;
  final MealData? dinner;
  final int totalCalories;

  DayMealPlan({
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    required this.totalCalories,
  });
}

class MealData {
  final String name;
  final List<MealItem> items;

  MealData({required this.name, required this.items});

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
}

// In diet_controller.dart - MealItem class
class MealItem {
  final String name;
  final int calories;
  final int? weight;
  final Color color; // Remove '?' to make it non-nullable

  MealItem({
    required this.name,
    required this.calories,
    this.weight,
    required this.color, // Make it required
  });
}
