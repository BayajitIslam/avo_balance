// meal_summary_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/meal_summary_controller.dart';
import 'package:template/features/main_screen/screens/diet/rebalancing_screen.dart';
import 'package:template/features/main_screen/widgets/action_button.dart';
import 'package:template/features/main_screen/widgets/bottom_sheet/replace_meal_bottom_sheet.dart';
import 'package:template/features/main_screen/widgets/multi_segment_circular_progress.dart';

class MealSummaryScreen extends StatelessWidget {
  final File imageFile;

  const MealSummaryScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(MealSummaryController());
    controller.initializeWithImage(imageFile);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.updateCurrentPage,
          itemCount: controller.uploadedImages.length,
          itemBuilder: (context, index) {
            return _buildMealPage(controller, index);
          },
        ),
      ),
    );
  }

  Widget _buildMealPage(MealSummaryController controller, int index) {
    final imageFile = controller.uploadedImages[index];

    return Obx(() {
      final pageState = controller.mealStates[index];

      return Stack(
        children: [
          // Background Image
          Positioned.fill(child: Image.file(imageFile, fit: BoxFit.cover)),

          // Dynamic Dark Overlay
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 50),
              color: Colors.black.withOpacity(
                controller.calculateOverlayOpacity(pageState.sheetPosition),
              ),
            ),
          ),

          // Upload Another Image Button
          Positioned(
            top: 350.h,
            left: 25.w,
            child: InkWell(
              onTap: controller.uploadAnotherImage,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xCCFFFFFF),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  "assets/icons/fluent_image-add-20-regular.svg",
                ),
              ),
            ),
          ),

          // Draggable Bottom Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              controller.updateSheetPosition(index, notification.extent);
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),

                      // Scrollable Content
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          children: [
                            _buildHeader(controller, index),
                            SizedBox(height: 8.h),
                            _buildDotsIndicator(controller),
                            SizedBox(height: 20.h),
                            _buildMainItem(controller, index, pageState),
                            SizedBox(height: 16.h),
                            _buildDetectedItems(),
                            SizedBox(height: 16.h),
                            _buildWarning(),
                            SizedBox(height: 20.h),
                            _buildImproveAccuracy(controller, index, pageState),
                            SizedBox(height: 20.h),
                            _buildActionButtons(controller, index),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeader(MealSummaryController controller, int pageIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          child: Icon(Icons.close, size: 20.sp, color: Colors.transparent),
        ),
        Text(
          'Meal Summary',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        InkWell(
          onTap: () {
            Get.delete<MealSummaryController>();
            Get.back();
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 20.sp, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildDotsIndicator(MealSummaryController controller) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.uploadedImages.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: index == controller.currentPage.value ? 24.w : 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: index == controller.currentPage.value
                  ? Color(0xFFFB2C36)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainItem(
    MealSummaryController controller,
    int pageIndex,
    MealPageState pageState,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Hamburger and fries',
          style: AppTextStyles.s22w7i(
            fontweight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
        Spacer(),
        ClipRect(
          clipBehavior: Clip.none,
          child: Align(
            alignment: Alignment.centerLeft,
            child: MultiSegmentCircularProgress(
              size: 100,
              totalCalories: 820,
              segments: pageState.nutritionSegments,
              selectedIndex: pageState.selectedNutritionIndex,
              onSegmentChange: (index) {
                controller.updateNutritionSelection(pageIndex, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetectedItems() {
    final items = [
      FoodItem(
        name: 'Rice',
        calories: 330,
        color: Color(0xFF10B981),
        weight: 150,
      ),
      FoodItem(
        name: 'Nuts',
        calories: 330,
        color: Color(0xFFF59E0B),
        weight: 50,
      ),
      FoodItem(
        name: 'Oatmeal',
        calories: 330,
        color: Color(0xFF8B5CF6),
        weight: 100,
      ),
      FoodItem(
        name: 'Beef',
        calories: 330,
        color: Color(0xFFEF4444),
        weight: 120,
      ),
    ];

    return Column(
      children: items.map((item) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xCCF9FAFB),
            borderRadius: BorderRadius.circular(16.r),
          ),
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          child: Row(
            children: [
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  item.name,
                  style: AppTextStyles.s14w4i(
                    fontweight: FontWeight.w700,
                    fontSize: 15.sp,
                    color: AppColors.black,
                  ),
                ),
              ),
              if (item.weight != null && item.weight! > 0)
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Text(
                    '${item.weight}g',
                    style: AppTextStyles.s14w4i(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              if (item.calories > 0)
                Container(
                  width: 47.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D294), Color(0xFF00C1A2)],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.calories}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWarning() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFFFDE68A), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18.sp, color: Color(0xFFF59E0B)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Detected multiple items in this meal.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImproveAccuracy(
    MealSummaryController controller,
    int pageIndex,
    MealPageState pageState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Improve Accuracy (Optional)',
          style: AppTextStyles.s16w5i(fontweight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Text(
          'Add ingredients the AI couldn\'t see (e.g. oil, sauces, toppings).',
          style: AppTextStyles.s14w4i(fontSize: 11.sp),
        ),
        SizedBox(height: 16.h),

        if (pageState.showIngredientInput)
          Column(
            children: [
              TextField(
                controller: pageState.ingredientController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type the ingredient',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.border, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.addIngredient(pageIndex);
                  }
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),

        if (pageState.additionalItems.isNotEmpty) ...[
          ...pageState.additionalItems.map((item) {
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Color(0xFFE2E8F0), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 16.sp,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item['name']!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${item['calories']} kcal',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () => controller.removeIngredient(pageIndex, item),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.h),
        ],

        InkWell(
          onTap: () {
            if (pageState.showIngredientInput) {
              if (pageState.ingredientController.text.trim().isNotEmpty) {
                controller.addIngredient(pageIndex);
              } else {
                controller.toggleIngredientInput(pageIndex);
              }
            } else {
              controller.toggleIngredientInput(pageIndex);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: pageState.showIngredientInput
                  ? Colors.white
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18.sp, color: Color(0xFF64748B)),
                SizedBox(width: 8.w),
                Text(
                  pageState.showIngredientInput
                      ? 'Add another...'
                      : 'Add an item...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (pageState.showIngredientInput &&
            pageState.additionalItems.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: InkWell(
              onTap: () => controller.closeIngredientInput(pageIndex),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Color(0xFF10B981), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: 18.sp, color: Color(0xFF10B981)),
                    SizedBox(width: 8.w),
                    Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(MealSummaryController controller, int pageIndex) {
    return Obx(
      () => Column(
        children: [
          ActionButton(
            onTap: () {
              Get.delete<MealSummaryController>();
              Get.off(
                () => RebalancingScreen(action: 'add_extra'),
                transition: Transition.fadeIn,
              );
            },
            gradient: AppColors.transparentGradiant,
            leftIcon: "assets/icons/add.png",
            leftIconbgColor: AppColors.secondaryGradient,
            rightIcon: Icons.arrow_forward,
            title: controller.uploadedImages.length > 1
                ? 'Add All Meals as Extra'
                : 'Add all as Extra',
            titleColor: AppColors.black,
            rightIconbgColor: const Color(0xFFF3F4F6),
            descFontSize: 10,
            desc: "Add this meal without replacing anything.",
            descColor: const Color(0xFF4A5565),
            rightIconColor: AppColors.black,
            borderEnbale: true,
          ),
          SizedBox(height: 16.h),
          ActionButton(
            isSvg: true,
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) =>
                    ReplaceMealBottomSheet(initialMealType: "Breakfast"),
              );
            },
            leftIcon: "assets/icons/tabler_replace.svg",
            title: "Replace a Meal",
            leftIconbgColor: AppColors.transparentGradiant,
            rightIcon: Icons.arrow_forward,
            rightIconbgColor: AppColors.white.withOpacity(0.20),
            desc: "",
            descColor: const Color(0xFFffffff).withOpacity(0.8),
            rightIconColor: AppColors.white,
            iconBorderEnable: true,
            shadowOn: true,
          ),
        ],
      ),
    );
  }
}

class FoodItem {
  final String name;
  final int calories;
  final Color color;
  final int? weight;

  FoodItem({
    required this.name,
    required this.calories,
    required this.color,
    this.weight,
  });
}
