// screens/diet_screen.dart
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
import 'package:template/features/main_screen/widgets/multi_segment_circular_progress.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    navController.setCurrentPage(1);

    final dietController = Get.put(DietController());

    return MainScreen(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                            'Processing your prescription...',
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.black,
                      size: 24.sp,
                    ),
                    onPressed: () {},
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
        _buildEmptyMealCard(
          'Breakfast',
          () => controller.showAddMealDialog('Breakfast'),
          [Color(0xFFFF9800), Color(0xFFFF6B6B)],
        ),
        SizedBox(height: 16.h),
        _buildEmptyMealCard(
          'Lunch',
          () => controller.showAddMealDialog('Lunch'),
          [Color(0xFF2196F3), Color(0xFF00BCD4)],
        ),
        SizedBox(height: 16.h),
        _buildEmptyMealCard(
          'Dinner',
          () => controller.showAddMealDialog('Dinner'),
          [Color(0xFF9C27B0), Color(0xFFE91E63)],
        ),
        SizedBox(height: 20.h),
        _buildActionButtons(controller),
        SizedBox(height: 80.h),
      ],
    );
  }

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
            'PLANNED',
            dayPlan.breakfast!.totalCalories,
            dayPlan.breakfast!.items,
            true, // Has warning
          )
        else
          _buildEmptyMealCard(
            'Breakfast',
            () => controller.showAddMealDialog('Breakfast'),
            [Color(0xFFFF8904), Color(0xFFF6339A)],
          ),

        SizedBox(height: 16.h),

        // Lunch
        if (dayPlan?.lunch != null)
          _buildExpandableMealSection(
            controller,
            'lunch',
            dayPlan!.lunch!.name,
            'PLANNED',
            dayPlan.lunch!.totalCalories,
            dayPlan.lunch!.items,
            false,
          )
        else
          _buildEmptyMealCard(
            'Lunch',
            () => controller.showAddMealDialog('Lunch'),
            [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
          ),

        SizedBox(height: 16.h),

        // Dinner
        if (dayPlan?.dinner != null)
          _buildExpandableMealSection(
            controller,
            'dinner',
            dayPlan!.dinner!.name,
            'LOG TODAY',
            dayPlan.dinner!.totalCalories,
            dayPlan.dinner!.items,
            false,
            // isLogToday: true,
          )
        else
          _buildEmptyMealCard(
            'Dinner',
            () => controller.showAddMealDialog('Dinner'),
            [Color(0xFFFB64B6), Color(0xFFAD46FF)],
          ),

        SizedBox(height: 20.h),
        _buildActionButtons(controller),
        SizedBox(height: 80.h),
      ],
    );
  }

  // Daily Goal Card
  // Widget _buildDailyGoalCard(int total, int consumed) {
  //   double percentage = (consumed / total * 100).clamp(0, 100);

  //   return Container(
  //     padding: EdgeInsets.all(20.w),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Color(0xFF00BFA5), Color(0xFF00E676)],
  //       ),
  //       borderRadius: BorderRadius.circular(20.r),
  //     ),
  //     child: Row(
  //       children: [
  //         // Progress Circle
  //         SizedBox(
  //           width: 70.w,
  //           height: 70.w,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               SizedBox(
  //                 width: 70.w,
  //                 height: 70.w,
  //                 child: CircularProgressIndicator(
  //                   value: percentage / 100,
  //                   strokeWidth: 6,
  //                   backgroundColor: Colors.white.withOpacity(0.3),
  //                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //                 ),
  //               ),
  //               Text(
  //                 '${percentage.toInt()}%',
  //                 style: AppTextStyles.s18w5i(
  //                   color: AppColors.white,
  //                   fontweight: FontWeight.w700,
  //                   fontSize: 16.sp,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         SizedBox(width: 16.w),

  //         // Info
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Text(
  //                     'Daily Goal',
  //                     style: AppTextStyles.s14w4i(
  //                       color: AppColors.white,
  //                       fontweight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   SizedBox(width: 6.w),
  //                   Container(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 8.w,
  //                       vertical: 3.h,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white.withOpacity(0.3),
  //                       borderRadius: BorderRadius.circular(10.r),
  //                     ),
  //                     child: Text(
  //                       'Rebalanced',
  //                       style: AppTextStyles.s14w4i(
  //                         color: AppColors.white,
  //                         fontSize: 9.sp,
  //                         fontweight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 4.h),
  //               Text(
  //                 '$total kcal',
  //                 style: AppTextStyles.s22w7i(
  //                   color: AppColors.white,
  //                   fontSize: 28.sp,
  //                 ),
  //               ),
  //               SizedBox(height: 4.h),
  //               Text(
  //                 'Adjusted from Sunday\'s cheat\nmeal',
  //                 style: AppTextStyles.s14w4i(
  //                   color: AppColors.white.withOpacity(0.9),
  //                   fontSize: 10.sp,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         // Consumed Badge
  //         Container(
  //           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(15.r),
  //           ),
  //           child: Text(
  //             '$consumed',
  //             style: AppTextStyles.s16w5i(
  //               color: AppColors.brand,
  //               fontweight: FontWeight.w700,
  //               fontSize: 14.sp,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDailyGoalCard(int total, int consumed) {
    double percentage = (consumed / total * 100).clamp(0, 100);
    int adjusted = 109;

    return Container(
      child: ClipRRect(
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
      ),
    );
  }

  // // Expandable Meal Section
  // Widget _buildExpandableMealSection(
  //   DietController controller,
  //   String mealId,
  //   String title,
  //   String status,
  //   int totalCalories,
  //   List<MealItem> items,
  //   bool hasWarning, {
  //   bool isLogToday = false,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(16.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         // Header
  //         InkWell(
  //           onTap: () => controller.toggleMealExpansion(mealId),
  //           child: Padding(
  //             padding: EdgeInsets.all(16.w),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         title,
  //                         style: AppTextStyles.s18w5i(
  //                           fontweight: FontWeight.w700,
  //                         ),
  //                       ),
  //                       SizedBox(width: 8.w),
  //                       Container(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 8.w,
  //                           vertical: 4.h,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: isLogToday
  //                               ? Color(0xFFFF9800)
  //                               : Color(0xFF00BFA5),
  //                           borderRadius: BorderRadius.circular(10.r),
  //                         ),
  //                         child: Text(
  //                           status,
  //                           style: AppTextStyles.s14w4i(
  //                             color: AppColors.white,
  //                             fontSize: 9.sp,
  //                             fontweight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 50.w,
  //                   height: 50.w,
  //                   child: Stack(
  //                     alignment: Alignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 50.w,
  //                         height: 50.w,
  //                         child: CircularProgressIndicator(
  //                           value: 0.7,
  //                           strokeWidth: 4,
  //                           backgroundColor: const Color(
  //                             0xFFE91E63,
  //                           ).withOpacity(0.2),
  //                           valueColor: AlwaysStoppedAnimation<Color>(
  //                             const Color(0xFFE91E63),
  //                           ),
  //                         ),
  //                       ),
  //                       Text(
  //                         '$totalCalories',
  //                         style: AppTextStyles.s14w4i(
  //                           color: const Color(0xFFE91E63),
  //                           fontweight: FontWeight.w700,
  //                           fontSize: 13.sp,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),

  //         // Expandable Content
  //         Obx(() {
  //           bool isExpanded = controller.expandedMeals[mealId] ?? true;

  //           return AnimatedCrossFade(
  //             duration: Duration(milliseconds: 300),
  //             crossFadeState: isExpanded
  //                 ? CrossFadeState.showFirst
  //                 : CrossFadeState.showSecond,
  //             firstChild: Column(
  //               children: [
  //                 Divider(height: 1, color: Colors.grey.shade200),
  //                 Padding(
  //                   padding: EdgeInsets.all(16.w),
  //                   child: Column(
  //                     children: [
  //                       ...items.map((item) => _buildMealItem(item)).toList(),

  //                       if (hasWarning)
  //                         Container(
  //                           margin: EdgeInsets.only(top: 12.h),
  //                           padding: EdgeInsets.all(12.w),
  //                           decoration: BoxDecoration(
  //                             color: Color(0xFFFFF3E0),
  //                             borderRadius: BorderRadius.circular(12.r),
  //                             border: Border.all(color: Color(0xFFFFB74D)),
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Container(
  //                                 padding: EdgeInsets.all(6.w),
  //                                 decoration: BoxDecoration(
  //                                   color: Color(0xFFFF9800),
  //                                   shape: BoxShape.circle,
  //                                 ),
  //                                 child: Icon(
  //                                   Icons.warning_rounded,
  //                                   color: Colors.white,
  //                                   size: 14.sp,
  //                                 ),
  //                               ),
  //                               SizedBox(width: 10.w),
  //                               Expanded(
  //                                 child: Text(
  //                                   'The 15gm butter in your meal was off. We adjusted it to keep you on track.',
  //                                   style: AppTextStyles.s14w4i(
  //                                     fontSize: 11.sp,
  //                                     color: Color(0xFFE65100),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () => controller.toggleMealExpansion(mealId),
  //                   child: Container(
  //                     padding: EdgeInsets.symmetric(vertical: 8.h),
  //                     decoration: BoxDecoration(
  //                       border: Border(
  //                         top: BorderSide(color: Colors.grey.shade200),
  //                       ),
  //                     ),
  //                     child: Icon(
  //                       Icons.keyboard_arrow_up,
  //                       color: Colors.grey,
  //                       size: 20.sp,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             secondChild: InkWell(
  //               onTap: () => controller.toggleMealExpansion(mealId),
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(vertical: 8.h),
  //                 decoration: BoxDecoration(
  //                   border: Border(
  //                     top: BorderSide(color: Colors.grey.shade200),
  //                   ),
  //                 ),
  //                 child: Icon(
  //                   Icons.keyboard_arrow_down,
  //                   color: Colors.grey,
  //                   size: 20.sp,
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildExpandableMealSection(
    DietController controller,
    String mealId,
    String title,
    String status,
    int totalCalories,
    List<MealItem> items,
    bool hasWarning, {
    bool isHotTracked = false,
    bool isRebalanced = false,
    bool isCheatMeal = false,
  }) {
    Color badgeColor = isHotTracked ? Color(0xFFFF6B6B) : Color(0xFF00BFA5);
    String badgeText = isHotTracked ? 'HOT TRACKED' : status;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.toggleMealExpansion(mealId),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _getMealGradientColors(title),
                                ),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              title,
                              style: AppTextStyles.s18w5i(
                                fontweight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                badgeText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isRebalanced || isCheatMeal)
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, top: 10.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: isRebalanced
                                        ? Color(0xFFFF9800)
                                        : Color(0xFFE91E63),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  isRebalanced ? 'Rebalanced' : 'Cheat meal',
                                  style: AppTextStyles.s14w4i(
                                    fontSize: 13.sp,
                                    color: isRebalanced
                                        ? Color(0xFFFF9800)
                                        : Colors.grey.shade700,
                                    fontweight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  MultiSegmentCircularProgress(
                    size: 70,
                    totalCalories: totalCalories,
                    segments: _getMealSegments(items),
                  ),
                ],
              ),
            ),
          ),
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
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(height: 1, color: Colors.grey.shade200),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        ...items.map((item) => _buildMealItemRow(item)),
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
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.grey.shade600,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
              secondChild: InkWell(
                onTap: () => controller.toggleMealExpansion(mealId),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  ),
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
    );
  }

  Widget _buildMealItemRow(MealItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              item.name,
              style: AppTextStyles.s14w4i(
                fontweight: FontWeight.w600,
                fontSize: 15.sp,
                color: Color(0xFF101828),
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

  // Helper Methods
  List<MealSegment> _getMealSegments(List<MealItem> items) {
    final itemsWithCalories = items.where((item) => item.calories > 0).toList();

    if (itemsWithCalories.isEmpty) {
      return [MealSegment(color: Colors.grey.shade300, percentage: 1.0)];
    }

    int totalCalories = itemsWithCalories.fold(
      0,
      (sum, item) => sum + item.calories,
    );

    return itemsWithCalories.map((item) {
      double percentage = item.calories / totalCalories;
      return MealSegment(color: item.color, percentage: percentage);
    }).toList();
  }

  List<Color> _getMealGradientColors(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return [Color(0xFF9C27B0), Color(0xFFE91E63)];
      case 'lunch':
        return [Color(0xFFFF9800), Color(0xFFFFB74D)];
      case 'dinner':
        return [Color(0xFFE91E63), Color(0xFFFF6B9D)];
      default:
        return [Color(0xFF00BFA5), Color(0xFF00E676)];
    }
  }

  // // Meal Item Row
  // Widget _buildMealItemRow(MealItem item) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 12.h),
  //     child: Row(
  //       children: [
  //         // Colored Dot
  //         Container(
  //           width: 10.w,
  //           height: 10.w,
  //           decoration: BoxDecoration(
  //             color: item.color ?? Color(0xFF00BFA5),
  //             shape: BoxShape.circle,
  //           ),
  //         ),

  //         SizedBox(width: 12.w),

  //         // Item Name
  //         Expanded(
  //           child: Text(
  //             item.name,
  //             style: AppTextStyles.s14w4i(fontweight: FontWeight.w600),
  //           ),
  //         ),

  //         // Weight
  //         if (item.weight != null)
  //           Text(
  //             '${item.weight}g',
  //             style: AppTextStyles.s14w4i(fontSize: 12.sp, color: Colors.grey),
  //           ),

  //         SizedBox(width: 12.w),

  //         // Calorie Badge
  //         if (item.calories > 0)
  //           Container(
  //             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [Color(0xFF00BFA5), Color(0xFF00E676)],
  //               ),
  //               borderRadius: BorderRadius.circular(12.r),
  //             ),
  //             child: Column(
  //               children: [
  //                 Text(
  //                   '${item.calories}',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 Text(
  //                   'kcal',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 8.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // // Get Meal Gradient Colors
  // List<Color> _getMealGradient(String mealType) {
  //   if (mealType == 'Breakfast') {
  //     return [Color(0xFF9C27B0), Color(0xFFE91E63)]; // Purple to Pink
  //   } else if (mealType == 'Lunch') {
  //     return [Color(0xFFFF9800), Color(0xFFFFB74D)]; // Orange
  //   } else if (mealType == 'Dinner') {
  //     return [Color(0xFFE91E63), Color(0xFFFF6B9D)]; // Pink
  //   }
  //   return [Color(0xFF00BFA5), Color(0xFF00E676)]; // Default Green
  // }

  // // Meal Item
  // Widget _buildMealItem(MealItem item) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 10.h),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 8.w,
  //           height: 8.w,
  //           decoration: BoxDecoration(
  //             color: _getMealItemColor(item.name),
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //         SizedBox(width: 12.w),
  //         Expanded(
  //           child: Text(
  //             item.name,
  //             style: AppTextStyles.s14w4i(fontweight: FontWeight.w500),
  //           ),
  //         ),
  //         if (item.calories > 0)
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               if (item.name.contains('g'))
  //                 Padding(
  //                   padding: EdgeInsets.only(right: 8.w),
  //                   child: Text(
  //                     item.name.split(' ').last,
  //                     style: AppTextStyles.s14w4i(
  //                       fontSize: 12.sp,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 10.w,
  //                   vertical: 5.h,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.brand,
  //                   borderRadius: BorderRadius.circular(12.r),
  //                 ),
  //                 child: Text(
  //                   '${item.calories}',
  //                   style: AppTextStyles.s14w4i(
  //                     color: AppColors.white,
  //                     fontSize: 11.sp,
  //                     fontweight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // Color _getMealItemColor(String itemName) {
  //   if (itemName.contains('Planned')) return Color(0xFF00BFA5);
  //   if (itemName.contains('Oatmeal')) return Color(0xFFE91E63);
  //   if (itemName.contains('Rice')) return Color(0xFF9C27B0);
  //   if (itemName.contains('Butter')) return Color(0xFF00BCD4);
  //   if (itemName.contains('Meat')) return Color(0xFF00BFA5);
  //   if (itemName.contains('Restaurant')) return Color(0xFFE91E63);
  //   if (itemName.contains('Cheat')) return Color(0xFFE91E63);
  //   return Color(0xFF00BFA5);
  // }

  //empty meal card
  Widget _buildEmptyMealCard(
    String mealType,
    VoidCallback onTap,
    List<Color> borderGradient,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 124.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 8),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Left gradient border
            Positioned(
              left: -24.w,
              top: 14,
              bottom: 14,
              child: Container(
                width: 4.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: borderGradient,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(33554400),
                    bottomRight: Radius.circular(33554400),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    mealType,
                    style: AppTextStyles.s22w7i(
                      fontweight: FontWeight.w900,
                      fontSize: 20.sp,
                    ),
                  ),

                  // Add button with text
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: AppColors.container,
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: const Color(0xFFAD46FF).withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: -4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          'Upload Your Free Meal',
                          style: AppTextStyles.s16w5i(
                            color: const Color(0xFFB9B9B9),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(DietController controller) {
    return Column(
      children: [
        ActionButton(
          onTap: controller.navigateToLogCheatMeal,
          leftIcon: "assets/icons/flip.png",
          title: "Log Cheat Meal",
          leftIconbgColor: AppColors.transparentGradiant,
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
          leftIcon: "assets/icons/flip.png",
          leftIconbgColor: AppColors.secondaryGradient,
          title: 'Manage Your Plan',
          titleColor: AppColors.black,
          rightIconbgColor: const Color(0xFFF3F4F6),
          desc: "Upload or renew your plan",
          descColor: const Color(0xFF4A5565),
          rightIconColor: const Color(0xFF364153),
          borderEnbale: true,
        ),
      ],
    );
  }
}
