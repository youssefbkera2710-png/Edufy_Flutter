import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/dashbord/widgets/add_menu.dart';
import 'package:edufy/modules/education%20content/education_content_screen.dart';
import 'package:edufy/modules/home/home_screen.dart';
import 'package:edufy/modules/my%20profile/my_profile_screen.dart';
import 'package:edufy/modules/my%20schedule/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: ResponsiveWidget(
        builder: (sizer) {
          final double iconSize = sizer.w(20);
          final double navBarHeight = sizer.h(90);
          final double addButtonSize = sizer.w(42);

          return PersistentTabView(
            controller: _controller,
            tabs: [
              _tab(
                title: AppString.dashboardHome,
                icon: FluentIcons.home_24_filled,
                iconSize: iconSize,
                screen: HomeScreen(),
                context: context,
              ),
              _tab(
                title: AppString.mySchedule,
                icon: FluentIcons.calendar_24_filled,
                iconSize: iconSize,
                screen: ScheduleScreen(),
                context: context,
              ),

              if (UserInfo.role == "teacher")
                PersistentTabConfig.noScreen(
                  onPressed: (context) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AddMenu(),
                    );
                  },
                  item: ItemConfig(
                    title: AppString.dashboardAdd,
                    textStyle: TextStyle(
                      fontSize: sizer.w(10),
                      fontWeight: FontWeight.w500,
                    ),
                    activeForegroundColor: context.primary,
                    inactiveForegroundColor: context.grey750,
                    icon: Container(
                      width: addButtonSize,
                      height: addButtonSize,
                      decoration: BoxDecoration(
                        color: context.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FluentIcons.add_24_filled,
                        color: Colors.white,
                        size: sizer.w(28),
                      ),
                    ),
                  ),
                ),
              _tab(
                title: AppString.educationContent,
                icon: FluentIcons.video_recording_20_filled,
                iconSize: iconSize,
                screen: EducationContentScreen(),
                context: context,
              ),
              _tab(
                title: AppString.profile,
                icon: FluentIcons.person_16_regular,
                iconSize: iconSize,
                screen: MyProfileScreen(),
                context: context,
              ),
            ],
            navBarBuilder: (navBarConfig) => Style12BottomNavBar(
              navBarConfig: navBarConfig,
              height: navBarHeight,
              navBarDecoration: NavBarDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: context.grey900.withOpacity(0.08),
                    blurRadius: sizer.w(14),
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ===== Reusable Tab =====
  PersistentTabConfig _tab({
    required String title,
    required IconData icon,
    required double iconSize,
    required Widget screen,
    required BuildContext context,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        title: title,
        iconSize: iconSize,
        activeForegroundColor: context.primary,
        inactiveForegroundColor: context.grey750,
        icon: Icon(icon),
      ),
    );
  }
}
