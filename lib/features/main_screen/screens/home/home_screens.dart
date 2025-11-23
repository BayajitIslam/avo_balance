// screens/home_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/routes/routes_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              // GetBuilder<DietController>(
              //   builder: (controller) {
              //     return _buildCalendar(controller);
              //   },
              // ),
              SizedBox(height: 20.h),
              _buildTodaysBalanceCard(),
              SizedBox(height: 20.h),
              _buildProgressCards(),
              SizedBox(height: 20.h),
              _buildCongratulationsCard(),
              SizedBox(height: 20.h),
              _buildWeightProgressCard(),
              SizedBox(height: 20.h),
              _buildConsistencyBanner(),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  // Header with Month Selector
  Widget _buildHeader() {
    // return GetBuilder<DietController>(
    //   builder: (controller) {
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
              Text('Hi Bayajit !', style: AppTextStyles.s16w5i(fontSize: 20)),
              SizedBox(height: 4.h),
              Row(
                children: [
                  //Nutrition Plan –
                  Text(
                    "It's breakfast time! Have you had your breakfast yet?",
                    style: AppTextStyles.s14w4i(fontSize: 10),
                  ),

                  // IconButton(
                  //   icon: Icon(Icons.chevron_left, size: 20.sp),
                  //   padding: EdgeInsets.zero,
                  //   constraints: BoxConstraints(),
                  //   onPressed: controller.previousMonth,
                  // ),
                  // Text(
                  //   DateFormat(
                  //     'MMMM yyyy',
                  //   ).format(controller.currentMonth.value),
                  //   style: AppTextStyles.s14w4i(color: AppColors.brand),
                  // ),

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
    // },
    // );
  }

  // Today's Balance Card
  // Today's Balance Card
  Widget _buildTodaysBalanceCard() {
    double planned = 1800;
    double consumed = 1000;
    double percentage = consumed / planned;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(4), // Border width
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Image.asset("assets/icons/calander.png"),
                ),
                SizedBox(width: 9.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today\'s Balance', style: AppTextStyles.s16w5i()),
                    SizedBox(height: 1.h),
                    Text(
                      '( 150 kcal under goal )',
                      style: AppTextStyles.s14w4i(
                        fontSize: 10.sp,
                        color: AppColors.brand,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Slider
            // Slider
            Stack(
              clipBehavior: Clip.none, // Important! Allow overflow
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    height: 12.h,
                    child: Row(
                      children: [
                        // Green (Planned/Consumed)
                        Expanded(
                          flex: (percentage * 100).toInt(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.brand,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                bottomLeft: Radius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                        // Blue (Remaining)
                        Expanded(
                          flex: ((1 - percentage) * 100).toInt(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Emoji on top
                Positioned(
                  left:
                      (percentage *
                          (MediaQuery.of(Get.context!).size.width - 88.w)) -
                      12.w,
                  top: -24.h,
                  child: Text("🔥", style: TextStyle(fontSize: 30.sp)),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Planned',
                      style: AppTextStyles.s14w4i(fontSize: 12.sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '1,800 kcal',
                      style: AppTextStyles.s14w4i(
                        color: AppColors.brand,
                        fontweight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Consumed',
                      style: AppTextStyles.s14w4i(fontSize: 12.sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '1,650 kcal',
                      style: AppTextStyles.s16w5i(
                        color: const Color(0xFF2196F3),
                        fontweight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Progress Cards (Weekly & Monthly)
  Widget _buildProgressCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _buildProgressCard(
              title: 'Weekly',
              subtitle: 'Balanced days',
              percentage: 85,
              color: const Color(0xFF0095FF),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildProgressCard(
              title: 'Monthly',
              subtitle: 'Consistency',
              percentage: 85,
              color: AppColors.brand,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String subtitle,
    required int percentage,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.s30w8i(fontSize: 16)),
          SizedBox(height: 8.h),
          SizedBox(
            width: 77.w,
            height: 77.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 77.w,
                  height: 77.h,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  '⚡ $percentage%',
                  style: AppTextStyles.s12w5i(
                    fontweight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(subtitle, style: AppTextStyles.s14w4i(fontSize: 10.sp)),
        ],
      ),
    );
  }

  // Congratulations Card
  Widget _buildCongratulationsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 9,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Great job !',
                  style: AppTextStyles.s14w4i(
                    fontSize: 16,
                    fontweight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'You are stayed consistent for 4 days in a row. Keep it up!',
                  style: AppTextStyles.s12w5i(
                    fontSize: 12,
                    fontweight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Weight Progress Card
  Widget _buildWeightProgressCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDADADA),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Progress',
                style: AppTextStyles.s18w5i(
                  fontweight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  NavigationController controller =
                      Get.find<NavigationController>();

                  controller.clearSelection();
                  Get.toNamed(RoutesName.weightEntryScreen);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: AppColors.secondaryGradient,
                  ),
                  child: Text(
                    'Update',
                    style: AppTextStyles.s14w4i(
                      fontSize: 10,
                      fontweight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Chart
          SizedBox(
            height: 150.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.w,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}lbs',
                          style: AppTextStyles.s14w4i(
                            fontSize: 8,
                            fontweight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const weeks = [
                          'W1',
                          'W2',
                          'W3',
                          'W4',
                          'W5',
                          'W6',
                          'W7',
                        ];
                        if (value.toInt() < weeks.length) {
                          return Text(
                            weeks[value.toInt()],
                            style: AppTextStyles.s14w4i(
                              fontSize: 8,
                              fontweight: FontWeight.w500,
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 50,
                maxY: 90,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 70),
                      FlSpot(1, 72),
                      FlSpot(2, 65),
                      FlSpot(3, 68),
                      FlSpot(4, 64),
                      FlSpot(5, 65),
                      FlSpot(6, 80),
                    ],
                    isCurved: true,
                    color: AppColors.brand,
                    barWidth: 3,
                    curveSmoothness: 0,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0Xff0095FF),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF3CB84A), Color(0x33DBFFDF)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Current & Change
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current',
                    style: AppTextStyles.s14w4i(
                      fontSize: 10.sp,
                      fontweight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '70.8 lbs',
                    style: AppTextStyles.s18w5i(
                      fontweight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Change',
                    style: AppTextStyles.s14w4i(
                      fontSize: 10.sp,
                      fontweight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '-1.2 lbs',
                    style: AppTextStyles.s18w5i(
                      fontweight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: Color(0xFF00BFA5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Consistency Banner
  Widget _buildConsistencyBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA1A1A1),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(Icons.star, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'You have stayed consistent for 4 days.',
              style: AppTextStyles.s14w4i(
                fontSize: 12,
                fontweight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
