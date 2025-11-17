import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: () {}, child: Icon(Icons.logout)),
    );
  }
}
