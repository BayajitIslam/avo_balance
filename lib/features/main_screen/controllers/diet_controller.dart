// controllers/diet_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/extra_meal_selection.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/log_cheat_meal_bottom_sheet.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/manage_your_plan.dart';
import 'package:template/features/main_screen/widgets/bottom_shet/replace_meal_bottom_sheet.dart';

class DietController extends GetxController {
  final RxBool hasDietPlan = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxMap<String, DayMealPlan> dietPlanData = <String, DayMealPlan>{}.obs;

  final RxMap<String, bool> expandedMeals = <String, bool>{
    'breakfast': true,
    'lunch': false,
    'dinner': false,
  }.obs;

  // ========== Manage Plan Fields ==========
  final RxBool repeatCurrentPlan = true.obs;
  final Rx<File?> newPlanFile = Rx<File?>(null);
  final RxString newPlanFileName = ''.obs;
  final Rx<DateTime?> newPlanStartDate = Rx<DateTime?>(null);

  // Current Plan Info
  final RxString currentPlanName = "Meal Plan 1".obs;
  final Rx<DateTime> currentPlanEndDate = DateTime(2025, 12, 30).obs;

  // Previous Plan Info (for restore)
  final RxString previousPlanName = ''.obs;
  final Rx<DateTime?> previousPlanEndDate = Rx<DateTime?>(null);
  final RxBool hasPreviousPlan = false.obs;

  // Next Plan Info
  final RxString nextPlanName = ''.obs;
  final Rx<DateTime?> nextPlanStartDate = Rx<DateTime?>(null);

  // ========== Manage Plan Methods ==========

  String formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  void toggleRepeat(bool value) => repeatCurrentPlan.value = value;

  String get dynamicMessage {
    if (repeatCurrentPlan.value) {
      return "The current plan will automatically repeat when it ends.";
    }

    if (newPlanStartDate.value == null) {
      return "The new plan will start when the current one ends.";
    }

    final today = DateTime.now();
    final isToday =
        newPlanStartDate.value!.year == today.year &&
        newPlanStartDate.value!.month == today.month &&
        newPlanStartDate.value!.day == today.day;

    if (isToday) {
      return "The new plan will start immediately and replace the current one.";
    }

    return "The new plan will start on the selected date.";
  }

  Future<void> pickNewPlanStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: newPlanStartDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: AppColors.brand)),
        child: child!,
      ),
    );

    if (picked != null) {
      newPlanStartDate.value = picked;
    }
  }

  void setNewPlanFile(File file) {
    newPlanFile.value = file;
    newPlanFileName.value = file.path.split('/').last;
  }

  void clearNewPlanFile() {
    newPlanFile.value = null;
    newPlanFileName.value = '';
  }

  void clearNewPlanDate() => newPlanStartDate.value = null;

  // Check if selected date is today
  bool get isStartDateToday {
    if (newPlanStartDate.value == null) return false;
    final today = DateTime.now();
    return newPlanStartDate.value!.year == today.year &&
        newPlanStartDate.value!.month == today.month &&
        newPlanStartDate.value!.day == today.day;
  }

  String _getActionType() {
    if (repeatCurrentPlan.value) return 'repeat_current';
    if (newPlanStartDate.value == null) return 'start_after_current';
    if (isStartDateToday) return 'replace_immediately';
    if (newPlanStartDate.value!.isBefore(currentPlanEndDate.value))
      return 'replace_on_date';
    return 'start_on_date';
  }

  // Save plan changes
  void savePlanChanges() {
    final action = _getActionType();

    if (action == 'replace_immediately' && newPlanFile.value != null) {
      // Store current plan as previous plan
      previousPlanName.value = currentPlanName.value;
      previousPlanEndDate.value = currentPlanEndDate.value;
      hasPreviousPlan.value = true;

      // Set new plan as current
      currentPlanName.value = newPlanFileName.value.isNotEmpty
          ? newPlanFileName.value
                .replaceAll('.pdf', '')
                .replaceAll('.jpg', '')
                .replaceAll('.png', '')
          : "New Meal Plan";
      currentPlanEndDate.value = DateTime.now().add(
        Duration(days: 30),
      ); // Default 30 days

      // Clear new plan fields
      newPlanFile.value = null;
      newPlanFileName.value = '';
      newPlanStartDate.value = null;
      repeatCurrentPlan.value = true;
    }

    // TODO: API call
    /*
    await ApiService.updatePlan(
      action: action,
      repeat: repeatCurrentPlan.value,
      file: newPlanFile.value,
      startDate: newPlanStartDate.value,
    );
    */

    Get.back();

    Get.snackbar(
      'Success',
      'Plan updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // Restore previous plan
  void restorePreviousPlan() {
    if (!hasPreviousPlan.value) return;

    // Swap current and previous
    final tempName = currentPlanName.value;
    final tempEndDate = currentPlanEndDate.value;

    currentPlanName.value = previousPlanName.value;
    currentPlanEndDate.value = previousPlanEndDate.value!;

    previousPlanName.value = tempName;
    previousPlanEndDate.value = tempEndDate;

    // TODO: API call to restore
    /*
    await ApiService.restorePreviousPlan();
    */

    Get.snackbar(
      'Success',
      'Previous plan restored successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // Clear previous plan (user doesn't want to keep it)
  void clearPreviousPlan() {
    previousPlanName.value = '';
    previousPlanEndDate.value = null;
    hasPreviousPlan.value = false;
  }

  // ========== Existing Methods ==========

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

    for (int i = 0; i < 30; i++) {
      DateTime date = today.add(Duration(days: i));
      String dateKey = _getDateKey(date);

      if (i == 0) {
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
    }

    update();
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DayMealPlan? getCurrentDayPlan() {
    String dateKey = _getDateKey(selectedDate.value);
    return dietPlanData[dateKey];
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;

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

  void openCamara(String mealType) async {
    final cameraResult = await Get.to(
      () => CameraCaptureScreen(mealType: mealType),
      transition: Transition.downToUp,
    );

    if (cameraResult != null && cameraResult is File) {
      await uploadPrescription(cameraResult, mealType);
    }
  }

  void showReplaceMealDialog(String mealType) async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReplaceMealBottomSheet(initialMealType: mealType),
    );

    if (result != null && result is Map) {
      final action = result['action'];
      final selectedMealType = result['mealType'];
      final details = result['details'];

      if (action == 'camera') {
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

  void showExtraMealAddDialog(String mealType) async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ExtraMealSelection(initialMealType: mealType),
    );

    if (result != null && result is Map) {
      final action = result['action'];
      final selectedMealType = result['mealType'];
      final details = result['details'];

      if (action == 'camera') {
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
    String? details,
  }) async {
    isLoading.value = true;

    try {
      await Future.delayed(Duration(seconds: 2));

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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_diet_plan', true);

      hasDietPlan.value = true;

      await loadDietPlanData();

      Get.snackbar(
        'Ready!',
        'Meal Add successfully!',
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
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LogCheatMealBottomSheet(
        replaceMealTap: () {
          Navigator.pop(context);
          showReplaceMealDialog("Breakfast");
        },
        extraMealTap: () {
          Navigator.pop(context);
          showExtraMealAddDialog("Breakfast");
        },
      ),
    );
  }

  void navigateToManagePlan() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ManageYourPlan(),
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

class MealItem {
  final String name;
  final int calories;
  final int? weight;
  final Color color;

  MealItem({
    required this.name,
    required this.calories,
    this.weight,
    required this.color,
  });
}
