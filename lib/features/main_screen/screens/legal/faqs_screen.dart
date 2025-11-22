// screens/faqs_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/features/main_screen/widgets/faq_item_widget.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy FAQ Data
    final List<Map<String, dynamic>> faqData = [
      {
        'question': 'What does this app do?',
        'answer':
            'This app helps you manage your finances by tracking income, expenses, and budgets. You can visualize your spending patterns, set financial goals, and receive personalized insights to improve your financial health.',
        'gradient': LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF8904), Color(0xFFF6339A)],
        ),
      },
      {
        'question': 'How do I add an expense?',
        'answer':
            'To add an expense, tap the "+" button on the home screen, select "Add Expense", enter the amount, choose a category, add a description (optional), and tap "Save".',
        'gradient': LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
        ),
      },
      {
        'question': 'Can I export my financial data?',
        'answer':
            'Yes! You can export your financial data as PDF or CSV format. Go to Settings → Export Data, choose your preferred format and date range, then tap "Export".',
        'gradient': AppColors.primaryGradient,
      },
      {
        'question': 'Is my data secure?',
        'answer':
            'Absolutely! We use bank-level encryption to protect your data. Your information is stored securely and never shared with third parties without your consent.',
        'gradient': LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
        ),
      },
      {
        'question': 'How do I cancel my subscription?',
        'answer':
            'To cancel your subscription, go to Settings → Subscription → Manage Subscription → Cancel Subscription. Your access will continue until the end of your current billing period.',
        'gradient': LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF8904), Color(0xFFF6339A)],
        ),
      },
      {
        'question': 'What payment methods are supported?',
        'answer':
            'We support all major credit cards (Visa, Mastercard, American Express), debit cards, Google Pay, and Apple Pay for subscription payments.',
        'gradient': AppColors.primaryGradient,
      },
      {
        'question': 'How do I reset my password?',
        'answer':
            'On the login screen, tap "Forgot Password", enter your registered email address, and we\'ll send you a password reset link. Follow the instructions in the email to create a new password.',
        'gradient': LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
        ),
      },
      {
        'question': 'Can I use this app offline?',
        'answer':
            'Yes! You can add and view your expenses offline. All changes will sync automatically when you reconnect to the internet.',
        'gradient': LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
        ),
      },
    ];

    return MainScreen(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            CustomeHeader(title: "FAQ's"),

            // FAQ List - NO CONTROLLER, NO OBX
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: faqData.length,
                itemBuilder: (context, index) {
                  final faq = faqData[index];
                  return FAQItemWidget(
                    question: faq['question'],
                    answer: faq['answer'],
                    gradient: faq['gradient'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
