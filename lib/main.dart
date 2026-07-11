import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/a_color.dart';
import 'core/theme/a_theme.dart';
import 'module/about/about.dart';
import 'module/contact/contact.dart';
import 'module/home/home.dart';
import 'module/project/project_screen.dart';
import 'module/skill/skill.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ypharoroeyxslaaoyktn.supabase.co',
    anonKey: 'sb_publishable__YKoy46VUO4VfQW2ke0DXg_63ocNQNb',
  );

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Portfolio',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: child,
        );
      },
      child: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    ProjectsScreen(),
    SkillsScreen(),
    AboutScreen(),
    ContactScreen(),
  ];

  static const _navItems = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(Icons.code_outlined, Icons.code_rounded, 'Projects'),
    _NavItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Skills'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'About'),
    _NavItem(Icons.mail_outline_rounded, Icons.mail_rounded, 'Contact'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: _index,
        items: _navItems,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: items.asMap().entries.map((e) {
              final active = currentIndex == e.key;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(e.key),
                  child: _NavTile(item: e.value, active: active),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool active;

  const _NavTile({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: active ? 20.w : 0,
          height: 2.5.h,
          margin: EdgeInsets.only(bottom: 5.h),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            active ? item.activeIcon : item.icon,
            key: ValueKey(active),
            size: 20.sp,
            color: active ? AppColors.accent : AppColors.textLo,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          item.label,
          style: GoogleFonts.poppins(
            fontSize: 9.sp,
            color: active ? AppColors.accent : AppColors.textLo,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
