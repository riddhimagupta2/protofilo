import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../comman/widget/divider.dart';
import '../../comman/widget/error_view.dart';
import '../../comman/widget/loader.dart';
import '../../comman/widget/stat_card.dart';
import '../../controller/about_cont..dart';
import '../../core/theme/a_color.dart';
import '../../core/theme/a_textstyle.dart';
import '../../data/model/about_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AboutController());

    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) return const AppLoader();
        if (ctrl.errorMessage.isNotEmpty) {
          return ErrorView(
            message: ctrl.errorMessage.value,
            onRetry: ctrl.fetchAbout,
          );
        }

        final about = ctrl.about.value;
        if (about == null) {
          return Center(child: Text('No data.', style: AppText.body()));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10.h),
              SectionHeader(title: 'About'),
              SizedBox(height: 24.h),

              ProfileCard(about: about),
              SizedBox(height: 16.h),

              BioCard(about: about),
              SizedBox(height: 16.h),

              InfoGrid(about: about),
              SizedBox(height: 16.h),

              PositionsCard(),
              SizedBox(height: 16.h),

              AchievementsCard(),
              SizedBox(height: 16.h),

              if (about.resumeUrl != null) ResumeCard(url: about.resumeUrl!),

              SizedBox(height: 100.h),
            ],
          ),
        );
      }),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final AboutModel about;
  const ProfileCard({required this.about});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border, width: 0.5.w),
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(imageUrl: about.profileImageUrl),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riddhima Gupta',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHi,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.accent, AppColors.teal],
                    ).createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
                    child: Text(
                      about.tagline,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13.sp,
                        color: AppColors.textLo,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        about.location,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColors.textLo,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 13.sp,
                        color: AppColors.textLo,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${about.yearsOfExperience}+ Years Experience',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColors.textLo,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),
        const AppDivider(),
        SizedBox(height: 16.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (about.githubUrl != null)
              SocialItem(
                icon: Icons.code_rounded,
                label: 'GitHub',
                url: about.githubUrl!,
              ),
            if (about.linkedinUrl != null)
              SocialItem(
                icon: Icons.link_rounded,
                label: 'LinkedIn',
                url: about.linkedinUrl!,
              ),
            if (about.twitterUrl != null)
              SocialItem(
                icon: Icons.alternate_email_rounded,
                label: 'Twitter',
                url: about.twitterUrl!,
              ),
          ],
        ),
      ],
    ),
  );
}

class SocialItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const SocialItem({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    },
    child: Column(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.accentBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.accent),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
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

class Avatar extends StatelessWidget {
  final String? imageUrl;
  const Avatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = 80.w;
    Widget child;
    if (imageUrl != null) {
      child = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => Initials(size: size),
        errorWidget: (_, __, ___) => Initials(size: size),
      );
    } else {
      child = Initials(size: size);
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.accentBg,
      child: ClipOval(
        child: SizedBox(width: size, height: size, child: child),
      ),
    );
  }
}

class Initials extends StatelessWidget {
  final double size;
  const Initials({required this.size});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.accent, AppColors.teal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Text(
        'YN',
        style: GoogleFonts.poppins(
          fontSize: size * 0.28,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class BioCard extends StatelessWidget {
  final AboutModel about;
  const BioCard({required this.about});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border, width: 0.5.w),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ABOUT ME', style: AppText.label()),
        SizedBox(height: 10.h),
        Text(about.bio, style: AppText.body()),
      ],
    ),
  );
}

class InfoGrid extends StatelessWidget {
  final AboutModel about;
  const InfoGrid({required this.about});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.star_outline_rounded,
        'Experience',
        '${about.yearsOfExperience}+ Years',
      ),
      (Icons.location_city_rounded, 'Location', about.location),
      (Icons.layers_rounded, 'Primary Stack', 'Flutter · Supabase'),
      (Icons.check_circle_outline, 'Status', 'Open to Work'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border, width: 0.5.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.$1, size: 18.sp, color: AppColors.accent),
              SizedBox(height: 6.h),
              Text(
                item.$2,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: AppColors.textLo,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                item.$3,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHi,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class PositionsCard extends StatelessWidget {
  static const _roles = [
    (
      Icons.groups_rounded,
      AppColors.accent,
      'Core Member — GDG onCampus MM(DU)',
      'Sept 2024 – Present',
      'Organized hackathons, workshops & developer events. '
          'Managed logistics and community engagement.',
    ),
    (
      Icons.event_rounded,
      AppColors.teal,
      'Organizer — Tech Hunt 2.0',
      'Sept 2025 · 100+ participants',
      'Managed event planning, coordination and overall execution.',
    ),
    (
      Icons.rocket_launch_rounded,
      AppColors.amber,
      'Organizer — Hackureka 2.0',
      'Feb 2026 · National Level · Powered by Unstop',
      '600+ registrations, 300+ participants from multiple institutions.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border, width: 0.5.w),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.badge_outlined,
                size: 16.sp,
                color: AppColors.teal,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Positions & Events',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textHi,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        AppDivider(),
        SizedBox(height: 16.h),

        ..._roles.asMap().entries.map((e) {
          final r = e.value;
          final isLast = e.key == _roles.length - 1;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: r.$2.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(r.$1, size: 16.sp, color: r.$2),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.$3,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHi,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          r.$4,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: r.$2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          r.$5,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: AppColors.textMid,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                SizedBox(height: 12.h),
                Divider(color: AppColors.border, thickness: 0.5.h, height: 0),
                SizedBox(height: 12.h),
              ],
            ],
          );
        }),
      ],
    ),
  );
}

class AchievementsCard extends StatelessWidget {
  static const _items = [
    (
      Icons.emoji_events_rounded,
      AppColors.amber,
      '1st Runner-Up — Tech4SDG 2.0 Ideathon',
      'Feb 2026',
      'Innovative idea aligned with Sustainable Development Goals',
    ),
    (
      Icons.workspace_premium_rounded,
      AppColors.accent,
      'Finalist — Hackureka Hackathon',
      'Feb 2025',
      'GDG, Maharishi Markandeshwar University',
    ),
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border, width: 0.5.w),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                size: 16.sp,
                color: AppColors.amber,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Achievements',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textHi,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        AppDivider(),
        SizedBox(height: 16.h),

        ..._items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == _items.length - 1;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: item.$2.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(item.$1, size: 18.sp, color: item.$2),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$3,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHi,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          item.$5,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: AppColors.textMid,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: item.$2.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            item.$4,
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              color: item.$2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                SizedBox(height: 12.h),
                Divider(color: AppColors.border, thickness: 0.5.h, height: 0),
                SizedBox(height: 12.h),
              ],
            ],
          );
        }),
      ],
    ),
  );
}

class ResumeCard extends StatelessWidget {
  final String url;
  const ResumeCard({required this.url});

  Future<void> _download() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.accent.withOpacity(0.15),
          AppColors.teal.withOpacity(0.15),
        ],
      ),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: AppColors.accent.withOpacity(0.3),
        width: 0.5.w,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resume / CV',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHi,
                ),
              ),
              SizedBox(height: 4.h),
              Text('Download my full CV as PDF', style: AppText.small()),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: _download,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_rounded, size: 16.sp, color: Colors.white),
                SizedBox(width: 6.w),
                Text(
                  'Download',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
