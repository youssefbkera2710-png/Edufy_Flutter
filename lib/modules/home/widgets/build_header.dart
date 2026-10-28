import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/user.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/notification/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class BuildHeader extends StatefulWidget {
  final User user;

  const BuildHeader({super.key, required this.user});

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = Get.find<HomeController>();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.only(
          top: sizer.h(45),
          bottom: sizer.h(25),
          left: sizer.w(20),
          right: sizer.w(20),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primary, context.secondry],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(sizer.radius(30)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: sizer.h(16)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Get.to(() => const NotificationsScreen());
                      },
                      child: Container(
                        width: sizer.w(50),
                        height: sizer.w(50),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]!.withOpacity(0.5)
                              : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          size: sizer.w(25),
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    Obx(() {
                      if (_homeController.notificationCount.value > 0) {
                        return Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: sizer.w(18),
                              minHeight: sizer.w(18),
                            ),
                            child: Text(
                              _homeController.notificationCount.value > 9
                                  ? '9+'
                                  : _homeController.notificationCount.value
                                        .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: sizer.fontSize(12),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ],
                ),

                const Spacer(),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.user.role == 'student')
                      Text(
                        'الطالب',
                        style: context.bodySmall?.copyWith(
                          color: context.white.withOpacity(0.8),
                          fontSize: sizer.fontSize(16),
                        ),
                      ),
                    if (widget.user.role == 'guardian')
                      Text(
                        'ولي الأمر',
                        style: context.bodySmall?.copyWith(
                          color: context.white.withOpacity(0.8),
                          fontSize: sizer.fontSize(16),
                        ),
                      ),
                    if (widget.user.role == 'teacher')
                      Text(
                        'المعلم',
                        style: context.bodySmall?.copyWith(
                          color: context.white.withOpacity(0.8),
                          fontSize: sizer.fontSize(16),
                        ),
                      ),
                    SizedBox(height: sizer.h(5)),
                    Text(
                      widget.user.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyLarge?.copyWith(
                        color: context.white,
                        fontWeight: FontWeight.w600,
                        fontSize: sizer.fontSize(20),
                      ),
                    ),
                    // if (UserInfo.role == "student")
                    //   Text(
                    //     'الصف العاشر - أ',
                    //     style: context.bodySmall?.copyWith(
                    //       color: context.white.withOpacity(0.7),
                    //       fontSize: sizer.fontSize(14),
                    //     ),
                    //   ),
                    // SizedBox(height: sizer.h(5)),
                  ],
                ),
              ],
            ),

            // SizedBox(height: sizer.h(10)),
            // if (UserInfo.role == "student")
            //   Padding(
            //     padding: EdgeInsets.only(top: sizer.h(1.2)),
            //     child: const NextClassCard(
            //       subject: 'الرياضيات',
            //       room: 'ق3',
            //       time: '1:30 ص',
            //       teacher: 'د. محمد',
            //       timeRemaining: '45 د',
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
