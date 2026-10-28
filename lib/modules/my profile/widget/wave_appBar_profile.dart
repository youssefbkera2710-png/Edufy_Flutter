import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/controller/support_controller.dart';
import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:edufy/core/shared/widgets/show_dialog.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/modules/my%20profile/my_profile_controller.dart';
import 'package:edufy/modules/my%20profile/widget/icon_circle_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:get/get.dart';

AppBar waveAppBarProfile(BuildContext context, String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: MediaQuery.of(context).size.height * 0.10,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: ResponsiveWidget(
      builder: (sizer) => Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.string(
              '''
<svg width="390" height="160" viewBox="0 0 390 160" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="gradSchoolCustom" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#25BEB2" /> <stop offset="100%" stop-color="#0C4765" /> </linearGradient>
  </defs>

  <path d="M0 0H390V115C390 115 300 135 195 135C90 135 0 115 0 115V0Z" fill="url(#gradSchoolCustom)"/>

  <g transform="translate(320, 30) rotate(15)" opacity="0.15">
    <rect x="0" y="5" width="6" height="30" rx="1" fill="white"/>
    <path d="M0 5L3 -2L6 5H0Z" fill="white"/>
    <rect x="0" y="30" width="6" height="4" fill="white" opacity="0.5"/> 
  </g>

  <g transform="translate(40, 50) rotate(-20)" opacity="0.12">
    <rect x="0" y="0" width="40" height="12" rx="2" fill="white"/>
    <rect x="5" y="2" width="1" height="4" fill="#0C4765" opacity="0.4"/>
    <rect x="15" y="2" width="1" height="4" fill="#0C4765" opacity="0.4"/>
    <rect x="25" y="2" width="1" height="4" fill="#0C4765" opacity="0.4"/>
    <rect x="35" y="2" width="1" height="4" fill="#0C4765" opacity="0.4"/>
  </g>

  <g transform="translate(185, 25)" opacity="0.1">
    <path d="M0 2C0 0.89 0.89 0 2 0H10V18H2C0.89 18 0 17.11 0 16V2Z" fill="white"/>
    <path d="M11 0H19C20.11 0 21 0.89 21 2V16C21 17.11 20.11 18 19 18H11V0Z" fill="white"/>
  </g>

  <circle cx="280" cy="80" r="2" fill="white" opacity="0.2"/>
  <circle cx="100" cy="35" r="3" fill="white" opacity="0.1"/>
  <circle cx="200" cy="90" r="1.5" fill="white" opacity="0.2"/>
  
  <path d="M0 60C120 80 280 30 390 70" stroke="white" stroke-opacity="0.04" stroke-width="8" fill="none"/>
  <path d="M0 20C150 40 300 0 390 30" stroke="white" stroke-opacity="0.03" stroke-width="4" fill="none"/>
</svg>

''',
              width: sizer.w(390),
              height: sizer.h(120),
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            right: sizer.w(6),
            top: sizer.h(35),
            child: IconButton(
              icon: Icon(FluentIcons.settings_32_filled),
              onPressed: () {
                _toggleFloatingPanel(context);
              },
            ),
          ),
          Positioned(
            right: sizer.w(65),
            top: sizer.h(40),
            child: Text(
              title,
              style: context.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: sizer.fontSize(26),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

OverlayEntry? _overlayEntry;

void _toggleFloatingPanel(BuildContext context) {
  final ThemeController themeController = Get.find();
  final SupportController controllerSupport = Get.find();
  final MyProfileController myProfileController = Get.find();
  final size = MediaQuery.of(context).size;
  final isRtl = true;

  if (_overlayEntry != null) {
    _overlayEntry!.remove();
    _overlayEntry = null;
    return;
  }

  _overlayEntry = OverlayEntry(
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      },
      child: Stack(
        children: [
          Positioned(
            top: kToolbarHeight + 10,
            left: isRtl ? 16 : null,
            right: isRtl ? null : 16,
            child: Material(
              color: Colors.transparent,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final panelWidth = size.width < 600
                      ? size.width * 0.8
                      : size.width * 0.45;

                  return Container(
                    width: panelWidth,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              themeController.isDarkMode.value
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny,
                              color: context.primary,
                            ),
                            title: Text(
                              themeController.isDarkMode.value
                                  ? AppString.lightMode
                                  : AppString.darkMode,
                              style: TextStyle(
                                color: context.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Switch(
                              value: themeController.isDarkMode.value,
                              onChanged: (_) => themeController.toggleTheme(),
                              activeColor: context.primary,
                            ),
                          ),

                          const Divider(height: 1),
                          const SizedBox(height: 20),

                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              _overlayEntry?.remove();
                              _overlayEntry = null;
                              controllerSupport.openWhatsApp();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                              child: Row(
                                children: [
                                  iconCircle(
                                    icon: Icons.chat,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      ' تواصل مع الاِدارة ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 4),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              final primaryColor = context.primary;

                              _overlayEntry?.remove();
                              _overlayEntry = null;

                              ShowDialog.show(
                                context: Get.context!,
                                title: 'تسجيل الخروج',
                                message: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                                confirmText: 'تأكيد',
                                cancelText: 'الغاء',
                                icon: Icons.logout_rounded,
                                iconColor: Colors.red,
                                confirmButtonColor: primaryColor,
                                showCancelButton: true,
                                onConfirm: () async {
                                  progressDef(Get.context!);
                                  final result = await myProfileController
                                      .logoutOnClick();
                                  if (result != null && result.status == 200) {
                                    snackBarDef(
                                      'تم',
                                      result.message ?? "تم تسجيل الخروج بنجاح",
                                    );
                                    Get.offAllNamed('/login');
                                  } else {
                                    snackBarDef(
                                      'خطأ',
                                      result?.message ?? 'حدث خطأ غير متوقع',
                                    );
                                  }
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                              child: Row(
                                children: [
                                  iconCircle(
                                    icon: Icons.logout,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'تسجيل الخروج',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Overlay.of(context).insert(_overlayEntry!);
}
