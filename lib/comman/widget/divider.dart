import 'package:flutter/material.dart';
import '../../core/theme/a_color.dart';

class AppDivider extends StatelessWidget {
  final double? height;
  const AppDivider({super.key, this.height});
  @override
  Widget build(BuildContext context) =>
      Divider(color: AppColors.border, thickness: 0.5, height: height ?? 0);
}
