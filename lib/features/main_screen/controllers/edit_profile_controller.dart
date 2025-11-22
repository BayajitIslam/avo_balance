// controllers/edit_profile_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/features/main_screen/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final RxBool isLoading = false.obs;

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Initialize with current user data
  void _initializeData() {
    final profileController = Get.find<ProfileController>();
    final user = profileController.user.value;

    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
    }
  }

  // Update Profile Picture
  Future<void> updateProfilePicture() async {
    try {
      // TODO: Implement image picker
      Get.snackbar(
        'Coming Soon',
        'Profile picture update will be available soon!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      // When ready:
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      // if (image != null) {
      //   isLoading.value = true;
      //   await ApiService.uploadProfilePicture(image.path);
      //   await Get.find<ProfileController>().loadUserData();
      //   isLoading.value = false;
      // }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Save Profile Changes
  Future<void> saveProfileChanges() async {
    // Validation
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // When backend is ready:
      // await ApiService.updateProfile({
      //   'name': nameController.text,
      //   'email': emailController.text,
      // });

      // Reload profile data
      await Get.find<ProfileController>().loadUserData();

      Get.back(); // Close edit screen

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
