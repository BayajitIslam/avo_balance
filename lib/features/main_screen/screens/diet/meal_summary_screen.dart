import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/diet/rebalancing_screen.dart';
import 'package:template/features/main_screen/widgets/action_button.dart';
import 'package:template/features/main_screen/widgets/bottom_sheet/replace_meal_bottom_sheet.dart';
import 'package:template/features/main_screen/widgets/multi_segment_circular_progress.dart';

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

class MealSummaryScreen extends StatefulWidget {
  final File imageFile;

  const MealSummaryScreen({super.key, required this.imageFile});

  @override
  State<MealSummaryScreen> createState() => _MealSummaryScreenState();
}

class _MealSummaryScreenState extends State<MealSummaryScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<Map<String, String>> _additionalItems = [];

  double _sheetPosition = 0.5; // Track bottom sheet position (0.5 = 50%)

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  // void _showExitWarning() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16.r),
  //       ),
  //       title: Text(
  //         'Discard Changes?',
  //         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
  //       ),
  //       content: Text(
  //         'Are you sure you want to go back? Your meal data will be lost.',
  //         style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             'Cancel',
  //             style: TextStyle(
  //               fontSize: 14.sp,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.grey.shade600,
  //             ),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             Get.offAll(() => DietScreen());
  //           },
  //           child: Text(
  //             'OK',
  //             style: TextStyle(
  //               fontSize: 14.sp,
  //               fontWeight: FontWeight.w700,
  //               color: Colors.red,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _handleAction(String action) {
    Get.off(
      () => RebalancingScreen(action: action),
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image (Full Screen)
          Positioned.fill(
            child: Image.file(widget.imageFile, fit: BoxFit.cover),
          ),

          // Dynamic Dark Overlay (increases as bottom sheet goes up)
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 50),
              color: Colors.black.withOpacity(_calculateOverlayOpacity()),
            ),
          ),

          // Status Bar Area
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_4_bar,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.wifi, color: Colors.white, size: 16.sp),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.battery_full,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Draggable Bottom Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.5, // Start at 50%
              minChildSize: 0.5, // Minimum 50%
              maxChildSize: 0.95, // Maximum 95%
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
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
                            // Header
                            _buildHeader(),
                            SizedBox(height: 8.h),

                            // Dots
                            _buildDotsIndicator(),
                            SizedBox(height: 20.h),

                            // Main Item
                            _buildMainItem(),
                            SizedBox(height: 16.h),

                            // Detected Items
                            _buildDetectedItems(),
                            SizedBox(height: 16.h),

                            // Warning
                            _buildWarning(),
                            SizedBox(height: 20.h),

                            // Improve Accuracy
                            _buildImproveAccuracy(),
                            SizedBox(height: 20.h),

                            // Action Buttons
                            _buildActionButtons(),
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
      ),
    );
  }

  double _calculateOverlayOpacity() {
    // When sheet is at 50% = 0.0 opacity (fully clear)
    // When sheet is at 95% = 0.7 opacity (dark)

    if (_sheetPosition <= 0.5) {
      return 0.0; // Fully visible when at 50% or below
    }

    // Calculate progress from 50% to 95%
    double progress = (_sheetPosition - 0.5) / (0.95 - 0.5);

    // Apply easing curve for smoother transition
    double easedProgress = progress * progress; // Quadratic easing

    return (easedProgress * 0.7).clamp(0.0, 0.7);
  }

  // Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //dummy contyainer
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close, size: 20.sp, color: Colors.transparent),
        ),

        //Text
        Text(
          'Meal Summary',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),

        //cross button
        InkWell(
          onTap: () => Navigator.pop(context),
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

  // Dots Indicator
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: index == 1 ? Color(0xFFFB2C36) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }

  // State variable
  int? _selectedNutritionIndex;

  // Segments
  final List<NutritionSegment> _nutritionSegments = [
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

  // Alternative layout if overflow issues occur
  Widget _buildMainItem() {
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

        // Use ClipRect to allow overflow on left
        ClipRect(
          clipBehavior: Clip.none,
          child: Align(
            alignment: Alignment.centerLeft,
            child: MultiSegmentCircularProgress(
              size: 100,
              totalCalories: 820,
              segments: _nutritionSegments,
              selectedIndex: _selectedNutritionIndex,
              onSegmentChange: (index) {
                setState(() {
                  _selectedNutritionIndex = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // Detected Items - Your Design
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
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              // Container(
              //   width: 12.w,
              //   height: 12.w,
              //   decoration: BoxDecoration(
              //     color: item.color,
              //     shape: BoxShape.circle,
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColors.black.withOpacity(0.3),
              //         spreadRadius: -4,
              //         blurRadius: 6,
              //         offset: Offset(0, 10),
              //       ),
              //       BoxShadow(
              //         color: AppColors.black.withOpacity(0.3),
              //         spreadRadius: -3,
              //         blurRadius: 15,
              //         offset: Offset(0, 10),
              //       ),
              //     ],
              //   ),
              // ),
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

  // Warning
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

  // Add state variable at top of _MealSummaryScreenState
  bool _showIngredientInput = false;

  // Updated _buildImproveAccuracy() method
  Widget _buildImproveAccuracy() {
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
          style: AppTextStyles.s14w4i(fontSize: 11),
        ),
        SizedBox(height: 16.h),

        // Show Input Field (when activated)
        if (_showIngredientInput)
          Column(
            children: [
              // Text Input Field
              TextField(
                controller: _ingredientController,
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
                    _addAndContinue();
                  }
                },
              ),

              SizedBox(height: 12.h),
            ],
          ),

        // Added Items (show above button when items exist)
        if (_additionalItems.isNotEmpty) ...[
          ..._additionalItems.map((item) {
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
                  // Ingredient Icon
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

                  // Item Name
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

                  // Calories Badge
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

                  // Remove Button
                  InkWell(
                    onTap: () {
                      setState(() {
                        _additionalItems.remove(item);
                      });
                    },
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

        // Add/Done Button
        InkWell(
          onTap: () {
            if (_showIngredientInput) {
              // If input is shown, try to add current text and continue
              if (_ingredientController.text.trim().isNotEmpty) {
                _addAndContinue();
              } else {
                // If empty, close input
                setState(() {
                  _showIngredientInput = false;
                });
              }
            } else {
              // Show input field
              setState(() {
                _showIngredientInput = true;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: _showIngredientInput ? Colors.white : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18.sp, color: Color(0xFF64748B)),
                SizedBox(width: 8.w),
                Text(
                  _showIngredientInput ? 'Add another...' : 'Add an item...',
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

        // Done Button (when input is shown)
        if (_showIngredientInput && _additionalItems.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showIngredientInput = false;
                  _ingredientController.clear();
                });
              },
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

  // Updated add method
  void _addAndContinue() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _additionalItems.add({'name': _ingredientController.text.trim()});
        _ingredientController.clear();
        // Keep _showIngredientInput = true to continue adding
      });
    }
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        ActionButton(
          onTap: () => _handleAction('add_extra'),
          gradient: AppColors.transparentGradiant,
          leftIcon: "assets/icons/add.png",
          leftIconbgColor: AppColors.secondaryGradient,
          rightIcon: Icons.arrow_forward,
          title: 'Add all as Extra',
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
    );
  }
}
