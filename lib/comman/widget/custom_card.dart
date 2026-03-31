import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/a_color.dart';


class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding ??
          EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: AppColors.border, width: 0.5.w),
      ),
      child: child,
    ),
  );
}