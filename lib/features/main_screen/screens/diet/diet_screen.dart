import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/diet_controller.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:intl/intl.dart';
import 'package:template/features/main_screen/widgets/action_button.dart';
import 'package:template/features/main_screen/widgets/build_empty_meal_card.dart';
import 'package:template/features/main_screen/widgets/multi_segment_circular_progress.dart';
import 'package:template/routes/routes_name.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    navController.setCurrentPage(1);
    final dietController = Get.find<DietController>();

    return MainScreen(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(dietController),
                GetBuilder<DietController>(
                  builder: (controller) {
                    return _buildCalendar(controller);
                  },
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: GetBuilder<DietController>(
                    builder: (controller) {
                      if (!controller.hasDietPlan.value) {
                        return _buildNoDietPlanState(controller);
                      }

                      return _buildMealsList(controller);
                    },
                  ),
                ),
              ],
            ),
            Obx(() {
              if (dietController.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Loading...',
                          style: AppTextStyles.s16w5i(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // Header with Month Selector
  Widget _buildHeader(DietController controller) {
    return GetBuilder<DietController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsetsGeometry.only(
            left: 18,
            right: 20,
            top: 20,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your diet plan',
                    style: AppTextStyles.s16w5i(fontSize: 20),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      //Nutrition Plan –
                      Text(
                        'Nutrition Plan – ',
                        style: AppTextStyles.s14w4i(
                          color: const Color(0xFF9b9e9d),
                        ),
                      ),

                      // IconButton(
                      //   icon: Icon(Icons.chevron_left, size: 20.sp),
                      //   padding: EdgeInsets.zero,
                      //   constraints: BoxConstraints(),
                      //   onPressed: controller.previousMonth,
                      // ),
                      Text(
                        DateFormat(
                          'MMMM yyyy',
                        ).format(controller.currentMonth.value),
                        style: AppTextStyles.s14w4i(color: AppColors.brand),
                      ),

                      // IconButton(
                      //   icon: Icon(Icons.chevron_right, size: 20.sp),
                      //   padding: EdgeInsets.zero,
                      //   constraints: BoxConstraints(),
                      //   onPressed: controller.nextMonth,
                      // ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.black,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      // Register the NavigationController lazily using a builder function
                      NavigationController controller =
                          Get.find<NavigationController>();

                      controller.clearSelection();
                      Get.toNamed(RoutesName.trackingScreen);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.black,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      // Register the NavigationController lazily using a builder function
                      NavigationController controller =
                          Get.find<NavigationController>();

                      controller.clearSelection();
                      Get.toNamed(RoutesName.shoppingList);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Calendar with Auto Scroll to Today
  Widget _buildCalendar(DietController controller) {
    List<DateTime> daysInMonth = controller.getDaysInMonth();

    // Find today's index
    int todayIndex = 0;
    DateTime now = DateTime.now();

    for (int i = 0; i < daysInMonth.length; i++) {
      if (daysInMonth[i].day == now.day &&
          daysInMonth[i].month == now.month &&
          daysInMonth[i].year == now.year) {
        todayIndex = i;
        break;
      }
    }

    // Create ScrollController and scroll to today
    final scrollController = ScrollController();

    // Auto scroll to today after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        // Calculate scroll position (center today in view)
        double itemWidth = 64.w; // 50.w width + 12.w margin
        double viewportWidth = Get.width;
        double targetScroll =
            (todayIndex * itemWidth) - (viewportWidth / 2) + (itemWidth / 2);

        // Ensure scroll position is within bounds
        targetScroll = targetScroll.clamp(
          0.0,
          scrollController.position.maxScrollExtent,
        );

        scrollController.animateTo(
          targetScroll,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: daysInMonth.length,
        itemBuilder: (context, index) {
          DateTime date = daysInMonth[index];
          bool isSelected =
              controller.selectedDate.value.day == date.day &&
              controller.selectedDate.value.month == date.month &&
              controller.selectedDate.value.year == date.year;
          //TODO      Has Data
          // ignore: unused_local_variable
          bool hasData = controller.hasDataForDate(date);
          bool isToday =
              date.day == now.day &&
              date.month == now.month &&
              date.year == now.year;

          return GestureDetector(
            onTap: () => controller.selectDate(date),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 64.w,
              decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0x4D00BC7D),
                          blurRadius: 15,
                          offset: Offset(0, 10),
                          spreadRadius: -3,
                          blurStyle: BlurStyle.inner,
                        ),
                      ]
                    : null,
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: isToday && !isSelected
                    ? Border.all(color: AppColors.brand, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: AppTextStyles.s14w4i(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontweight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    DateFormat('E').format(date).substring(0, 3),
                    style: AppTextStyles.s14w4i(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // State 1: No Diet Plan (Upload Prescription)
  Widget _buildNoDietPlanState(DietController controller) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        BuildEmptyMealCard(
          borderGradient: [Color(0xFFFF8904), Color(0xFFF6339A)],
          onTap: () => controller.openCamara('Breakfast'),
          mealType: 'Breakfast',
        ),
        SizedBox(height: 16.h),
        BuildEmptyMealCard(
          borderGradient: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
          onTap: () => controller.openCamara('Lunch'),
          mealType: "Lunch",
        ),

        SizedBox(height: 16.h),
        BuildEmptyMealCard(
          borderGradient: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
          onTap: () => controller.openCamara('Dinner'),
          mealType: "Dinner",
        ),
        SizedBox(height: 20.h),
        _buildActionButtons(controller),
        SizedBox(height: 80.h),
      ],
    );
  }

  // In diet_screen.dart - Update all method calls:

  Widget _buildMealsList(DietController controller) {
    DayMealPlan? dayPlan = controller.getCurrentDayPlan();

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        // Daily Goal Card
        if (dayPlan != null) _buildDailyGoalCard(2000, dayPlan.totalCalories),
        if (dayPlan != null) SizedBox(height: 20.h),

        // Breakfast
        if (dayPlan?.breakfast != null)
          _buildExpandableMealSection(
            controller,
            'breakfast',
            dayPlan!.breakfast!.name,
            'TRACKED',
            dayPlan.breakfast!.totalCalories,
            dayPlan.breakfast!, // Pass whole MealData
            "Planned",
            true,
          )
        else
          BuildEmptyMealCard(
            borderGradient: [Color(0xFFFF8904), Color(0xFFF6339A)],
            onTap: () => controller.openCamara('Breakfast'),
            mealType: 'Breakfast',
          ),

        SizedBox(height: 16.h),

        // Lunch
        if (dayPlan?.lunch != null)
          _buildExpandableMealSection(
            controller,
            'lunch',
            dayPlan!.lunch!.name,
            'TRACKED',
            dayPlan.lunch!.totalCalories,
            dayPlan.lunch!, // Pass whole MealData
            "Rebalance",
            false,
          )
        else
          BuildEmptyMealCard(
            borderGradient: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
            onTap: () => controller.openCamara('Lunch'),
            mealType: "Lunch",
          ),

        SizedBox(height: 16.h),

        // Dinner
        if (dayPlan?.dinner != null)
          _buildExpandableMealSection(
            controller,
            'dinner',
            dayPlan!.dinner!.name,
            'NOT TRACKED',
            dayPlan.dinner!.totalCalories,
            dayPlan.dinner!, // Pass whole MealData
            "CheatMeal",
            false,
            isNotTracked: true,
          )
        else
          BuildEmptyMealCard(
            borderGradient: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
            onTap: () => controller.openCamara('Dinner'),
            mealType: "Dinner",
          ),

        SizedBox(height: 20.h),
        _buildActionButtons(controller),
        SizedBox(height: 80.h),
      ],
    );
  }

  //Daily Goal Card Show On Top
  Widget _buildDailyGoalCard(int total, int consumed) {
    double percentage = (consumed / total * 100).clamp(0, 100);
    int adjusted = 109;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [Color(0xFF00D096), Color(0xFF01C0A4), Color(0xFF9BD6A4)],
          ),
        ),
        padding: EdgeInsets.all(4),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon and Title
                    Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00D095), Color(0xFF00BEA4)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset("assets/icons/flash_avo.png"),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Goal',
                              style: AppTextStyles.s18w5i(
                                fontweight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset("assets/icons/Rebalanced.png"),
                                SizedBox(width: 4.w),
                                Text(
                                  'Rebalanced',
                                  style: AppTextStyles.s14w4i(
                                    fontSize: 12.sp,
                                    fontweight: FontWeight.w700,
                                    color: const Color(0xFF6A7282),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 11.h),

                    // Calories with Gradient
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Color(0xFF00D195),
                              Color(0xFF00C0A2),
                              Color(0xFF92D39B),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            total.toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            ),
                            style: AppTextStyles.s30w8i(
                              fontSize: 40,
                              fontweight: FontWeight.w900,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'kcal',
                          style: AppTextStyles.s18w5i(
                            fontweight: FontWeight.w700,
                            color: AppColors.brand,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'Adjusted from Sundays cheat meal',
                      style: AppTextStyles.s14w4i(
                        fontSize: 13.sp,
                        color: const Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Right Side
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Progress Circle
                  SizedBox(
                    width: 70.w,
                    height: 70.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                        ),
                        SizedBox(
                          width: 61.w,
                          height: 61.w,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 6,
                            backgroundColor: const Color(0xFFDBDBDB),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.brand,
                            ),
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xFF00BFA5), Color(0xFF00E676)],
                          ).createShader(bounds),
                          child: Text(
                            '${percentage.toInt()}%',
                            style: AppTextStyles.s16w5i(
                              fontweight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Adjusted Badge
                  Container(
                    width: 66.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00D294), Color(0xFF00C1A2)],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0X1A00D195),
                          blurRadius: 6,
                          spreadRadius: -4,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$adjusted',
                          style: AppTextStyles.s18w5i(
                            fontweight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Adjusted',
                          style: AppTextStyles.s22w7i(
                            fontSize: 10,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //If  Plan Availabel
  // In diet_screen.dart, replace _buildExpandableMealSection with this:

  Widget _buildExpandableMealSection(
    DietController controller,
    String mealId,
    String title,
    String status,
    int totalCalories,
    MealData mealData,
    String mealMode,
    bool hasWarning, {
    bool isNotTracked = false,
  }) {
    Color badgeColor = isNotTracked ? const Color(0xFFFF6504) : AppColors.brand;
    String badgeText = isNotTracked ? 'NOT TRACKED' : status;
    Color mealModeColor;
    String displayMealMode;

    switch (mealMode) {
      case "Planned":
        mealModeColor = AppColors.brand;
        displayMealMode = "Planned";
        break;
      case "Rebalance":
        mealModeColor = const Color(0xFFFF6504);
        displayMealMode = "Rebalance";
        break;
      case "CheatMeal":
        mealModeColor = const Color(0xFFF82F68);
        displayMealMode = "Cheat Meal";
        break;
      default:
        mealModeColor = Colors.transparent;
        displayMealMode = "Unknown";
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: -6,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: -5,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left gradient border
          Positioned(
            left: 0.w,
            top: 29.h,
            bottom: 29.h,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _getMealGradientColors(title),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(33554400),
                  bottomRight: Radius.circular(33554400),
                ),
              ),
            ),
          ),

          Column(
            children: [
              InkWell(
                onTap: () => controller.toggleMealExpansion(mealId),
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 25,
                    right: 25,
                    top: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: AppTextStyles.s18w5i(
                                    fontweight: FontWeight.w900,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor,
                                    borderRadius: BorderRadius.circular(
                                      33554400.r,
                                    ),
                                  ),
                                  child: Text(
                                    badgeText,
                                    style: AppTextStyles.s22w7i(
                                      fontSize: 10,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      color: mealModeColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.black.withOpacity(
                                            0.3,
                                          ),
                                          spreadRadius: -4,
                                          blurRadius: 6,
                                          offset: Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: AppColors.black.withOpacity(
                                            0.3,
                                          ),
                                          spreadRadius: -3,
                                          blurRadius: 15,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    displayMealMode,
                                    style: AppTextStyles.s14w4i(
                                      color: AppColors.black,
                                      fontweight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),

                      // Updated MultiSegmentCircularProgress - Stateless
                      GetBuilder<DietController>(
                        builder: (ctrl) {
                          return MultiSegmentCircularProgress(
                            size: 100,
                            totalCalories: totalCalories,
                            segments: _getMealSegments(
                              mealData,
                            ), // Pass mealData
                            selectedIndex: ctrl.getNutritionSelection(mealId),
                            onSegmentChange: (index) {
                              ctrl.updateNutritionSelection(mealId, index);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Rest of expandable content stays the same
              Obx(() {
                bool isExpanded = controller.expandedMeals[mealId] ?? false;

                return AnimatedCrossFade(
                  duration: Duration(milliseconds: 300),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(
                          left: 20,
                          right: 20,
                          top: 12,
                        ),
                        child: Column(
                          children: [
                            ...mealData.items.map(
                              (item) => _buildMealItemRow(item),
                            ),
                            if (hasWarning)
                              Container(
                                margin: EdgeInsets.only(top: 16.h),
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: Color(0xFFfff6f8),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.secondaryGradient,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Image.asset(
                                        "assets/icons/warning_avo.png",
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        'The 15gm butter in your meal was off. We adjusted it to keep you on track.',
                                        style: AppTextStyles.s14w4i(
                                          fontSize: 12.sp,
                                          color: Color(0xFF364153),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.toggleMealExpansion(mealId),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColors.black,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  secondChild: InkWell(
                    onTap: () => controller.toggleMealExpansion(mealId),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                        size: 24.sp,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // In diet_screen.dart - Replace _getMealSegments:

  List<NutritionSegment> _getMealSegments(MealData mealData) {
    // Just use the percentages from model - no calculation
    return [
      NutritionSegment(
        name: 'Carbs',
        color: const Color(0xFFF7C948), // Yellow
        percentage: mealData.carbsPercentage ?? 0.33,
        grams: 0, // Not needed anymore
      ),
      NutritionSegment(
        name: 'Proteins',
        color: const Color(0xFF2D6DF6), // Blue
        percentage: mealData.proteinsPercentage ?? 0.33,
        grams: 0,
      ),
      NutritionSegment(
        name: 'Fats',
        color: const Color(0xFFF2853F), // Orange
        percentage: mealData.fatsPercentage ?? 0.34,
        grams: 0,
      ),
    ];
  }

  Widget _buildMealItemRow(MealItem item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCCF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.3),
                  spreadRadius: -4,
                  blurRadius: 6,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.black.withOpacity(0.3),
                  spreadRadius: -3,
                  blurRadius: 15,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
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
  }

  List<Color> _getMealGradientColors(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return [Color(0xFFFF8904), Color(0xFFF6339A)];
      case 'lunch':
        return [Color(0xFFC27AFF), Color(0xFF2B7FFF)];
      case 'dinner':
        return [Color(0xFFFB64B6), Color(0xFFAD46FF)];
      default:
        return [Color(0xFF00BFA5), Color(0xFF00E676)];
    }
  }

  // Action Buttons
  Widget _buildActionButtons(DietController controller) {
    return Column(
      children: [
        ActionButton(
          onTap: controller.navigateToLogCheatMeal,
          leftIcon: "assets/icons/fire.png",
          title: "Log Cheat Meal",
          leftIconbgColor: AppColors.transparentGradiant,
          rightIcon: Icons.arrow_forward,
          rightIconbgColor: AppColors.white.withOpacity(0.20),
          desc: "Add a treat and auto-rebalance",
          descColor: const Color(0xFFffffff).withOpacity(0.8),
          rightIconColor: AppColors.white,
          iconBorderEnable: true,
          shadowOn: true,
        ),
        SizedBox(height: 16.h),
        ActionButton(
          onTap: controller.navigateToManagePlan,
          gradient: AppColors.transparentGradiant,
          leftIcon: "assets/icons/add.png",
          leftIconbgColor: AppColors.secondaryGradient,
          rightIcon: Icons.arrow_forward,
          title: 'Manage Your Plan',
          titleColor: AppColors.black,
          rightIconbgColor: const Color(0xFFF3F4F6),
          desc: "Upload or renew your plan",
          descColor: const Color(0xFF4A5565),
          rightIconColor: AppColors.black,
          borderEnbale: true,
        ),
      ],
    );
  }
}
