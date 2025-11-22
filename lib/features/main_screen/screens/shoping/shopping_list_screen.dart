// screens/shopping_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/shopping_list_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/action_button.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShoppingListController>();

    return MainScreen(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(height: 25.h),
            CustomeHeader(title: "Shopping List"),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 23.h),

                    // Date Range Selector Card
                    _buildDateRangeCard(controller),

                    SizedBox(height: 20.h),

                    // Shopping List (shown after generate)
                    Obx(() {
                      if (controller.showList.value) {
                        return Column(
                          children: [
                            _buildShoppingListCard(controller),
                            SizedBox(height: 20.h),
                            _buildGetListButton(controller),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    }),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date Range Selector Card
  Widget _buildDateRangeCard(ShoppingListController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text('Select Date Range', style: AppTextStyles.s16w4i()),

          SizedBox(height: 16.h),

          // Date Pickers Row
          Obx(
            () => Row(
              children: [
                // Start Date
                Expanded(
                  child: _buildDateField(
                    label: 'Start Date',
                    date: controller.startDate.value,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: controller.startDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.brand,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        controller.updateStartDate(picked);
                      }
                    },
                  ),
                ),

                SizedBox(width: 12.w),

                // End Date
                Expanded(
                  child: _buildDateField(
                    label: 'End Date',
                    date: controller.endDate.value,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: controller.endDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.brand,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        controller.updateEndDate(picked);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Generate Button
          Obx(
            () => ActionButton(
              onTap: controller.isLoading.value
                  ? () {}
                  : controller.generateShoppingList,
              title: controller.isLoading.value
                  ? "Generating..."
                  : "Generate List",
              leftIcon: "assets/icons/oui_generate.png",
              leftIconbgColor: AppColors.transparentGradiant,
              rightIconbgColor: AppColors.white.withOpacity(0.20),
              descColor: const Color(0xFFffffff).withOpacity(0.8),
              rightIconColor: AppColors.white,
              iconBorderEnable: true,
              shadowOn: true,
              rightIcon: Icons.arrow_forward,
              padding: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Date Field
  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.brand, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.s14w4i(fontSize: 12)),
              SizedBox(height: 4),
              InkWell(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}',
                        style: AppTextStyles.s16w4i(),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 16.sp,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Shopping List Card
  Widget _buildShoppingListCard(ShoppingListController controller) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Shopping List (${controller.getDateRangeString()})',
              style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
            ),

            SizedBox(height: 16.h),

            // List Items
            ...controller.shoppingItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    // Checkbox
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: Checkbox(
                        value: item['isChecked'],
                        onChanged: (value) {
                          controller.toggleItem(index);
                        },
                        activeColor: AppColors.brand,
                        side: BorderSide(
                          color: Colors.grey, // Unchecked border color
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Item Name
                    Expanded(
                      child: Text(
                        item['name'],
                        style: AppTextStyles.s16w4i(
                          // decoration: item['isChecked']
                          //     ? TextDecoration.lineThrough
                          //     : null,
                          color: item['isChecked'] ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Get Your List Button
  Widget _buildGetListButton(ShoppingListController controller) {
    return ActionButton(
      borderEnbale: true,
      rightIcon: Icons.download,
      leftIconbgColor: AppColors.secondaryGradient,
      gradient: AppColors.transparentGradiant,
      rightIconbgColor: const Color(0xFFF3F4F6),
      titleColor: AppColors.black,
      descColor: AppColors.ash,
      onTap: controller.exportList,
      leftIcon: "assets/icons/export.png",
      title: "Get Your List",
      desc: "For your chosen days",
    );
  }
}
