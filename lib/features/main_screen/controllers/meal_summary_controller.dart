import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/widgets/multi_segment_circular_progress.dart';

class MealSummaryController extends GetxController {
  // Multiple images support
  final RxList<File> uploadedImages = <File>[].obs;
  final RxInt currentPage = 0.obs;

  // Page controller
  late PageController pageController;

  // Track state for each meal
  final RxList<MealPageState> mealStates = <MealPageState>[].obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    // Dispose all text controllers
    for (var state in mealStates) {
      state.ingredientController.dispose();
    }
    super.onClose();
  }

  // Initialize with first image
  void initializeWithImage(File imageFile) {
    uploadedImages.add(imageFile);
    mealStates.add(MealPageState());
  }

  // Update current page
  void updateCurrentPage(int index) {
    currentPage.value = index;
  }

  // Update sheet position for specific page
  void updateSheetPosition(int index, double position) {
    if (index < mealStates.length) {
      mealStates[index].sheetPosition = position;
      mealStates.refresh(); // Trigger UI update
    }
  }

  // Update nutrition selection for specific page
  void updateNutritionSelection(int pageIndex, int? index) {
    if (pageIndex < mealStates.length) {
      mealStates[pageIndex].selectedNutritionIndex = index;
      mealStates.refresh();
    }
  }

  // Toggle ingredient input
  void toggleIngredientInput(int pageIndex) {
    if (pageIndex < mealStates.length) {
      mealStates[pageIndex].showIngredientInput =
          !mealStates[pageIndex].showIngredientInput;
      mealStates.refresh();
    }
  }

  // Add ingredient
  void addIngredient(int pageIndex) {
    if (pageIndex < mealStates.length) {
      final state = mealStates[pageIndex];
      if (state.ingredientController.text.trim().isNotEmpty) {
        state.additionalItems.add({
          'name': state.ingredientController.text.trim(),
          'calories': '100', // Default, will be calculated by AI
        });
        state.ingredientController.clear();
        mealStates.refresh();
      }
    }
  }

  // Remove ingredient
  void removeIngredient(int pageIndex, Map<String, String> item) {
    if (pageIndex < mealStates.length) {
      mealStates[pageIndex].additionalItems.remove(item);
      mealStates.refresh();
    }
  }

  // Close ingredient input
  void closeIngredientInput(int pageIndex) {
    if (pageIndex < mealStates.length) {
      mealStates[pageIndex].showIngredientInput = false;
      mealStates[pageIndex].ingredientController.clear();
      mealStates.refresh();
    }
  }

  // Upload another image
  Future<void> uploadAnotherImage() async {
    final result = await Get.to(
      () => CameraCaptureScreen(mealType: 'Additional Meal'),
      transition: Transition.downToUp,
    );

    if (result != null && result is File) {
      uploadedImages.add(result);
      mealStates.add(MealPageState());

      // Animate to new page
      Future.delayed(Duration(milliseconds: 100), () {
        pageController.animateToPage(
          uploadedImages.length - 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  // Calculate overlay opacity
  double calculateOverlayOpacity(double sheetPosition) {
    if (sheetPosition <= 0.5) return 0.0;
    double progress = (sheetPosition - 0.5) / (0.95 - 0.5);
    double easedProgress = progress * progress;
    return (easedProgress * 0.7).clamp(0.0, 0.7);
  }
}

// State class for each meal page
class MealPageState {
  double sheetPosition = 0.5;
  int? selectedNutritionIndex;
  bool showIngredientInput = false;
  final TextEditingController ingredientController = TextEditingController();
  final List<Map<String, String>> additionalItems = [];

  final List<NutritionSegment> nutritionSegments = [
    NutritionSegment(
      name: 'Carbs',
      color: const Color(0xFFF7C948),
      percentage: 0.33,
      grams: 113,
    ),
    NutritionSegment(
      name: 'Proteins',
      color: const Color(0xFF2D6DF6),
      percentage: 0.33,
      grams: 62,
    ),
    NutritionSegment(
      name: 'Fats',
      color: Color(0xFFF2853F),
      percentage: 0.34,
      grams: 14,
    ),
  ];
}
