// widgets/edit_personal_data_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/controllers/profile_controller.dart';

class EditPersonalDataDialog extends StatelessWidget {
  const EditPersonalDataDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(color: AppColors.white),
        constraints: BoxConstraints(maxHeight: 600.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Personal Data',
                    style: AppTextStyles.s22w7i(fontSize: 20.sp),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, size: 24.sp),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Age Field
              _buildTextField(
                label: 'Age',
                controller: controller.ageController,
                keyboardType: TextInputType.number,
                suffix: 'Years',
              ),

              SizedBox(height: 16.h),

              // Gender Dropdown
              _buildDropdown(
                label: 'Gender',
                value: controller.selectedGender,
                items: controller.genderOptions,
              ),

              SizedBox(height: 16.h),

              // Weight Field
              _buildTextField(
                label: 'Weight',
                controller: controller.weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                suffix: 'kg',
              ),

              SizedBox(height: 16.h),

              // Height Field
              _buildTextField(
                label: 'Height',
                controller: controller.heightController,
                keyboardType: TextInputType.number,
                suffix: 'cm',
              ),

              SizedBox(height: 16.h),

              // Goal Dropdown
              _buildDropdown(
                label: 'Goal',
                value: controller.selectedGoal,
                items: controller.goalOptions,
              ),

              SizedBox(height: 24.h),

              // Save Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.savePersonalData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      // gradient: AppColors.primaryGradient,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: AppTextStyles.s16w5i(color: AppColors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.s14w4i(
            fontweight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: AppTextStyles.s14w4i(color: Colors.grey.shade600),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.brand, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString value,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.s14w4i(
            fontweight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.brand),
                style: AppTextStyles.s14w4i(
                  fontweight: FontWeight.w500,
                  color: Colors.black,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    value.value = newValue;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
