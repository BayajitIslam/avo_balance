// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    // Get controller safely
    NavigationController navController;

    try {
      navController = Get.find<NavigationController>();
    } catch (e) {
      navController = Get.put(NavigationController(), permanent: true);
    }

    // Set current page after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.setCurrentPage(0);
    });

    return MainScreen(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text(
                'Home',
                style: AppTextStyles.s22w7i(color: AppColors.brand),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.signOut();
              },
              child: Icon(Icons.delete),
            ),
            SizedBox(height: 32.h),

            // Your content here
          ],
        ),
      ),
    );
  }
}
