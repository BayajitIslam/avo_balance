// widgets/bottom_sheet/replace_meal_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/diet/rebalancing_screen.dart';

class ReplaceMealBottomSheet extends StatefulWidget {
  final String initialMealType;

  const ReplaceMealBottomSheet({super.key, required this.initialMealType});

  @override
  State<ReplaceMealBottomSheet> createState() => _ReplaceMealBottomSheetState();
}

class _ReplaceMealBottomSheetState extends State<ReplaceMealBottomSheet> {
  late String selectedMeal;
  final TextEditingController detailsController = TextEditingController();

  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    selectedMeal = widget.initialMealType;
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  void _handleMealSelection(String meal) {
    // Close bottom sheet
    Navigator.pop(context);

    // Close meal summary screen
    Navigator.pop(context);

    // Navigate to rebalancing screen immediately
    Get.to(
      () => RebalancingScreen(action: 'replace_meal', mealType: meal),
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppColors.secondaryGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Replace Meal',
                        style: AppTextStyles.s22w7i(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 24.sp,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                Text(
                  'Select which meal you want to replace.',
                  style: AppTextStyles.s14w4i(fontSize: 13.sp),
                ),

                SizedBox(height: 24.h),

                Text(
                  'Which meal to replace?',
                  style: AppTextStyles.s14w4i(
                    fontweight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 12.h),

                // Meal Type Buttons Grid - Direct Navigation
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 3.7,
                  ),
                  itemCount: mealTypes.length,
                  itemBuilder: (context, index) {
                    final meal = mealTypes[index];
                    final isSelected = selectedMeal == meal;

                    return InkWell(
                      onTap: () =>
                          _handleMealSelection(meal), // Direct navigation
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? AppColors.secondaryGradient
                              : null,
                          color: isSelected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFFFB2C36),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            meal,
                            style: AppTextStyles.s14w4i(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.ash,
                              fontweight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
