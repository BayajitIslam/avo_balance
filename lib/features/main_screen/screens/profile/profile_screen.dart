// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/features/main_screen/controllers/profile_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:intl/intl.dart';
import 'package:template/features/main_screen/widgets/action_button.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/features/main_screen/widgets/edit_personal_data_dialog.dart';
import 'package:template/features/main_screen/widgets/semicircular_gauge_painter.dart';
import 'package:template/routes/routes_name.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final authController = Get.find<AuthController>();
    final navController = Get.find<NavigationController>();

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
                SizedBox(height: 25.h),
                CustomeHeader(title: "Profile"),
                SizedBox(height: 20.h),
                _buildProfileSection(controller),
                SizedBox(height: 16.h),
                _buildKYCBanner(controller),
                SizedBox(height: 16.h),
                _buildProgressCard(controller),
                SizedBox(height: 16.h),
                _buildPersonalDataCard(controller),
                SizedBox(height: 16.h),
                _buildChangesPassword(controller, navController),
                SizedBox(height: 16.h),
                _buildMenuItems(controller, navController),
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

  Widget _buildProfileSection(ProfileController controller) {
    final user = controller.user.value!;
    final navController = Get.find<NavigationController>();
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
            onTap: () {
              navController.clearSelection();
              Get.toNamed(RoutesName.editProfile);
            },
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
    final navController = Get.find<NavigationController>();
    if (!user.isPremium) return SizedBox.shrink();

    return InkWell(
      onTap: () {
        //route
        navController.clearSelection();
        Get.toNamed(RoutesName.changeSubscriptionScreen);
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildProgressCard(ProfileController controller) {
    final user = controller.user.value!;
    final progressPercentage = user.progressDays / user.totalDays;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.brand, width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCCCCCC),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Image.asset("assets/icons/flash_avo.png"),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Your Progress',
                        style: AppTextStyles.s18w5i(
                          fontweight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                  //
                  SizedBox(height: 16.h),
                  Text(
                    'You\'re on a ${user.progressDays}-day healthy eating\nstreak!',
                    style: AppTextStyles.s14w4i(
                      fontSize: 10.sp,
                      color: Colors.grey.shade600,
                      fontweight: FontWeight.w600,
                      lineHeight: 1.4,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              // Semicircular Gauge
              SizedBox(
                width: 90.w,
                height: 50.h,
                child: CustomPaint(
                  painter: SemiCircularGaugePainter(
                    percentage: progressPercentage,
                    activeColor: AppColors.brand,
                    inactiveColor: Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: const [
                                Color(0xFF9810FA),
                                Color(0xFFE60076),
                                Color(0xFFFF6900),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              '${user.progressDays}/${user.totalDays}',
                              style: AppTextStyles.s18w5i(
                                fontweight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Text(
                            'Balance',
                            style: AppTextStyles.s14w4i(
                              fontweight: FontWeight.w800,
                              fontSize: 8,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Section - Two Separate Containers
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCCCCCC),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: AppColors.brand,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brand,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Weekly',
                            style: AppTextStyles.s14w4i(
                              fontweight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: const [
                            Color(0xFF00D195),
                            Color(0xFF00C0A2),
                            Color(0xFF92D39B),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          '${user.weeklyPercentage}%',
                          style: AppTextStyles.s22w7i(
                            color: Colors
                                .white, // Must be white for gradient to show
                            fontSize: 40.sp,
                            fontweight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text('Balanced days', style: AppTextStyles.s14w4i()),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCCCCCC),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: AppColors.brand,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brand,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Cheat meals',
                            style: AppTextStyles.s14w4i(
                              fontweight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: const [Color(0xFF00D195), Color(0xFF00C0A2)],
                        ).createShader(bounds),
                        child: Text(
                          '${user.streakCount}',
                          style: AppTextStyles.s22w7i(
                            color: Colors
                                .white, // Must be white for gradient to show
                            fontSize: 40.sp,
                            fontweight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text('Logged', style: AppTextStyles.s14w4i()),
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

  Widget _buildPersonalDataCard(ProfileController controller) {
    final user = controller.user.value!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCCCCCC),
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
                style: AppTextStyles.s18w5i(fontweight: FontWeight.w800),
              ),
              InkWell(
                onTap: () {
                  // Show edit dialog
                  Get.dialog(
                    EditPersonalDataDialog(),
                    barrierDismissible: false,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      //text
                      Text(
                        'Edit',
                        style: AppTextStyles.s14w4i(
                          color: AppColors.white,
                          fontweight: FontWeight.w700,
                        ),
                      ),
                      //icon
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.edit_outlined,
                        size: 14.sp,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDataRow('Age', '${user.age} Years'),
          SizedBox(height: 16.h),
          _buildDataRow('Gender', user.gender),
          SizedBox(height: 16.h),
          _buildDataRow('Weight', '${user.weight} kg'),
          SizedBox(height: 16.h),
          _buildDataRow('Height', '${user.height.toInt()} cm'),
          SizedBox(height: 16.h),
          _buildDataRow('Goal', user.goal, isLast: true),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.s14w4i(
                color: AppColors.black,
                fontweight: FontWeight.w700,
              ),
            ),
            Text(value, style: AppTextStyles.s14w4i(color: AppColors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildChangesPassword(
    ProfileController controller,
    NavigationController navController,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCCCCCC),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem('Change Password', Icons.lock_outline, () {
            navController.clearSelection();
            Get.toNamed(RoutesName.changePasswordScreen);
          }),
          SizedBox(height: 15.h),
          _buildMenuItem('Delete Account', Icons.lock_outline, () {
            navController.clearSelection();
            Get.offAllNamed(RoutesName.signup);
          }, isLast: true),
        ],
      ),
    );
  }

  //build menu items setting
  Widget _buildMenuItems(
    ProfileController controller,
    NavigationController navController,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCCCCCC),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem('Terms & Conditions', Icons.description_outlined, () {
            navController.clearSelection();
            Get.toNamed(RoutesName.termsConditions);
          }),
          SizedBox(height: 15.h),
          _buildMenuItem('Privacy Policy', Icons.privacy_tip_outlined, () {
            navController.clearSelection();
            Get.toNamed(RoutesName.privacyPolicy, arguments: "login");
          }),
          SizedBox(height: 15.h),
          _buildMenuItem('FAQs', Icons.help_outline, () {
            navController.clearSelection();
            Get.toNamed(RoutesName.faqsScreen);
          }, isLast: true),
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFfafbfc),
          borderRadius: BorderRadius.circular(16.r),
        ),

        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.s14w4i(
                  fontweight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 30.sp, color: AppColors.black),
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
          leftIcon: "assets/icons/export.png",
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
          leftIcon: "assets/icons/el_off.png",
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
