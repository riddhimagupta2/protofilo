import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/a_color.dart';
import 'package:flutter/material.dart';

class TechChip extends StatelessWidget {
  final String label;
  final Color? color;
  const TechChip(this.label, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accent;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
            color: c.withOpacity(0.25), width: 0.5.w),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: c,
          )),
    );
  }
}