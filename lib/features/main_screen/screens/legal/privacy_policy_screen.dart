// screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custom_section_container.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            CustomeHeader(title: "Privacy Policy"),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // Introduction Text
                    Text(
                      'This Privacy Policy describes how we collect, use, and protect your information when you use our Money Management App ("we," "our," or "us"). By using the app, you agree to this policy.',
                      style: AppTextStyles.s14w4i(color: AppColors.black),
                      textAlign: TextAlign.justify,
                    ),

                    SizedBox(height: 20.h),

                    // Information We Collect - WITH BULLET POINTS
                    CustomSectionContainer(
                      title: 'Information We Collect',
                      borderColor: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFF8904), Color(0xFFF6339A)],
                      ),
                      bulletPoints: [
                        'Personal details such as your name, email, and phone number.',
                        'Financial data you enter manually, such as income, expenses, and savings goals.',
                        'Device information (for performance and analytics).',
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // How We Use Your Data - WITH BULLET POINTS
                    CustomSectionContainer(
                      title: 'How We Use Your Data',
                      borderColor: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
                      ),
                      bulletPoints: [
                        'To track and visualize your spending and income.',
                        'To personalize insights, reminders, and budgeting tips.',
                        'To improve app performance and user experience.',
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Data Security - WITH CONTENT
                    CustomSectionContainer(
                      title: 'Data Security',
                      borderColor: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
                      ),
                      content:
                          'We use encryption and secure storage to keep your information safe. Your data is never sold to third parties.',
                    ),

                    SizedBox(height: 16.h),

                    // Third-Party Services - WITH CONTENT
                    CustomSectionContainer(
                      title: 'Third-Party Services',
                      borderColor: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFF8904), Color(0xFFF6339A)],
                      ),
                      content:
                          'Some app features may integrate with secure third-party services (like Google or Apple Sign-In). We never share your financial data without your consent.',
                    ),

                    SizedBox(height: 16.h),

                    // Your Control - WITH CONTENT
                    CustomSectionContainer(
                      title: 'Your Control',
                      borderColor: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
                      ),
                      content:
                          'You can delete your account and all data anytime from Settings → Delete Account.',
                    ),

                    SizedBox(height: 16.h),

                    // Policy Updates - WITH CONTENT
                    CustomSectionContainer(
                      title: 'Policy Updates',
                      borderColor: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
                      ),
                      content:
                          'We may update this policy from time to time. Any major change will be notified in-app or via email.',
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
