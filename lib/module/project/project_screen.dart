import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:protofilo/comman/widget/error_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../comman/widget/divider.dart';
import '../../comman/widget/loader.dart';
import '../../comman/widget/stat_card.dart';
import '../../comman/widget/tech_chip.dart';
import '../../controller/project_cont..dart';
import '../../core/theme/a_color.dart';
import '../../core/theme/a_textstyle.dart';
import '../../data/model/project_model.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProjectsController());

    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) return const AppLoader();
        if (ctrl.errorMessage.isNotEmpty) {
          return ErrorView(
            message: ctrl.errorMessage.value,
            onRetry: ctrl.fetchProjects,
          );
        }

        return RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          onRefresh: ctrl.fetchProjects,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    24.w,
                    MediaQuery.of(context).padding.top + 24.h,
                    24.w,
                    20.h,
                  ),
                  child: SectionHeader(
                    title: 'Projects',
                    action: Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '${ctrl.filtered.length} items',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: _FilterBar(ctrl: ctrl)),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),

              Obx(() {
                final items = ctrl.filtered;
                if (items.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('No projects found.', style: AppText.body()),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _ProjectCard(project: items[i]),
                      ),
                      childCount: items.length,
                    ),
                  ),
                );
              }),

              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        );
      }),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final ProjectsController ctrl;
  const _FilterBar({required this.ctrl});
  static const _tags = ['All', 'Flutter', 'Firebase', 'Supabase'];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: _tags.length,
      itemBuilder: (_, i) => Obx(() {
        final active = ctrl.filter.value == _tags[i];
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: GestureDetector(
            onTap: () => ctrl.setFilter(_tags[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: active ? AppColors.accent : AppColors.border,
                  width: 0.5.w,
                ),
              ),
              child: Center(
                child: Text(
                  _tags[i],
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: active ? Colors.white : AppColors.textLo,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  const _ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border, width: 0.5.w),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160.h,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [

              project.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: project.thumbnailUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.surface2),
                      errorWidget: (_, __, ___) => _ThumbFallback(),
                    )
                  : _ThumbFallback(),

              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.surface.withOpacity(0.9),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),

              if (project.isFeatured)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Featured',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              Positioned(
                bottom: 10.h,
                left: 12.w,
                child: Wrap(
                  spacing: 6.w,
                  children: project.techStack
                      .take(3)
                      .map((t) => TechChip(t))
                      .toList(),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: AppText.h3(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 16.sp,
                    color: AppColors.accent,
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              Text(
                project.description,
                style: AppText.body(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),

              const AppDivider(),
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (project.liveUrl != null) ...[
                    _LinkBtn(
                      label: 'Live Demo',
                      icon: Icons.open_in_new_rounded,
                      url: project.liveUrl!,
                    ),
                    SizedBox(width: 16.w),
                  ],
                  if (project.githubUrl != null)
                    _LinkBtn(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      url: project.githubUrl!,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ThumbFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.surface2,
    child: Center(
      child: Icon(Icons.code_rounded, color: AppColors.textLo, size: 40.sp),
    ),
  );
}

class _LinkBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;
  const _LinkBtn({required this.label, required this.icon, required this.url});

  Future<void> _open() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _open,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: AppColors.accentLt),
        SizedBox(width: 5.w),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: AppColors.accentLt,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
