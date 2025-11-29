// // widgets/manage_your_plan_bottom_sheet.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:template/core/constants/app_colors.dart';
// import 'package:template/core/themes/app_text_style.dart';
// import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';

// class ManageYourPlan extends StatelessWidget {
//   const ManageYourPlan({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.r),
//           topRight: Radius.circular(24.r),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(24.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Close Button & Title
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ShaderMask(
//                       blendMode: BlendMode.srcIn,
//                       shaderCallback: (bounds) =>
//                           LinearGradient(
//                             colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)],
//                           ).createShader(
//                             Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                           ),
//                       child: Text(
//                         'Manage Your Plan',
//                         style: AppTextStyles.s22w7i(
//                           color: Colors.white,
//                           fontSize: 22.sp,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Icon(
//                         Icons.close,
//                         size: 24.sp,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 8.h),

//                 // Subtitle
//                 Text(
//                   'Continue your current plan or schedule your next one.',
//                   style: AppTextStyles.s14w4i(
//                     fontSize: 13.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),

//                 SizedBox(height: 24.h),

//                 // Meal Plan 1 (Current Plan)
//                 _buildPlanCard(
//                   context: context,
//                   title: 'Meal Plan 1',
//                   badge: '(Current Plan)',
//                   subtitle: 'Current plan ends on Nov 30, 2025.',
//                   buttonText: 'Continue Plan',
//                   onTap: () {
//                     // Just close bottom sheet
//                     Navigator.pop(context);

//                     Get.snackbar(
//                       'Success',
//                       'Continuing with current plan',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.green,
//                       colorText: Colors.white,
//                     );
//                   },
//                 ),

//                 SizedBox(height: 16.h),

//                 // Schedule Next Plan (Upload)
//                 _buildPlanCard(
//                   context: context,
//                   title: 'Schedule next plan',
//                   subtitle: 'Upload a new plan to start later.',
//                   buttonText: 'Upload New Plan',
//                   onTap: () {
//                     // Close bottom sheet and navigate to camera
//                     Navigator.pop(context);

//                     // Navigate to camera screen
//                     Get.to(
//                       () => CameraCaptureScreen(mealType: 'Plan Upload'),
//                       transition: Transition.downToUp,
//                     );
//                   },
//                 ),

//                 SizedBox(height: 16.h),

//                 // Replace Current Plan
//                 _buildPlanCard(
//                   context: context,
//                   title: 'Replace current plan',
//                   subtitle: 'Instantly replace with new plan.',
//                   buttonText: 'Replace Plan Now',
//                   onTap: () {
//                     // Close bottom sheet and navigate to replace screen
//                     Navigator.pop(context);

//                     // Navigate to replace plan screen
//                     // TODO: Replace with your actual screen
//                     Get.toNamed('/replace-plan');

//                     // Or use Get.to():
//                     // Get.to(() => ReplacePlanScreen());
//                   },
//                 ),

//                 SizedBox(height: 24.h),
//                 // Bottom Buttons
//                 Row(
//                   children: [
//                     // Back Button
//                     Expanded(
//                       child: InkWell(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           height: 50.h,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 2,
//                               ),
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16.r),
//                             border: Border.all(
//                               color: const Color(0xFFFB2C36),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Back',
//                               style: AppTextStyles.s14w4i(
//                                 color: Colors.black87,
//                                 fontweight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(width: 12.w),

//                     // Log Meal Button
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context, {});
//                         },
//                         child: Container(
//                           height: 50.h,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 2,
//                               ),
//                               BoxShadow(
//                                 color: AppColors.black.withOpacity(0.3),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                             gradient: AppColors.secondaryGradient,
//                             borderRadius: BorderRadius.circular(16.r),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Save changes',
//                               style: AppTextStyles.s14w4i(
//                                 color: Colors.white,
//                                 fontweight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Plan Card Widget
//   Widget _buildPlanCard({
//     required BuildContext context,
//     required String title,
//     String? badge,
//     required String subtitle,
//     required String buttonText,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: const Color(0xFFFB2C36), width: 1.5),
//         boxShadow: [
//           BoxShadow(color: AppColors.black.withOpacity(0.3), blurRadius: 2),
//           BoxShadow(
//             color: AppColors.black.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title with Badge
//           Row(
//             children: [
//               Text(
//                 title,
//                 style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
//               ),
//               if (badge != null) ...[
//                 SizedBox(width: 6.w),
//                 Text(badge, style: AppTextStyles.s14w4i(fontSize: 15.sp)),
//               ],
//             ],
//           ),

//           SizedBox(height: 6.h),

//           // Subtitle
//           Text(subtitle, style: AppTextStyles.s14w4i()),

//           SizedBox(height: 12.h),

//           // Button
//           InkWell(
//             onTap: onTap,
//             child: Container(
//               height: 37.h,
//               decoration: BoxDecoration(
//                 gradient: AppColors.secondaryGradient,
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.black.withOpacity(0.25),
//                     blurRadius: 2,
//                     offset: Offset(0, 0),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   buttonText,
//                   style: AppTextStyles.s14w4i(
//                     color: Colors.white,
//                     fontweight: FontWeight.w700,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// widgets/bottom_shet/manage_your_plan.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/diet_controller.dart';
import 'package:template/features/main_screen/screens/camara/camera_capture_screen.dart';

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
      padding: EdgeInsets.all(24.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 24.h),
            _buildCurrentStatusBox(),
            SizedBox(height: 20.h),
            _buildRepeatToggle(),
            SizedBox(height: 16.h),
            _buildDynamicMessage(),
            
            // New Plan Section (visible when toggle OFF)
            Obx(() => !controller.repeatCurrentPlan.value
                ? Column(
                    children: [
                      SizedBox(height: 20.h),
                      _buildNewPlanSection(context),
                    ],
                  )
                : SizedBox.shrink()),
            
            // Previous Plan Section (visible when exists)
            Obx(() => controller.hasPreviousPlan.value
                ? Column(
                    children: [
                      SizedBox(height: 20.h),
                      _buildPreviousPlanSection(),
                    ],
                  )
                : SizedBox.shrink()),
            
            SizedBox(height: 24.h),
            _buildSaveButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)],
          ).createShader(bounds),
          child: Text(
            'Manage Your Plan',
            style: AppTextStyles.s22w7i(color: Colors.white, fontSize: 22.sp),
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildCurrentStatusBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Status',
            style: AppTextStyles.s14w4i(fontSize: 12.sp, color: Colors.grey.shade600, fontweight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.restaurant_menu, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      controller.currentPlanName.value,
                      style: AppTextStyles.s16w5i(fontweight: FontWeight.w700),
                    )),
                    Obx(() => Text(
                      'Ends on ${controller.formatDate(controller.currentPlanEndDate.value)}',
                      style: AppTextStyles.s14w4i(fontSize: 12.sp, color: Colors.grey.shade600),
                    )),
                  ],
                ),
              ),
            ],
          ),
          // Next Plan Info
          Obx(() => controller.nextPlanName.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 12.h),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 16.sp, color: Colors.blue.shade700),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Next: ${controller.nextPlanName.value}, starts ${controller.formatDate(controller.nextPlanStartDate.value!)}',
                          style: AppTextStyles.s14w4i(fontSize: 12.sp, color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildRepeatToggle() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: controller.repeatCurrentPlan.value ? AppColors.brand : Colors.grey.shade300,
              width: controller.repeatCurrentPlan.value ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: controller.repeatCurrentPlan.value ? AppColors.brand.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.repeat,
                  color: controller.repeatCurrentPlan.value ? AppColors.brand : Colors.grey.shade600,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Repeat Current Plan',
                  style: AppTextStyles.s16w5i(
                    fontweight: FontWeight.w600,
                    color: controller.repeatCurrentPlan.value ? AppColors.brand : Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: controller.repeatCurrentPlan.value,
                onChanged: controller.toggleRepeat,
                activeColor: AppColors.brand,
              ),
            ],
          ),
        ));
  }

  Widget _buildDynamicMessage() {
    return Obx(() {
      final isRepeat = controller.repeatCurrentPlan.value;
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isRepeat ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(
              isRepeat ? Icons.info_outline : Icons.schedule,
              size: 18.sp,
              color: isRepeat ? Colors.green.shade700 : Colors.orange.shade700,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                controller.dynamicMessage,
                style: AppTextStyles.s14w4i(
                  fontSize: 13.sp,
                  color: isRepeat ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNewPlanSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFFF6B35).withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Plan', style: AppTextStyles.s16w5i(fontweight: FontWeight.w700)),
          SizedBox(height: 16.h),
          Obx(() => controller.newPlanFile.value == null
              ? _buildUploadButton(context)
              : _buildFileInfo(context)),
          Obx(() => controller.newPlanFile.value != null
              ? Column(
                  children: [
                    SizedBox(height: 16.h),
                    _buildDateField(context),
                    if (controller.newPlanStartDate.value != null) ...[
                      SizedBox(height: 8.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: controller.clearNewPlanDate,
                          child: Text(
                            'Clear date',
                            style: AppTextStyles.s14w4i(fontSize: 12.sp, color: Colors.red.shade400),
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  // Previous Plan Section
  Widget _buildPreviousPlanSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Previous Plan', style: AppTextStyles.s16w5i(fontweight: FontWeight.w700)),
              InkWell(
                onTap: () => _showDeleteConfirmation(),
                child: Icon(Icons.close, size: 18.sp, color: Colors.grey.shade500),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Previous Plan Info
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.history, color: Colors.grey.shade700, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        controller.previousPlanName.value,
                        style: AppTextStyles.s14w4i(fontweight: FontWeight.w600),
                      )),
                      Obx(() => Text(
                        controller.previousPlanEndDate.value != null
                            ? 'Was ending on ${controller.formatDate(controller.previousPlanEndDate.value!)}'
                            : '',
                        style: AppTextStyles.s14w4i(fontSize: 11.sp, color: Colors.grey.shade600),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Restore Button
          InkWell(
            onTap: () => _showRestoreConfirmation(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Restore Previous Plan?', style: AppTextStyles.s16w5i(fontweight: FontWeight.w700)),
        content: Text(
          'This will replace your current plan with "${controller.previousPlanName.value}". Your current plan will become the previous plan.',
          style: AppTextStyles.s14w4i(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.s14w4i(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Close bottom sheet
              controller.restorePreviousPlan();
            },
            child: Text('Restore', style: AppTextStyles.s14w4i(color: AppColors.brand, fontweight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // Delete Previous Plan Confirmation
  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Remove Previous Plan?', style: AppTextStyles.s16w5i(fontweight: FontWeight.w700)),
        content: Text(
          'This will permanently remove "${controller.previousPlanName.value}" from your saved plans. This action cannot be undone.',
          style: AppTextStyles.s14w4i(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.s14w4i(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearPreviousPlan();
              Get.snackbar(
                'Removed',
                'Previous plan has been removed.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.grey,
                colorText: Colors.white,
              );
            },
            child: Text('Remove', style: AppTextStyles.s14w4i(color: Colors.red, fontweight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return InkWell(
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
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)]),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Color(0xFFFF1B8D).withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 22.sp),
            SizedBox(width: 10.w),
            Text('Upload New Plan', style: AppTextStyles.s14w4i(color: Colors.white, fontweight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.insert_drive_file, color: Colors.green.shade700, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New plan:', style: AppTextStyles.s14w4i(fontSize: 11.sp, color: Colors.grey.shade600)),
                Obx(() => Text(
                      controller.newPlanFileName.value,
                      style: AppTextStyles.s14w4i(fontweight: FontWeight.w600, color: Colors.green.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
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
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(Icons.refresh, size: 18.sp, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Start Date', style: AppTextStyles.s14w4i(fontSize: 12.sp, color: Colors.grey.shade600, fontweight: FontWeight.w600)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => controller.pickNewPlanStartDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      controller.newPlanStartDate.value != null
                          ? controller.formatDate(controller.newPlanStartDate.value!)
                          : 'Select start date (optional)',
                      style: AppTextStyles.s14w4i(
                        color: controller.newPlanStartDate.value != null ? Colors.black87 : Colors.grey.shade500,
                      ),
                    )),
                Icon(Icons.calendar_today, size: 18.sp, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: controller.savePlanChanges,
      child: Container(
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)]),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Color(0xFFFF1B8D).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Center(
          child: Text('Save Changes', style: AppTextStyles.s16w5i(color: Colors.white, fontweight: FontWeight.w700)),
        ),
      ),
    );
  }
}