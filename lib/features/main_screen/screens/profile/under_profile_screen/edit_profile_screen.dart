// screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/features/main_screen/controllers/edit_profile_controller.dart';
import 'package:template/features/main_screen/controllers/profile_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custom_text_field.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/widget/custome_button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();

    return MainScreen(
      child: SafeArea(
        child: Column(
          children: [
            //Header
            SizedBox(height: 25.h),
            CustomeHeader(title: "Edit Profile"),
            SizedBox(height: 40.h),

            //Main Container
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCFCFCF),
                    blurRadius: 10,
                    offset: Offset(0, 1),
                    spreadRadius: -5,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              margin: EdgeInsets.symmetric(horizontal: 20.w),

              child: Column(
                children: [
                  //Profile Picture
                  _buildProfilePictureSection(controller),

                  //Name
                  CustomTextField(
                    label: 'Name',
                    hintText: 'Alex',
                    controller: controller.nameController,
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 24.h),
                  //Email
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Alex@gmail.com',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),

            //Save Button
            Spacer(),
            // Save Button with Loading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => controller.isLoading.value
                    ? CustomeButton(
                        gradient: AppColors.primaryGradient,
                        onTap: controller.saveProfileChanges,
                        title: "Saving...",
                      )
                    : CustomeButton(
                        gradient: AppColors.primaryGradient,
                        onTap: controller.saveProfileChanges,
                        title: "Save Changes",
                      ),
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(EditProfileController controller) {
    return Center(
      child: Stack(
        children: [
          // Profile Picture with Border
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brand.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(4), // Border width
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(3),
              child: ClipOval(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.brand,
                          ),
                        ),
                      ),
                    );
                  }

                  // Get user data from ProfileController
                  final profileController = Get.find<ProfileController>();
                  final user = profileController.user.value;

                  if (user?.avatar != null && user!.avatar!.isNotEmpty) {
                    return Image.network(
                      user.avatar!,
                      fit: BoxFit.cover,
                      width: 130.w,
                      height: 130.w,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.brand,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return _buildDefaultAvatar();
                }),
              ),
            ),
          ),

          // Camera Icon Button
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: controller.updateProfilePicture,
              borderRadius: BorderRadius.circular(25.r),
              child: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brand.withOpacity(0.4),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 22.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.brand.withOpacity(0.1),
      child: Icon(Icons.person, size: 60.sp, color: AppColors.brand),
    );
  }
}
