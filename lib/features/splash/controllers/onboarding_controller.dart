// onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/routes/routes_name.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingData> pages = [
    OnboardingData(
      title: "FOLLOWING A DIET\nISN'T EASY.",
      description:
          "You try to stay consistent, but life happens — dinners out, cravings, busy days.",
      imagePath: "assets/images/helthyFood.png",
      description2: "",
    ),
    OnboardingData(
      title: "THAT'S WHY WE\nCREATED AVO.",
      description:
          "Your smart nutrition partner that keeps you on track, even when you cheat.",
      imagePath: "assets/images/food.png",
      description2:
          "Upload your diet, snap your meal, and AVO adjusts\nyour diet automatically.",
    ),
    OnboardingData(
      title: "NO GUILT. NO WASTED\nEFFORT.",
      description:
          "AVO helps you stay consistent, protect your progress, and make every diet worth it.",
      imagePath: "assets/images/Chart.png",
      description2: "Perfect for everyone, from athletes to beginners.",
    ),
  ];

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void skipOnboarding() {
    finishOnboarding();
  }

  Future<void> finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.toNamed(RoutesName.subscriptionPackage);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final String description2;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.description2,
  });
}
