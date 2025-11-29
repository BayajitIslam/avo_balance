import 'package:flutter/material.dart';

class AppColors {
  //-------------------------- App Gradients --------------------------//
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF00D095),
      Color(0xFF01CF96),
      Color(0xFF02CD99),
      Color(0xFF01C79D),
      Color(0xFF00C2A2),
    ],
  );

  static const LinearGradient ashGradiant = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF808080), Color(0xFF808080)],
  );

  //-------------------------- App Gradients --------------------------//
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6900), Color(0xFFFB2C36), Color(0xFFF6339A)],
  );

  //-------------------------- App Gradients --------------------------//
  static const LinearGradient container = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAD46FF), Color(0xFFF6339A), Color(0xFFFF6900)],
  );

  //-------------------------- App Gradients --------------------------//
  static const LinearGradient transparentGradiant = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FFFFFF), // 20% opacity
      Color(0x1AFFFFFF), // 10% opacity
    ],
  );

  //-------------------------- App Colors --------------------------//
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color textBlack = Color(0xFF272727);
  static const Color transparent = Colors.transparent;
  static const Color border = Color(0xFFCBD2E0);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFBABABA);
  static const Color error = Color(0xFFEA2A2A);
  static const Color brand = Color(0xFF02c29f);
  static const Color ash = Color(0xFF808080);
  static const Color greenLight = Color(0xFFECFBED);
}
