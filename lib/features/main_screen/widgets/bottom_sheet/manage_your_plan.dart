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
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 20.h),

              // 1. Current Status Box (always visible)
              _buildCurrentStatusBox(),

              SizedBox(height: 20.h),

              // 2. Repeat Current Plan Toggle
              _buildRepeatToggle(),

              // 3. New Plan Section (visible only when toggle OFF)
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

              // 4. Dynamic Message (always ONE message)
              _buildDynamicMessage(),

              // Previous Plan Section (if exists - for restore)
              // Obx(
              //   () => controller.hasPreviousPlan.value
              //       ? Column(
              //           children: [
              //             SizedBox(height: 20.h),
              //             _buildPreviousPlanSection(),
              //           ],
              //         )
              //       : SizedBox.shrink(),
              // ),
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

  // 1. Current Status Box - Always visible
  Widget _buildCurrentStatusBox() {
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
          // Plan Name + Red Dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(
                  () => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: controller.currentPlanName.value,
                          style: AppTextStyles.s16w5i(
                            fontweight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' (Current Plan)',
                          style: AppTextStyles.s14w4i(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Image.asset("assets/icons/akar-icons_radio-fill.png"),
            ],
          ),

          SizedBox(height: 8.h),

          // Current Plan End Date
          Obx(
            () => Text(
              'From ${controller.formatDate(controller.currentPlanStartDate.value)} to ${controller.formatDate(controller.currentPlanEndDate.value)}',
              style: AppTextStyles.s14w4i(),
            ),
          ),

          // Next Plan Info (if scheduled)
          Obx(
            () => controller.nextPlanName.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      'Next plan: ${controller.nextPlanName.value} Starts on ${controller.formatDate(controller.nextPlanStartDate.value!)}',
                      style: AppTextStyles.s14w4i(),
                    ),
                  )
                : SizedBox.shrink(),
          ),

          SizedBox(height: 12.h),

          // Selected Plan Button
          InkWell(
            child: Container(
              height: 37.h,
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
                  'Replace Meal',
                  style: AppTextStyles.s14w4i(
                    color: Colors.white,
                    fontweight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Repeat Current Plan Toggle
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
            style: AppTextStyles.s14w4i(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  // 3. New Plan Section (visible only when toggle OFF)
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
          Text(
            'New Plan',
            style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
          ),

          SizedBox(height: 12.h),

          // A) No file uploaded OR B) File uploaded
          Obx(
            () => controller.hasFileUploaded
                ? _buildFileUploadedSection(context)
                : _buildNoFileSection(context),
          ),
        ],
      ),
    );
  }

  // 3A) No File Uploaded - Show upload button only
  Widget _buildNoFileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('No file uploaded', style: AppTextStyles.s14w4i()),

        SizedBox(height: 12.h),

        // Upload Button
        InkWell(
          onTap: () async {
            Navigator.pop(context);
            final result = await Get.to(
              () => CameraCaptureScreen(mealType: 'New Plan'),
              transition: Transition.downToUp,
            );
            if (result != null && result is File) {
              controller.setNewPlanFile(result);
            }
            controller.navigateToManagePlan();
          },
          child: Container(
            width: double.infinity,
            height: 44.h,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Upload new plan',
                  style: AppTextStyles.s14w4i(
                    color: Colors.white,
                    fontweight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File Info with Replace Button
        Container(
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
              // // File Icon
              // Container(
              //   padding: EdgeInsets.all(8.w),
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade200,
              //     borderRadius: BorderRadius.circular(8.r),
              //   ),
              //   child: Icon(
              //     Icons.insert_drive_file_outlined,
              //     size: 18.sp,
              //     color: Colors.grey.shade700,
              //   ),
              // ),

              // SizedBox(width: 10.w),

              // File Name
              Expanded(
                child: Obx(
                  () => Text(
                    'New plan: ${controller.newPlanFileName.value}',
                    style: AppTextStyles.s14w4i(
                      fontweight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Replace Button (⟳ icon)
              InkWell(
                onTap: () => controller.replaceNewPlanFile(context),
                child: SvgPicture.asset("assets/icons/refresh.svg"),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Start Date & End Date Pickers (Side by Side)
        Row(
          children: [
            // Start Date
            Expanded(child: _buildDatePicker(context, 'Start Date', true)),
            SizedBox(width: 12.w),
            // End Date
            Expanded(child: _buildDatePicker(context, 'End Date', false)),
          ],
        ),
      ],
    );
  }

  // Date Picker Widget (Reusable for both Start & End)
  Widget _buildDatePicker(
    BuildContext context,
    String label,
    bool isStartDate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.s14w4i(
            fontweight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: () => isStartDate
              ? controller.pickNewPlanStartDate(context)
              : controller.pickNewPlanEndDate(context),
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
                    final date = isStartDate
                        ? controller.newPlanStartDate.value
                        : controller.newPlanEndDate.value;

                    return Text(
                      date != null
                          ? controller.formatDate(date)
                          : 'Pick a date',
                      style: AppTextStyles.s14w4i(
                        color: date != null ? AppColors.black : AppColors.ash,
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

  // 4. Dynamic Message - Always ONE message based on state
  Widget _buildDynamicMessage() {
    return Obx(() {
      final isRepeat = controller.repeatCurrentPlan.value;
      final isToday = controller.isStartDateToday;

      // Determine colors based on state
      Color bgColor;
      Color textColor;
      IconData icon;

      if (isRepeat) {
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle_outline;
      } else if (isToday) {
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        icon = Icons.warning_amber_outlined;
      } else {
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        icon = Icons.info_outline;
      }

      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: textColor),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                controller.dynamicMessage,
                style: AppTextStyles.s14w4i(fontSize: 12.sp, color: textColor),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Previous Plan Section (for restore after immediate replacement)
  Widget _buildPreviousPlanSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previous Plan',
            style: AppTextStyles.s16w5i(fontweight: FontWeight.w600),
          ),

          SizedBox(height: 12.h),

          // Previous Plan Info
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.history,
                  color: Colors.grey.shade700,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.previousPlanName.value,
                        style: AppTextStyles.s14w4i(
                          fontweight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        'Was: ${controller.formatDate(controller.previousPlanStartDate.value!)} to ${controller.formatDate(controller.previousPlanEndDate.value!)}',
                        style: AppTextStyles.s14w4i(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Restore Button
          InkWell(
            onTap: () => _showRestoreConfirmation(),
            child: Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.brand, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restore, color: AppColors.brand, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Restore This Plan',
                    style: AppTextStyles.s14w4i(
                      color: AppColors.brand,
                      fontweight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Restore Confirmation Dialog
  void _showRestoreConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Restore Previous Plan?',
          style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
        ),
        content: Text(
          'This will replace your current plan "${controller.currentPlanName.value}" with "${controller.previousPlanName.value}".',
          style: AppTextStyles.s14w4i(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.s14w4i(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Close bottom sheet
              controller.restorePreviousPlan();
            },
            child: Text(
              'Restore',
              style: AppTextStyles.s14w4i(
                color: AppColors.brand,
                fontweight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Buttons
  Widget _buildBottomButtons(BuildContext context) {
    return
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

        // Log Meal Button
        Expanded(
          child: InkWell(
            onTap: () => controller.savePlanChanges,
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
