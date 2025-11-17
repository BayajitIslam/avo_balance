import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/auth/controllers/auth_controller.dart';

class HomeScreen extends GetView<AuthController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            controller.signOut();
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
