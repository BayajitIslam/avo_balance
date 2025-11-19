// controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// UserModel class directly here
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String goal;
  final bool isPremium;
  final DateTime? premiumExpiryDate;
  final int progressDays;
  final int totalDays;
  final int weeklyPercentage;
  final int streakCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.goal,
    required this.isPremium,
    this.premiumExpiryDate,
    required this.progressDays,
    required this.totalDays,
    required this.weeklyPercentage,
    required this.streakCount,
  });
}

// ProfileController class
class ProfileController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;

    try {
      await Future.delayed(Duration(seconds: 1));

      user.value = UserModel(
        id: '1',
        name: 'Bayajit Islam',
        email: 'realbayajitislam@gmail.com',
        avatar:
            'https://scontent.fdac207-1.fna.fbcdn.net/v/t39.30808-1/561003502_682691301541156_5850239970240901708_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=101&ccb=1-7&_nc_sid=1d2534&_nc_ohc=Ji2gMUHHHtAQ7kNvwFNb1ca&_nc_oc=AdlfZgcR03aTxwc3lBERHjt8kZy1pF908z_SLjQJRHI6iJwmiOBK0t20sxhisCQGQWY&_nc_zt=24&_nc_ht=scontent.fdac207-1.fna&_nc_gid=PFODqptEmRC_68M16t2drw&oh=00_AfgfB-MVBG6OJT_CxGdajBEw1rublsEbtW5uh8MBHAlcAQ&oe=69237A6E',
        age: 28,
        gender: 'Male',
        weight: 70.8,
        height: 168,
        goal: 'Lose weight',
        isPremium: true,
        premiumExpiryDate: DateTime(2025, 12, 15),
        progressDays: 24,
        totalDays: 30,
        weeklyPercentage: 65,
        streakCount: 65,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfilePicture() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('Profile picture update feature will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }

  void editPersonalData(String field) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('Edit $field feature will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }

  void changePassword() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('Change password feature will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }

  void downloadSummary() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('Download summary feature will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }

  void viewTerms() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('Terms & Conditions page will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }

  void viewPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('Privacy Policy page will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }

  void viewFAQs() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon'),
        content: Text('FAQs page will be available soon!'),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );
  }
}
