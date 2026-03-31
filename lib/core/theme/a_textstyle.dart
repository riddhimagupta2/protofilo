import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'a_color.dart';

class AppText {
  static TextStyle display({Color? color}) => GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.textHi,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textHi,
    letterSpacing: -0.3,
  );

  static TextStyle h3({Color? color}) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textHi,
  );

  static TextStyle body({Color? color}) => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textMid,
    height: 1.7,
  );

  static TextStyle small({Color? color}) => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textMid,
  );

  static TextStyle label({Color? color}) => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textLo,
    letterSpacing: 1.2,
  );

  static TextStyle button({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );
}