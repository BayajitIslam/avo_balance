// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';
import 'package:template/features/main_screen/controllers/profile_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:intl/intl.dart';
import 'package:template/features/main_screen/widgets/action_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final authController = Get.find<AuthController>();

    return MainScreen(
      child: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand),
              ),
            );
          }

          if (controller.user.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load user data'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: controller.loadUserData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildProfileSection(controller),
                SizedBox(height: 16.h),
                _buildKYCBanner(controller),
                SizedBox(height: 16.h),
                _buildProgressCard(controller),
                SizedBox(height: 16.h),
                _buildPersonalDataCard(controller),
                SizedBox(height: 16.h),
                _buildMenuItems(controller),
                SizedBox(height: 16.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildActionButtons(controller, authController),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
            ),
          ),
          Text(
            'Profile',
            style: AppTextStyles.s22w7i(
              fontSize: 20.sp,
              fontweight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 24.sp),
              SizedBox(width: 12.w),
              Icon(Icons.shopping_cart_outlined, size: 24.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(ProfileController controller) {
    final user = controller.user.value!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCCCCCC),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27.r,
            backgroundImage: user.avatar != null
                ? NetworkImage(user.avatar!)
                : AssetImage('assets/icons/profile.png') as ImageProvider,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.s18w5i(fontweight: FontWeight.w800),
                ),
                SizedBox(height: 6.h),
                Text(user.email, style: AppTextStyles.s14w4i()),
              ],
            ),
          ),
          InkWell(
            onTap: controller.updateProfilePicture,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKYCBanner(ProfileController controller) {
    final user = controller.user.value!;

    if (!user.isPremium) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCCCCCC),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.brand,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCCCCCC),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AVO Premium (Free Trial)',
                  style: AppTextStyles.s14w4i(
                    fontweight: FontWeight.w600,
                    color: AppColors.brand,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No charges until ${DateFormat('MMM dd, yyyy').format(user.premiumExpiryDate!)}',
                  style: AppTextStyles.s14w4i(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(ProfileController controller) {
    final user = controller.user.value!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.brand, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.brand.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.brand,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Your Progress',
                style: AppTextStyles.s18w5i(fontweight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This is the Health update',
                style: AppTextStyles.s14w4i(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: CircularProgressIndicator(
                        value: user.progressDays / user.totalDays,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.brand,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user.progressDays}/${user.totalDays}',
                          style: AppTextStyles.s18w5i(
                            fontweight: FontWeight.w700,
                            color: AppColors.brand,
                          ),
                        ),
                        Text(
                          'Days',
                          style: AppTextStyles.s14w4i(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16.sp,
                            color: AppColors.brand,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Weekly',
                            style: AppTextStyles.s14w4i(
                              fontSize: 11.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${user.weeklyPercentage}%',
                        style: AppTextStyles.s22w7i(
                          color: AppColors.brand,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Balanced days',
                        style: AppTextStyles.s14w4i(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            size: 16.sp,
                            color: AppColors.brand,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Once streak',
                            style: AppTextStyles.s14w4i(
                              fontSize: 11.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${user.streakCount}',
                        style: AppTextStyles.s22w7i(
                          color: AppColors.brand,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Logged',
                        style: AppTextStyles.s14w4i(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataCard(ProfileController controller) {
    final user = controller.user.value!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
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
                'Personal Data',
                style: AppTextStyles.s18w5i(fontweight: FontWeight.w700),
              ),
              InkWell(
                onTap: () => controller.editPersonalData('Personal Data'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildDataRow(controller, 'Age', '${user.age} Years'),
          _buildDataRow(controller, 'Gender', user.gender),
          _buildDataRow(controller, 'Weight', '${user.weight} kg'),
          _buildDataRow(controller, 'Height', '${user.height.toInt()} cm'),
          _buildDataRow(controller, 'Goal', user.goal, isLast: true),
        ],
      ),
    );
  }

  Widget _buildDataRow(
    ProfileController controller,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () => controller.editPersonalData(label),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTextStyles.s14w4i(color: Colors.grey.shade600),
                ),
                Row(
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.s14w4i(fontweight: FontWeight.w600),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!isLast) ...[
          SizedBox(height: 8.h),
          Divider(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 8.h),
        ],
      ],
    );
  }

  Widget _buildMenuItems(ProfileController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            'Change Password',
            Icons.lock_outline,
            controller.changePassword,
          ),
          Divider(height: 1),
          _buildMenuItem(
            'Terms & Conditions',
            Icons.description_outlined,
            controller.viewTerms,
          ),
          Divider(height: 1),
          _buildMenuItem(
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            controller.viewPrivacyPolicy,
          ),
          Divider(height: 1),
          _buildMenuItem(
            'FAQs',
            Icons.help_outline,
            controller.viewFAQs,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.grey.shade700),
            SizedBox(width: 12.w),
            Expanded(child: Text(title, style: AppTextStyles.s16w5i())),
            Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(ProfileController controller, authcontroller) {
    return Column(
      children: [
        ActionButton(
          onTap: controller.downloadSummary,
          gradient: AppColors.transparentGradiant,
          leftIcon: "assets/icons/add.png",
          leftIconbgColor: AppColors.secondaryGradient,
          title: 'Download Summary',
          titleColor: AppColors.black,
          rightIconbgColor: const Color(0xFFF3F4F6),
          desc: "From the start of your plan to today",
          descColor: const Color(0xFF4A5565),
          rightIconColor: const Color(0xFF364153),
          borderEnbale: true,
          rightIcon: Icons.download_sharp,
        ),

        SizedBox(height: 16.h),
        ActionButton(
          onTap: authcontroller.signOut,
          leftIcon: "assets/icons/fire.png",
          title: "Log Out",
          leftIconbgColor: AppColors.transparentGradiant,
          rightIconbgColor: AppColors.white.withOpacity(0.20),
          desc: "End your session securely.",
          descColor: const Color(0xFFffffff).withOpacity(0.8),
          rightIconColor: AppColors.white,
          iconBorderEnable: true,
          shadowOn: true,
          rightIcon: Icons.logout,
        ),
      ],
    );
  }
}
