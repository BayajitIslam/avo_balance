// controllers/subscription_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/features/splash/models/subscription_model.dart';

class SubscriptionController extends GetxController {
  final RxString selectedPlanId = ''.obs;
  final RxString currentPlanId = ''.obs; // Empty means no active subscription
  final RxBool isLoading = false.obs;
  final RxBool hasActiveSubscription =
      false.obs; // NEW: Track subscription status

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      id: 'monthly',
      title: 'Monthly',
      priceUSD: '4.99',
      priceEUR: '4.99',
      description: 'Perfect to start using the app and discover your balance',
      icon: '⭐',
      dailyCost: 'Only \$0.16/day',
    ),
    SubscriptionPlan(
      id: 'quarterly',
      title: 'Quarterly',
      priceUSD: '13.99',
      priceEUR: '13.99',
      description: 'Stay consistent and save while building new habits',
      icon: '🏆',
    ),
    SubscriptionPlan(
      id: 'annual',
      title: 'Annual',
      priceUSD: '49.99',
      priceEUR: '49.99',
      description: 'For those serious about long-term results and balance',
      icon: '👑',
      isBestValue: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadCurrentPlan();
  }

  // Load user's current subscription plan
  Future<void> loadCurrentPlan() async {
    try {
      // TODO: Load from backend/local storage
      // Example API call:
      // final response = await ApiService.getCurrentPlan();
      // currentPlanId.value = response['plan_id'] ?? '';
      // hasActiveSubscription.value = response['has_subscription'] ?? false;

      // For demo: Uncomment one scenario

      // Scenario 1: First time user (No subscription)
      currentPlanId.value = '';
      hasActiveSubscription.value = false;

      // Scenario 2: User has monthly subscription
      // currentPlanId.value = 'monthly';
      // hasActiveSubscription.value = true;

      // Scenario 3: User has annual subscription
      currentPlanId.value = 'annual';
      hasActiveSubscription.value = true;

      selectedPlanId.value = currentPlanId.value;
    } catch (e) {
      debugPrint('Error loading current plan: $e');
    }
  }

  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }

  bool isSelected(String planId) {
    return selectedPlanId.value == planId;
  }

  bool isCurrentPlan(String planId) {
    return currentPlanId.value == planId && hasActiveSubscription.value;
  }

  bool isUpgrade(String planId) {
    if (!hasActiveSubscription.value) return false;
    final currentIndex = plans.indexWhere((p) => p.id == currentPlanId.value);
    final newIndex = plans.indexWhere((p) => p.id == planId);
    return newIndex > currentIndex;
  }

  bool isDowngrade(String planId) {
    if (!hasActiveSubscription.value) return false;
    final currentIndex = plans.indexWhere((p) => p.id == currentPlanId.value);
    final newIndex = plans.indexWhere((p) => p.id == planId);
    return newIndex < currentIndex;
  }

  // Change subscription plan
  Future<void> changePlan() async {
    if (selectedPlanId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedPlanId.value == currentPlanId.value) {
      Get.snackbar(
        'Info',
        'This is your current plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // TODO: Call backend API
      // await ApiService.changePlan(selectedPlanId.value);

      currentPlanId.value = selectedPlanId.value;
      hasActiveSubscription.value = true;

      Get.back(); // Close subscription screen

      final planName = plans
          .firstWhere((p) => p.id == selectedPlanId.value)
          .title;

      Get.snackbar(
        'Success',
        'Your plan has been changed to $planName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change plan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
