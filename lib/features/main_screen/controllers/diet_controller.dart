// controllers/diet_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/log_cheat_meal_bottom_sheet.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/manage_your_plan.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/replace_meal_bottom_sheet.dart';

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
      debugPrint('Error checking diet plan: $e');
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
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                weight: 100,
                color: Color(0xffFF73A3),
              ),
              MealItem(
                name: 'Rice',

                weight: 15,
                calories: 220,
                color: Color(0xFF3F51B5),
              ),
              MealItem(
                name: 'Butter',
                calories: 220,
                weight: 100,
                color: Color(0xFF9C28B1),
              ),
              MealItem(
                name: 'Meat',
                calories: 160,
                weight: 15,
                color: Color(0xFFBC81C7),
              ),
            ],
          ),
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
              MealItem(name: 'Butter', calories: 220, color: Color(0xFF9C28B1)),
            ],
          ),
          dinner: MealData(
            name: 'Dinner',
            items: [
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
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
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
              MealItem(name: 'Butter', calories: 220, color: Color(0xFF9C28B1)),
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
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
            ],
          ),
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
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
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
              MealItem(name: 'Butter', calories: 220, color: Color(0xFF9C28B1)),
            ],
          ),
          lunch: MealData(
            name: 'Lunch',
            items: [
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
              MealItem(name: 'Butter', calories: 220, color: Color(0xFF9C28B1)),
            ],
          ),
          dinner: MealData(
            name: 'Dinner',
            items: [
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
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
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
            ],
          ),
          dinner: MealData(
            name: 'Dinner',
            items: [
              MealItem(
                name: 'Oatmeal',
                calories: 220,
                color: Color(0xffFF73A3),
              ),
              MealItem(name: 'Rice', calories: 220, color: Color(0xFF3F51B5)),
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

  void showAddMealDialog(String mealType) async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReplaceMealBottomSheet(initialMealType: mealType),
    );

    // Handle result
    if (result != null && result is Map) {
      final action = result['action'];
      final selectedMealType = result['mealType'];
      final details = result['details'];

      if (action == 'camera') {
        // Open camera screen
        final cameraResult = await Get.to(
          () => CameraCaptureScreen(mealType: selectedMealType),
          transition: Transition.downToUp,
        );

        if (cameraResult != null && cameraResult is File) {
          await uploadPrescription(
            cameraResult,
            selectedMealType,
            details: details,
          );
        }
      } else if (action == 'gallery') {
        // Open gallery
        try {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );

          if (image != null) {
            await uploadPrescription(
              File(image.path),
              selectedMealType,
              details: details,
            );
          }
        } catch (e) {
          Get.snackbar(
            'Error',
            'Failed to select photo: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    }
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

  Future<void> uploadPrescription(
    File image,
    String mealType, {
    String? details, // Add this parameter
  }) async {
    isLoading.value = true;

    try {
      // TODO: Replace with actual API call
      // final response = await ApiService.uploadPrescription(
      //   image: image,
      //   mealType: mealType,
      //   details: details, // Pass details to API
      // );

      // Simulate API delay
      await Future.delayed(Duration(seconds: 2));

      // Show success message
      Get.snackbar(
        'Success',
        details != null && details.isNotEmpty
            ? 'Meal uploaded with details!'
            : 'Meal uploaded successfully!',
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
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LogCheatMealBottomSheet(),
    );
  }

  void navigateToManagePlan() async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ManageYourPlan(),
    );

    // Handle result
    if (result != null && result is Map) {
      final action = result['action'];

      if (action == 'continue') {
        print('Continue current plan');
      } else if (action == 'upload') {
        print('Upload new plan');
        // TODO: Implement upload logic
      } else if (action == 'replace') {
        print('Replace current plan');
        // TODO: Implement replace logic
      }
    }
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
