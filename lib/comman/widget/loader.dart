import 'package:flutter/material.dart';
import '../../core/theme/a_color.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(
        color: AppColors.accent, strokeWidth: 1.5),
  );
}
