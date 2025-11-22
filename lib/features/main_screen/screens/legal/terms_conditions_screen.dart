// screens/terms_conditions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custom_section_container.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5F3), Color(0xFFF3E8F5), Color(0xFFE8EFF5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Our Story Section
                      CustomSectionContainer(
                        borderColor: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFF8904), Color(0xFFF6339A)],
                        ),
                        title: 'Our Story',
                        content:
                            'Printers in the 1500s scrambled the words from Cicero\'s "De Finibus Bonorum et Malorum" after mixing the words in each sentence. The familiar "lorem ipsum dolor sit amet" text emerged when 16th-century printers adapted Cicero\'s original work, beginning with the phrase "dolor sit amet consectetur.',
                      ),

                      SizedBox(height: 16.h),

                      // Our Mission Section
                      CustomSectionContainer(
                        borderColor: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFC27AFF), Color(0xFF2B7FFF)],
                        ),
                        title: 'Our Mission',
                        content:
                            'Printers in the 1500s scrambled the words from Cicero\'s "De Finibus Bonorum et Malorum" after mixing the words in each sentence. The familiar "lorem ipsum dolor sit amet" text emerged when 16th-century printers adapted Cicero\'s original work, beginning with the phrase "dolor sit amet consectetur.',
                      ),

                      SizedBox(height: 16.h),

                      // Our Vision Section
                      CustomSectionContainer(
                        borderColor: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFB64B6), Color(0xFFAD46FF)],
                        ),
                        title: 'Our Vision',
                        content:
                            'Printers in the 1500s scrambled the words from Cicero\'s "De Finibus Bonorum et Malorum" after mixing the words in each sentence. The familiar "lorem ipsum dolor sit amet" text emerged when 16th-century printers adapted Cicero\'s original work, beginning with the phrase "dolor sit amet consectetur.',
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
            ),
          ),
          Text(
            'Terms & Conditions',
            style: AppTextStyles.s22w7i(
              fontweight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 24.sp),
              SizedBox(width: 12.w),
              Icon(Icons.shopping_cart_outlined, size: 24.sp),
            ],
          ),
        ],
      ),
    );
  }
}
