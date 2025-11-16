import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:template/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  //
  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [
              Color(0xFF00D095),
              Color(0xFF01CF96),
              Color(0xFF02CD99),
              Color(0xFF01C79D),
              Color(0xFF00C2A2),
            ],
          ),
        ),
        child: const Center(
          child: ImageIcon(
            AssetImage("assets/icons/icon.png"),
            color: Colors.white,
            size: 200,
          ),
        ),
      ),
    );
  }
}
