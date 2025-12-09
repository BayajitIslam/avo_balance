// widgets/bottom_shet/manage_your_plan.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/diet_controller.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';
import 'package:template/features/main_screen/widgets/custome_switch.dart';

class ManageYourPlan extends StatelessWidget {
  ManageYourPlan({super.key});

  final controller = Get.find<DietController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.black54),
                ),
              ),

              // Title
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)],
                ).createShader(bounds),
                child: Text(
                  'Manage Your Plan',
                  style: AppTextStyles.s22w7i(
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Subtitle
              Text(
                'Continue your current plan or schedule your next one.',
                style: AppTextStyles.s14w4i(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 20.h),

              // Current Plan Box (always visible)
              _buildCurrentPlanBox(),

              SizedBox(height: 20.h),

              // Repeat Current Plan Toggle
              _buildRepeatToggle(),

              // New Plan Section (visible only when toggle OFF)
              Obx(
                () => !controller.repeatCurrentPlan.value
                    ? Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildNewPlanSection(context),
                        ],
                      )
                    : SizedBox.shrink(),
              ),

              SizedBox(height: 16.h),

              // Dynamic Message (always visible)
              _buildDynamicMessage(),

              SizedBox(height: 24.h),

              // Bottom Buttons
              _buildBottomButtons(context),

              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }

  // Current Plan Box
  Widget _buildCurrentPlanBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.3), blurRadius: 2),
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Current Plan" Label
          Text(
            'Current Plan',
            style: AppTextStyles.s14w4i(
              fontSize: 11.sp,
              color: Color(0xFFEA580C),
              fontweight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 8.h),

          // Plan Name
          Obx(
            () => Text(
              controller.currentPlanName.value,
              style: AppTextStyles.s16w5i(
                fontweight: FontWeight.w700,
                fontSize: 24.sp,
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Current Plan Date Range with Calendar Icon
          Row(
            children: [
              SvgPicture.asset("assets/icons/calander.svg"),
              SizedBox(width: 6.w),
              Obx(
                () => Text(
                  '${controller.formatDate(controller.currentPlanStartDate.value)} — ${controller.formatDate(controller.currentPlanEndDate.value)}',
                  style: AppTextStyles.s14w4i(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Up Next Section - Show in 2 cases:
          // 1. Toggle ON (repeat current plan)
          // 2. Toggle OFF + Next plan exists
          Obx(() {
            final isRepeat = controller.repeatCurrentPlan.value;
            final hasNextPlan = controller.nextPlanName.isNotEmpty;

            // Determine what to show
            String upNextPlanName;
            DateTime upNextStartDate;

            if (isRepeat) {
              // Show current plan repeating
              upNextPlanName = controller.currentPlanName.value;
              upNextStartDate = controller.currentPlanEndDate.value.add(
                Duration(days: 1),
              );
            } else if (hasNextPlan) {
              // Show actual next plan
              upNextPlanName = controller.nextPlanName.value;
              upNextStartDate = controller.nextPlanStartDate.value!;
            } else {
              // Don't show Up Next section
              return SizedBox.shrink();
            }

            return Container(
              height: 62.h,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Row(
                children: [
                  // Clock Icon in Circle
                  Container(
                    height: 34.h,
                    width: 34.w,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset("assets/icons/time.svg"),
                  ),

                  SizedBox(width: 10.w),

                  // Up Next Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // "Up Next" Label
                        Text(
                          'Up Next',
                          style: AppTextStyles.s14w4i(
                            fontSize: 12.sp,
                            fontweight: FontWeight.w600,
                          ),
                        ),

                        // Next Plan Name + Start Date
                        Wrap(
                          children: [
                            Text(
                              upNextPlanName.length > 9
                                  ? '${upNextPlanName.substring(0, 9)}... '
                                  : upNextPlanName,
                              style: AppTextStyles.s22w7i(fontSize: 12.sp),
                            ),
                            Text(
                              'Starts From ${controller.formatDate(upNextStartDate)}',
                              style: AppTextStyles.s14w4i(
                                fontSize: 12.sp,
                                fontweight: FontWeight.w400,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Repeat Current Plan Toggle
  Widget _buildRepeatToggle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.3), blurRadius: 2),
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
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
                'Repeat Current Plan',
                style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
              ),
              Obx(
                () => CustomeSwitch(
                  value: controller.repeatCurrentPlan.value,
                  onChanged: controller.toggleRepeat,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Automatically continue with the same plan',
            style: AppTextStyles.s14w4i(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // New Plan Section
  // widgets/bottom_shet/manage_your_plan.dart

  // New Plan Section
  // widgets/bottom_shet/manage_your_plan.dart

  // New Plan Section - ALWAYS shows same UI
  Widget _buildNewPlanSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.3), blurRadius: 2),
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "New Plan" header
          Text(
            'New Plan',
            style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
          ),

          SizedBox(height: 12.h),

          // File Info Box (always visible)
          _buildPlanFileBox(context),

          SizedBox(height: 16.h),

          // Start Date Picker (always visible)
          _buildStartDatePicker(context),
        ],
      ),
    );
  }

  Widget _buildPlanFileBox(BuildContext context) {
    return Obx(() {
      final hasNextPlan = controller.nextPlanName.isNotEmpty;
      final hasFileUploaded = controller.hasFileUploaded;

      String displayText;
      bool isPlaceholder = false;

      if (hasNextPlan) {
        displayText = 'New plan: ${controller.nextPlanName.value}';
      } else if (hasFileUploaded) {
        displayText = 'New plan: ${controller.newPlanFileName.value}';
      } else {
        displayText = 'Add Another Plan';
        isPlaceholder = true;
      }

      return InkWell(
        onTap: () async {
          if (isPlaceholder) {
            // Direct camera open - no bottom sheet
            Navigator.pop(context); // Close manage plan

            final result = await Get.to(
              () => CameraCaptureScreen(mealType: 'New Plan'),
              transition: Transition.downToUp,
            );

            if (result != null && result is File) {
              controller.setNewPlanFile(result);
            }

            controller.navigateToManagePlan(); // Reopen manage plan
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isPlaceholder ? Colors.grey.shade100 : Colors.grey.shade50,
            borderRadius: isPlaceholder
                ? BorderRadius.circular(8)
                : BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Color(0XffF3F3F3).withOpacity(0.25),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText,
                  style: AppTextStyles.s14w4i(
                    fontweight: FontWeight.w500,
                    color: isPlaceholder ? AppColors.ash : AppColors.textBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(width: 8.w),

              // Refresh Button - Direct camera
              InkWell(
                onTap: () async {
                  Navigator.pop(context); // Close manage plan

                  final result = await Get.to(
                    () => CameraCaptureScreen(mealType: 'New Plan'),
                    transition: Transition.downToUp,
                  );

                  if (result != null && result is File) {
                    controller.setNewPlanFile(result);
                  }

                  controller.navigateToManagePlan(); // Reopen manage plan
                },
                child: SvgPicture.asset(
                  "assets/icons/refresh.svg",
                  colorFilter: ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Start Date Picker (always visible)
  Widget _buildStartDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start Date',
          style: AppTextStyles.s14w4i(
            fontweight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: () {
            // Always allow date selection when toggle is OFF
            if (!controller.repeatCurrentPlan.value) {
              _selectStartDate(context);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0XffF3F3F3).withOpacity(0.25),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.sp,
                  color: Colors.grey.shade500,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Obx(() {
                    final hasNextPlan = controller.nextPlanName.isNotEmpty;

                    DateTime? date;

                    if (hasNextPlan) {
                      // Show existing next plan date
                      date = controller.nextPlanStartDate.value;
                    } else {
                      // Show new plan date
                      date = controller.newPlanStartDate.value;
                    }

                    return Text(
                      date != null
                          ? controller.formatDate(date)
                          : 'Pick a date',
                      style: AppTextStyles.s14w4i(
                        color: date != null
                            ? AppColors.textBlack
                            : AppColors.ash,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Separate method to handle date selection
  void _selectStartDate(BuildContext context) async {
    final hasNextPlan = controller.nextPlanName.isNotEmpty;

    // Determine initial date
    DateTime initialDate;
    if (hasNextPlan && controller.nextPlanStartDate.value != null) {
      initialDate = controller.nextPlanStartDate.value!;
    } else if (controller.newPlanStartDate.value != null) {
      initialDate = controller.newPlanStartDate.value!;
    } else {
      initialDate = DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
      if (hasNextPlan) {
        // Update existing next plan start date
        controller.updateNextPlanStartDate(picked);
      } else {
        // Update new plan start date
        controller.newPlanStartDate.value = picked;
      }
    }
  }

  // Dynamic Message
  Widget _buildDynamicMessage() {
    return Obx(() {
      final isRepeat = controller.repeatCurrentPlan.value;
      final isToday = controller.isStartDateToday;

      // Determine colors based on state
      Color bgColor;
      Color textColor;

      if (isRepeat) {
        bgColor = Color(0xFFF0F9FF);
        textColor = Color(0xFF0369A1);
      } else if (isToday) {
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
      } else {
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            controller.dynamicMessage,
            style: AppTextStyles.s14w4i(fontSize: 12.sp, color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  // Bottom Buttons
  Widget _buildBottomButtons(BuildContext context) {
    return Row(
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
                border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
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

        // Save Button
        Expanded(
          child: InkWell(
            onTap: () {
              //Actual Function
              controller.savePlanChanges();
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
                  'Save changes',
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
    );
  }
}
