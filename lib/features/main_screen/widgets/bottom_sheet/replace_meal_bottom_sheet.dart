// widgets/replace_meal_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

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
                        'Add Meal',
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
                  'Replace this meal with another option.',
                  style: AppTextStyles.s14w4i(fontSize: 13.sp),
                ),

                SizedBox(height: 24.h),

                Text(
                  'Which meal you add?',
                  style: AppTextStyles.s14w4i(
                    fontweight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 12.h),

                // Meal Type Buttons Grid
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
                      onTap: () {
                        setState(() {
                          selectedMeal = meal;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? AppColors.secondaryGradient
                              : null,
                          color: isSelected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
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
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Text(
                  'Upload Photos',
                  style: AppTextStyles.s16w5i(fontweight: FontWeight.w600),
                ),

                SizedBox(height: 12.h),

                // Photo Upload Buttons
                Row(
                  children: [
                    // Select File (Gallery)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            'action': 'gallery',
                            'mealType': selectedMeal,
                            'details': detailsController.text,
                          });
                        },
                        child: Container(
                          height: 85.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFFB2C36),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 20.sp,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(height: 8.w),
                              Text(
                                'Select file',
                                style: AppTextStyles.s14w4i(
                                  color: Colors.grey.shade700,
                                  fontweight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Capture Image (Camera)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            'action': 'camera',
                            'mealType': selectedMeal,
                            'details': detailsController.text,
                          });
                        },
                        child: Container(
                          height: 85.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFFB2C36),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 20.sp,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(height: 8.w),
                              Text(
                                'Capture image',
                                style: AppTextStyles.s14w4i(
                                  color: Colors.grey.shade700,
                                  fontweight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                Text(
                  'Improve Accuracy (Optional)',
                  style: AppTextStyles.s16w5i(fontweight: FontWeight.w600),
                ),

                SizedBox(height: 12.h),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.3),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: detailsController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          'Add details for tricky items to improve AIVO\'s accuracy (e.g. drinks, burgers, mixed plates)',
                      hintStyle: AppTextStyles.s14w4i(fontSize: 12.sp),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: const Color(0xFFFB2C36),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: const Color(0xFFFB2C36),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.brand,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Bottom Buttons
                Row(
                  children: [
                    // Back Button
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFFB2C36),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Back',
                              style: AppTextStyles.s14w4i(
                                color: Colors.black87,
                                fontweight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Log Meal Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            'action': 'camera',
                            'mealType': selectedMeal,
                            'details': detailsController.text,
                          });
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                            gradient: AppColors.secondaryGradient,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Text(
                              'Log Meal',
                              style: AppTextStyles.s14w4i(
                                color: Colors.white,
                                fontweight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
