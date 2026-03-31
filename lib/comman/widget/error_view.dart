import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/a_color.dart';
import '../../core/theme/a_textstyle.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.cloud_off_rounded,
            color: AppColors.textLo, size: 48.sp),
        SizedBox(height: 16.h),
        Text(message,
            style: AppText.body(),
            textAlign: TextAlign.center),
        SizedBox(height: 20.h),
        ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry', style: AppText.button())),
      ]),
    ),
  );
  }

