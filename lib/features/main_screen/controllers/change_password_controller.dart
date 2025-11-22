// controllers/change_password_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChangePasswordController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool showCurrentPassword = false.obs;
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  // Text Controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void toggleCurrentPassword() {
    showCurrentPassword.value = !showCurrentPassword.value;
  }

  void toggleNewPassword() {
    showNewPassword.value = !showNewPassword.value;
  }

  void toggleConfirmPassword() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  // Change Password
  Future<void> changePassword() async {
    // Validation
    if (currentPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your current password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter new password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (newPasswordController.text.trim().length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please confirm your new password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (currentPasswordController.text == newPasswordController.text) {
      Get.snackbar(
        'Error',
        'New password must be different from current password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // TODO: Call backend API
      /*
      await ApiService.changePassword({
        'current_password': currentPasswordController.text,
        'new_password': newPasswordController.text,
      });
      */

      // Clear fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Reset visibility
      showCurrentPassword.value = false;
      showNewPassword.value = false;
      showConfirmPassword.value = false;

      Get.back(); // Close screen

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
