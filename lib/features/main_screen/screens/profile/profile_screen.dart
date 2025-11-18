import 'package:flutter/material.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(child: Center(child: Text("Profile")));
  }
}
