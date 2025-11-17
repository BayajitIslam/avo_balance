// controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/features/auth/models/user_model.dart';
import 'package:template/routes/routes_name.dart';

class AuthController extends GetxController {
  // Sign Up Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  // Sign In Form Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Observable States
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final RxString errorMessage = ''.obs;

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Sign Up
  Future<void> signUp() async {
    if (!_validateSignUpForm()) return;

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.signUp(
      //   name: nameController.text.trim(),
      //   email: emailController.text.trim(),
      //   password: passwordController.text,
      //   phone: phoneController.text.trim(),
      // );

      // Mock Response (Remove this and use actual API)
      await Future.delayed(Duration(seconds: 2));

      final userData = {
        'id': '123',
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'token': 'mock_token_12345',
      };

      final user = UserModel.fromJson(userData);
      currentUser.value = user;

      // Save to SharedPreferences
      await _saveUserData(user);

      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to Home
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign In
  Future<void> signIn() async {
    if (!_validateSignInForm()) return;

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.signIn(
      //   email: loginEmailController.text.trim(),
      //   password: loginPasswordController.text,
      // );

      // Mock Response (Remove this and use actual API)
      await Future.delayed(Duration(seconds: 2));

      final userData = {
        'id': '123',
        'name': 'John Doe',
        'email': loginEmailController.text.trim(),
        'token': 'mock_token_12345',
      };

      final user = UserModel.fromJson(userData);
      currentUser.value = user;

      // Save to SharedPreferences
      await _saveUserData(user);

      Get.snackbar(
        'Success',
        'Welcome back!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to Home
      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
    Get.offAllNamed(RoutesName.login);
  }

  // Validate Sign Up Form
  bool _validateSignUpForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }
    return true;
  }

  // Validate Sign In Form
  bool _validateSignInForm() {
    if (loginEmailController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(loginEmailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    if (loginPasswordController.text.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    return true;
  }

  // Save User Data to SharedPreferences
  Future<void> _saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id ?? '');
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('auth_token', user.token ?? '');
    await prefs.setBool('is_logged_in', true);
  }
}
