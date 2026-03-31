import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/a_color.dart';
import '../../core/theme/a_textstyle.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const SectionHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title, style: AppText.h2())],
        ),
      ),
      if (action != null) action!,
    ],
  );
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color accent;
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.accent = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: AppColors.border, width: 0.5.w),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value.replaceAll(RegExp(r'[+%]'), ''),
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHi,
                  height: 1,
                ),
              ),
              TextSpan(
                text: value.contains('+')
                    ? '+'
                    : value.contains('%')
                    ? '%'
                    : '',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.textLo,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
