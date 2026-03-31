import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/a_color.dart';

class SocialBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SocialBtn({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: AppColors.textMid,
        ),
      ),
    );
  }
}