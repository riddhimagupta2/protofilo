import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../comman/widget/dot.dart';
import '../../comman/widget/stat_card.dart';
import '../../comman/widget/tech_chip.dart';
import '../../controller/home_cont..dart';
import '../../core/theme/a_color.dart';
import '../../core/theme/a_textstyle.dart';
import '../contact/contact.dart';
import '../project/project_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(
        () => AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: ctrl.isVisible.value ? 1 : 0,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 24.h),
                Hero(),
                SizedBox(height: 2.h),
                Stats(),
                SizedBox(height: 32.h),
                TechStack(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        top: -40.h,
        right: -60.w,
        child: Container(
          width: 280.w,
          height: 280.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.accent.withOpacity(0.15), Colors.transparent],
            ),
          ),
        ),
      ),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Badge(),
            SizedBox(height: 20.h),

            Text(
              'Hello, I\'m 👋',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                color: AppColors.textMid,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Riddhima Gupta',
              style: GoogleFonts.poppins(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textHi,
                height: 1.05,
                letterSpacing: -1,
              ),
            ),

            SizedBox(height: 4.h),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (b) => LinearGradient(
                colors: [AppColors.accent, AppColors.teal],
              ).createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
              child: Text(
                'Flutter Developer',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(height: 6.h),

            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.sp,
                  color: AppColors.textLo,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Haryana, India',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.textLo,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Text(
              'I build performant mobile apps & scalable backends '
              'using Flutter, Supabase, and GetX. Clean code, great UX.',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.textMid,
                height: 1.7,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 28.h),

            LayoutBuilder(
              builder: (ctx, constraints) {
                final wide = constraints.maxWidth > 400;
                if (wide) {
                  return Row(
                    children: [
                      Expanded(child: PrimaryBtn()),
                      SizedBox(width: 12.w),
                      Expanded(child: SecondaryBtn()),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryBtn(),
                    SizedBox(height: 10.h),
                    SecondaryBtn(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}

class Badge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
    decoration: BoxDecoration(
      color: AppColors.tealBg,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColors.teal.withOpacity(0.3), width: 0.5.w),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PulseDot(color: AppColors.teal),
        SizedBox(width: 8.w),
        Text(
          'Open to work',
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: AppColors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class PrimaryBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => Get.to(() => ProjectsScreen()),
          child: Text(
            'View Projects',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Icon(Icons.arrow_forward_rounded, size: 16.sp, color: Colors.white),
      ],
    ),
  );
}

class SecondaryBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      side: BorderSide(color: AppColors.border, width: 0.5.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
    ),
    child: TextButton(
      onPressed: () => Get.to(() => ContactScreen()),
      child: Text(
        'Contact Me',
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textMid,
        ),
      ),
    ),
  );
}

class Stats extends StatelessWidget {
  const Stats();

  static const data = [
    ('2+', 'Years of Experience', AppColors.accent),
    ('5+', 'Apps Built', AppColors.teal),
    ('8+', 'Technologies', AppColors.amber),
    ('Member', 'Google Developer Group\nOnCampus MM(DU)', AppColors.accent),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GridView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          final item = data[index];

          return StatCard(value: item.$1, label: item.$2, accent: item.$3);
        },
      ),
    );
  }
}

class TechStack extends StatelessWidget {
  static const tags = [
    ('Flutter', AppColors.accent),
    ('Dart', AppColors.accent),
    ('GetX', AppColors.accent),
    ('Supabase', AppColors.teal),
    ('Python', AppColors.teal),
    ('C++', AppColors.textMid),
    ('C', AppColors.textMid),
    ('Firebase', AppColors.amber),
    ('Git', AppColors.amber),
    ('Figma', AppColors.amber),
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TECH STACK', style: AppText.label(color: AppColors.textLo)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: tags.map((t) => TechChip(t.$1, color: t.$2)).toList(),
        ),
      ],
    ),
  );
}
