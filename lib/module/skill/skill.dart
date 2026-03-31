import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protofilo/comman/widget/error_view.dart';
import '../../comman/widget/loader.dart';
import '../../comman/widget/stat_card.dart';
import '../../controller/skill_cont..dart';
import '../../core/theme/a_color.dart';
import '../../data/model/skill_model.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SkillsController());

    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) return const AppLoader();
        if (ctrl.errorMessage.isNotEmpty) {
          return ErrorView(
            message: ctrl.errorMessage.value,
            onRetry: ctrl.fetchSkills,
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: const SectionHeader(title: 'Skills'),
              ),
              SizedBox(height: 28.h),

              ...ctrl.grouped.entries.map(
                (e) => Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                  child: _CategoryCard(category: e.key, skills: e.value),
                ),
              ),

              SizedBox(height: 100.h),
            ],
          ),
        );
      }),
    );
  }
}

Color _catColor(String cat) {
  switch (cat) {
    case 'Mobile':
      return AppColors.accent;
    case 'Backend':
      return AppColors.teal;
    case 'Tools':
      return AppColors.amber;
    default:
      return AppColors.accent;
  }
}

IconData _catIcon(String cat) {
  switch (cat) {
    case 'Mobile':
      return Icons.phone_android_rounded;
    case 'Backend':
      return Icons.dns_rounded;
    case 'Tools':
      return Icons.build_rounded;
    default:
      return Icons.code_rounded;
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final List<SkillModel> skills;
  const _CategoryCard({required this.category, required this.skills});

  @override
  Widget build(BuildContext context) {
    final color = _catColor(category);
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(_catIcon(category), size: 18.sp, color: color),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHi,
                  ),
                ),
              ),
              Text(
                '${skills.length} skills',
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: AppColors.textLo,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          ...skills.asMap().entries.map(
            (e) => _SkillBar(skill: e.value, color: color, delay: e.key * 80),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatefulWidget {
  final SkillModel skill;
  final Color color;
  final int delay;
  const _SkillBar({
    required this.skill,
    required this.color,
    required this.delay,
  });

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final Animation<double> _anim = CurvedAnimation(
    parent: _ac,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200 + widget.delay), () {
      if (mounted) _ac.forward();
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.skill.name,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textHi,
              ),
            ),
            AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Text(
                '${(widget.skill.proficiency * _anim.value).round()}%',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => LinearProgressIndicator(
              value: (widget.skill.proficiency / 100) * _anim.value,
              minHeight: 4.h,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            ),
          ),
        ),
      ],
    ),
  );
}
