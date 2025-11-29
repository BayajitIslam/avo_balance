// controllers/diet_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/widgets/bottom_sheet/extra_meal_selection.dart';
import 'package:template/features/main_screen/widgets/bottom_sheet/log_cheat_meal_bottom_sheet.dart';
import 'package:template/features/main_screen/widgets/bottom_sheet/manage_your_plan.dart';
import 'package:template/features/main_screen/widgets/bottom_sheet/replace_meal_bottom_sheet.dart';

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

  // ==========================================
  // ========== MANAGE PLAN FIELDS ===========
  // ==========================================

  // Toggle state (default = ON)
  final RxBool repeatCurrentPlan = true.obs;

  // New Plan data (NEVER deleted when toggle changes)
  final Rx<File?> newPlanFile = Rx<File?>(null);
  final RxString newPlanFileName = ''.obs;
  final Rx<DateTime?> newPlanStartDate = Rx<DateTime?>(null);

  // Current Plan Info (from API/backend)
  final RxString currentPlanName = "Meal Plan 1".obs;
  final Rx<DateTime> currentPlanStartDate = DateTime(2025, 12, 20).obs;
  final Rx<DateTime> currentPlanEndDate = DateTime(2026, 1, 15).obs;

  // Next Plan Info (if scheduled)
  final RxString nextPlanName = ''.obs;
  final Rx<DateTime?> nextPlanStartDate = Rx<DateTime?>(null);

  // Previous Plan Info (for restore after immediate replacement)
  final RxString previousPlanName = ''.obs;
  final Rx<DateTime?> previousPlanStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> previousPlanEndDate = Rx<DateTime?>(null);
  final Rx<DateTime?> newPlanEndDate = Rx<DateTime?>(null);
  final RxBool hasPreviousPlan = false.obs;

  // ==========================================
  // ========== MANAGE PLAN METHODS ==========
  // ==========================================

  /// Format date - dd MMM yyyy
  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  /// Toggle repeat - NEVER deletes saved data
  void toggleRepeat(bool value) {
    repeatCurrentPlan.value = value;
    // Important: Do NOT clear newPlanFile, newPlanFileName, or newPlanStartDate
    // Data must persist when toggling ON/OFF
  }

  /// Check if selected start date is today
  bool get isStartDateToday {
    if (newPlanStartDate.value == null) return false;
    final today = DateTime.now();
    return newPlanStartDate.value!.year == today.year &&
        newPlanStartDate.value!.month == today.month &&
        newPlanStartDate.value!.day == today.day;
  }

  /// Check if file is uploaded
  bool get hasFileUploaded => newPlanFile.value != null;

  /// Check if date is selected
  bool get hasDateSelected => newPlanStartDate.value != null;

  bool get hasEndDateSelected => newPlanEndDate.value != null;

  /// Pick end date for new plan (optional)
  Future<void> pickNewPlanEndDate(BuildContext context) async {
    // First date should be after start date (if selected) or today
    final firstDate = newPlanStartDate.value ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: newPlanEndDate.value ?? firstDate.add(Duration(days: 30)),
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: AppColors.brand)),
        child: child!,
      ),
    );

    if (picked != null) {
      newPlanEndDate.value = picked;
    }
  }

  /// Updated dynamic message with end date
  String get dynamicMessage {
    // State 1: Toggle ON
    if (repeatCurrentPlan.value) {
      return "The current plan will automatically repeat when it ends.";
    }

    // State 2: Toggle OFF + no file uploaded
    if (!hasFileUploaded) {
      return "The new plan will start when the current one ends.";
    }

    // State 3: Toggle OFF + file uploaded + no date selected
    if (!hasDateSelected) {
      return "The new plan will start when the current one ends.";
    }

    // State 4: Toggle OFF + date = today (immediate replacement)
    if (isStartDateToday) {
      if (hasEndDateSelected) {
        return "The new plan will start immediately and end on ${formatDate(newPlanEndDate.value!)}.";
      }
      return "The new plan will start immediately and replace the current one.";
    }

    // State 5: Toggle OFF + future date selected
    if (hasEndDateSelected) {
      return "The new plan will start on ${formatDate(newPlanStartDate.value!)} and end on ${formatDate(newPlanEndDate.value!)}.";
    }
    return "The new plan will start on the selected date.";
  }

  /// Pick start date for new plan
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

  /// Set new plan file
  void setNewPlanFile(File file) {
    newPlanFile.value = file;

    // Extract filename
    String fileName = file.path.split('/').last;

    // Truncate if too long (max 25 chars)
    if (fileName.length > 25) {
      String extension = fileName.contains('.')
          ? '.${fileName.split('.').last}'
          : '';
      String nameWithoutExt = fileName.replaceAll(extension, '');
      fileName = '${nameWithoutExt.substring(0, 15)}...$extension';
    }

    newPlanFileName.value = fileName;
  }

  /// Replace file (open camera/picker again)
  Future<void> replaceNewPlanFile(BuildContext context) async {
    Navigator.pop(context);

    final result = await Get.to(
      () => CameraCaptureScreen(mealType: 'New Plan'),
      transition: Transition.downToUp,
    );

    if (result != null && result is File) {
      setNewPlanFile(result);
    }

    // Reopen bottom sheet
    navigateToManagePlan();
  }

  /// Get action type based on current state
  String _getActionType() {
    // Toggle ON = repeat current plan
    if (repeatCurrentPlan.value) {
      return 'repeat_current';
    }

    // Toggle OFF + no file = no action needed
    if (!hasFileUploaded) {
      return 'no_file';
    }

    // Toggle OFF + file + no date = start after current ends
    if (!hasDateSelected) {
      return 'start_after_current';
    }

    // Toggle OFF + date = today = immediate replacement
    if (isStartDateToday) {
      return 'replace_immediately';
    }

    // Toggle OFF + date before current plan ends = replace on date
    if (newPlanStartDate.value!.isBefore(currentPlanEndDate.value)) {
      return 'replace_on_date';
    }

    // Toggle OFF + date after current plan ends = start on date (current repeats until then)
    return 'start_on_date';
  }

  /// Save plan changes
  void savePlanChanges() {
    final action = _getActionType();

    switch (action) {
      case 'repeat_current':
        // Toggle ON - Just repeat current plan, ignore new plan data
        _saveRepeatCurrentPlan();
        break;

      case 'no_file':
        // No file uploaded - show error or just close
        Get.back();
        Get.snackbar(
          'Info',
          'No changes made. Upload a plan to schedule.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;

      case 'start_after_current':
        // New plan starts after current ends
        _saveStartAfterCurrent();
        break;

      case 'replace_immediately':
        // Date = today - Immediate replacement
        _saveReplaceImmediately();
        break;

      case 'replace_on_date':
        // Date before current ends - Replace on that date
        _saveReplaceOnDate();
        break;

      case 'start_on_date':
        // Date after current ends - Current repeats, new starts on date
        _saveStartOnDate();
        break;
    }

    Get.back();

    // Always show this toast
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

  /// Save: Repeat current plan (Toggle ON)
  void _saveRepeatCurrentPlan() {
    // Clear any scheduled next plan
    nextPlanName.value = '';
    nextPlanStartDate.value = null;

    // TODO: API call
    /*
    await ApiService.updatePlan(
      action: 'repeat_current',
      repeat: true,
    );
    */

    debugPrint('✅ Action: Repeat current plan');
  }

  /// Save: New plan starts after current ends
  void _saveStartAfterCurrent() {
    String newName = _extractPlanName();

    // Schedule next plan
    nextPlanName.value = newName;
    nextPlanStartDate.value = currentPlanEndDate.value.add(Duration(days: 1));

    // Clear new plan data after scheduling
    _clearNewPlanDataAfterSave();

    // TODO: API call
    /*
    await ApiService.updatePlan(
      action: 'start_after_current',
      file: newPlanFile.value,
      startDate: currentPlanEndDate.value.add(Duration(days: 1)),
    );
    */

    debugPrint('✅ Action: New plan starts after current ends');
  }

  /// Save: Immediate replacement (date = today)
  void _saveReplaceImmediately() {
    // Store current plan as previous plan (for restore option)
    previousPlanName.value = currentPlanName.value;
    previousPlanStartDate.value = currentPlanStartDate.value;
    previousPlanEndDate.value = currentPlanEndDate.value;
    hasPreviousPlan.value = true;

    String newName = _extractPlanName();

    // Set new plan as current
    currentPlanName.value = newName;
    currentPlanStartDate.value = DateTime.now();
    currentPlanEndDate.value = DateTime.now().add(
      Duration(days: 30),
    ); // Default 30 days

    // Clear scheduled next plan
    nextPlanName.value = '';
    nextPlanStartDate.value = null;

    // Clear new plan data after save
    _clearNewPlanDataAfterSave();

    // TODO: API call
    /*
    await ApiService.updatePlan(
      action: 'replace_immediately',
      file: newPlanFile.value,
      startDate: DateTime.now(),
    );
    */

    debugPrint('✅ Action: Immediate replacement');
  }

  /// Save: Replace on selected date (before current ends)
  void _saveReplaceOnDate() {
    String newName = _extractPlanName();

    // Schedule replacement
    nextPlanName.value = newName;
    nextPlanStartDate.value = newPlanStartDate.value;

    // Update current plan end date
    currentPlanEndDate.value = newPlanStartDate.value!.subtract(
      Duration(days: 1),
    );

    // Clear new plan data after scheduling
    _clearNewPlanDataAfterSave();

    // TODO: API call
    /*
    await ApiService.updatePlan(
      action: 'replace_on_date',
      file: newPlanFile.value,
      startDate: newPlanStartDate.value,
    );
    */

    debugPrint('✅ Action: Replace on ${formatDate(newPlanStartDate.value!)}');
  }

  /// Save: Start on date (after current ends, current repeats until then)
  void _saveStartOnDate() {
    String newName = _extractPlanName();

    // Schedule next plan
    nextPlanName.value = newName;
    nextPlanStartDate.value = newPlanStartDate.value;

    // Clear new plan data after scheduling
    _clearNewPlanDataAfterSave();

    // TODO: API call
    /*
    await ApiService.updatePlan(
      action: 'start_on_date',
      file: newPlanFile.value,
      startDate: newPlanStartDate.value,
      repeatUntil: true, // Current plan repeats daily until new plan starts
    );
    */

    debugPrint(
      '✅ Action: New plan starts on ${formatDate(newPlanStartDate.value!)} (current repeats until then)',
    );
  }

  /// Extract plan name from file
  String _extractPlanName() {
    return newPlanFileName.value
        .replaceAll('.pdf', '')
        .replaceAll('.jpg', '')
        .replaceAll('.png', '')
        .replaceAll('.jpeg', '')
        .replaceAll('...', '');
  }

  /// Clear new plan data after successful save
  void _clearNewPlanDataAfterSave() {
    newPlanFile.value = null;
    newPlanFileName.value = '';
    newPlanStartDate.value = null;
    repeatCurrentPlan.value = true;
  }

  /// Restore previous plan (after immediate replacement)
  void restorePreviousPlan() {
    if (!hasPreviousPlan.value) return;

    // Swap current and previous
    final tempName = currentPlanName.value;
    final tempStartDate = currentPlanStartDate.value;
    final tempEndDate = currentPlanEndDate.value;

    currentPlanName.value = previousPlanName.value;
    currentPlanStartDate.value = previousPlanStartDate.value!;
    currentPlanEndDate.value = previousPlanEndDate.value!;

    previousPlanName.value = tempName;
    previousPlanStartDate.value = tempStartDate;
    previousPlanEndDate.value = tempEndDate;

    // TODO: API call
    /*
    await ApiService.restorePreviousPlan();
    */

    Get.snackbar(
      'Success',
      'Previous plan restored successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// Clear previous plan permanently
  void clearPreviousPlan() {
    previousPlanName.value = '';
    previousPlanStartDate.value = null;
    previousPlanEndDate.value = null;
    hasPreviousPlan.value = false;
  }

  /// Navigate to manage plan bottom sheet
  void navigateToManagePlan() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ManageYourPlan(),
    );
  }

  // ==========================================
  // ========== EXISTING METHODS =============
  // ==========================================

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
}

// ==========================================
// ============== MODELS ===================
// ==========================================

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
