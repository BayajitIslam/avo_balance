// layouts/main_layout.dart
import 'package:flutter/material.dart';
import 'package:template/features/main_screen/widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;

  const MainScreen({super.key, required this.child, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
      bottomNavigationBar: showBottomNav ? CustomBottomNavBar() : null,
    );
  }
}
