import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../comman/widget/divider.dart';
import '../../comman/widget/stat_card.dart';
import '../../controller/contact_cont..dart';
import '../../core/theme/a_color.dart';
import '../../core/theme/a_textstyle.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  late final ContactController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(ContactController());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 10.h),
          SectionHeader(title: 'Contact'),
          SizedBox(height: 24.h),

          _QuickContact(),
          SizedBox(height: 24.h),
          const AppDivider(),
          SizedBox(height: 24.h),

          Obx(
            () => ctrl.isSent.value
                ? _SuccessView(onReset: ctrl.resetSent)
                : _Form(
                    ctrl: ctrl,
                    nameCtrl: _nameCtrl,
                    emailCtrl: _emailCtrl,
                    msgCtrl: _msgCtrl,
                  ),
          ),

          SizedBox(height: 100.h),
        ],
      ),
    ),
  );
}

class _QuickContact extends StatelessWidget {
  static const _items = [
    (Icons.email_outlined, 'Email', 'mailto:riddhimag226@gmail.com'),
    (
      Icons.link_rounded,
      'LinkedIn',
      'https://www.linkedin.com/in/riddhimagupta22',
    ),
    (Icons.code_rounded, 'GitHub', 'https://github.com/riddhimagupta2'),
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: _items
        .map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () => _launchUrl(item.$3),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.border, width: 0.5.w),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.accentBg,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        item.$1,
                        size: 18.sp,
                        color: AppColors.accent,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          item.$3
                              .replaceAll('mailto:', '')
                              .replaceAll('https://', '')
                              .replaceAll('www.', ''),
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHi,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: AppColors.textLo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList(),
  );
}

class _Form extends StatelessWidget {
  final ContactController ctrl;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController msgCtrl;
  const _Form({
    required this.ctrl,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.msgCtrl,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Send a Message', style: AppText.h3()),
      SizedBox(height: 20.h),

      _Field(
        label: 'FULL NAME',
        hint: 'Enter your name',
        ctrl: nameCtrl,
        onChanged: ctrl.nameCtrl.updateText,
        prefix: Icons.person_outline_rounded,
      ),
      SizedBox(height: 14.h),

      _Field(
        label: 'EMAIL ADDRESS',
        hint: 'your@email.com',
        ctrl: emailCtrl,
        onChanged: ctrl.emailCtrl.updateText,
        prefix: Icons.email_outlined,
        type: TextInputType.emailAddress,
      ),
      SizedBox(height: 14.h),

      _Field(
        label: 'MESSAGE',
        hint: 'Write your message here...',
        ctrl: msgCtrl,
        onChanged: ctrl.messageCtrl.updateText,
        maxLines: 5,
      ),

      Obx(
        () => ctrl.error.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        ctrl.error.value,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),

      SizedBox(height: 20.h),

      Obx(
        () => ElevatedButton(
          onPressed: ctrl.isSending.value ? null : ctrl.sendMessage,
          style: ElevatedButton.styleFrom(
            backgroundColor: ctrl.isSending.value
                ? AppColors.accent.withOpacity(0.5)
                : AppColors.accent,
          ),
          child: ctrl.isSending.value
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send Message', style: AppText.button()),
                    SizedBox(width: 8.w),
                    Icon(Icons.send_rounded, size: 16.sp, color: Colors.white),
                  ],
                ),
        ),
      ),
    ],
  );
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController ctrl;
  final ValueChanged<String> onChanged;
  final IconData? prefix;
  final int maxLines;
  final TextInputType type;

  const _Field({
    required this.label,
    required this.hint,
    required this.ctrl,
    required this.onChanged,
    this.prefix,
    this.maxLines = 1,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppText.label()),
      SizedBox(height: 8.h),
      TextField(
        controller: ctrl,
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: type,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          color: AppColors.textHi,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefix != null && maxLines == 1
              ? Icon(prefix, size: 18.sp, color: AppColors.textLo)
              : null,
        ),
      ),
    ],
  );
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onReset;
  const _SuccessView({required this.onReset});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(28.w),
    decoration: BoxDecoration(
      color: AppColors.tealBg,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.teal.withOpacity(0.3), width: 0.5.w),
    ),
    child: Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, color: AppColors.teal, size: 32.sp),
        ),
        SizedBox(height: 16.h),
        Text(
          'Message Sent! 🎉',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textHi,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Thanks for reaching out!\nI'll get back to you soon.",
          style: AppText.small(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        TextButton(
          onPressed: onReset,
          child: Text(
            'Send another message →',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: AppColors.accentLt,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
