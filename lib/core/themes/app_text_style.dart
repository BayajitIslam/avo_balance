import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/constants/app_colors.dart';

class AppTextStyles {
  //------------------------------ Inter Font Styles --------------------------------//
  static TextStyle s14w4i({
    Color? color,
    double fontSize = 14,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.ash,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

  //------------------------------ Inter Font Styles --------------------------------//
  static TextStyle s30w8i({
    Color? color,
    double fontSize = 30,
    double lineHeight = 1,
    FontWeight fontweight = FontWeight.w800,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.textBlack,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: lineHeight,
    );
  }

  //------------------------------ Inter Font Styles --------------------------------//
  static TextStyle s16w5i({
    Color? color,
    double fontSize = 16,
    FontWeight fontweight = FontWeight.w500,
  }) {
    return GoogleFonts.inter(
      color: color ?? AppColors.textBlack,
      fontSize: fontSize.sp,
      fontWeight: fontweight,
      height: 1,
      
    );
  }
}
