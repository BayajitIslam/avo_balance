// widgets/faq_item_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class FAQItemWidget extends StatefulWidget {
  final String question;
  final String answer;
  final Gradient gradient;

  const FAQItemWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.gradient,
  });

  @override
  State<FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1),
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
            top: -8,
            bottom: -8,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(33554400),
                  bottomRight: Radius.circular(33554400),
                ),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question and Icon
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: AppTextStyles.s16w4i(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Plus/Minus Icon
                    AnimatedRotation(
                      duration: Duration(milliseconds: 300),
                      turns: isExpanded ? 0.125 : 0,
                      child: Icon(
                        Icons.add,
                        color: AppColors.brand,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Answer (Expandable)
              AnimatedCrossFade(
                firstChild: SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.only(top: 12.h, right: 8.w),
                  child: Text(
                    widget.answer,
                    style: AppTextStyles.s16w4i(
                      fontSize: 13.sp,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
