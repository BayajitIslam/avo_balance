// widgets/custom_section_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/themes/app_text_style.dart';

class CustomSectionContainer extends StatelessWidget {
  final String title;
  final String? content; // Made optional
  final List<String>? bulletPoints; // NEW: Bullet points support
  final Gradient? borderColor;

  const CustomSectionContainer({
    super.key,
    required this.title,
    this.content,
    this.bulletPoints,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCFCFCF),
            blurRadius: 10,
            spreadRadius: -6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Left gradient border
          Positioned(
            left: -16.w,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                gradient: borderColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(33554400),
                  bottomRight: Radius.circular(33554400),
                ),
              ),
            ),
          ),

          // All Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: AppTextStyles.s16w5i(fontweight: FontWeight.w800),
              ),

              SizedBox(height: 12.h),

              // Content (if provided)
              if (content != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    content!,
                    style: AppTextStyles.s16w4i(),
                    textAlign: TextAlign.justify,
                  ),
                ),

              // Bullet Points (if provided)
              if (bulletPoints != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bulletPoints!
                        .map(
                          (point) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 6.h,
                                    right: 8.w,
                                  ),
                                  child: Container(
                                    width: 5.w,
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: AppTextStyles.s16w4i(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
