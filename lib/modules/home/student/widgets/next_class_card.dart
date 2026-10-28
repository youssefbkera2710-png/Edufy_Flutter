import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class NextClassCard extends StatelessWidget {
  final String subject;
  final String room;
  final String time;
  final String teacher;
  final String timeRemaining;

  const NextClassCard({super.key, 
    required this.subject,
    required this.room,
    required this.time,
    required this.teacher,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {  
    final theme = Get.find<ThemeController>();

    return ResponsiveWidget(
      builder: (sizer) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(14),
          vertical: sizer.h(10),
        ),
        decoration: BoxDecoration(
          color: context.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(sizer.radius(18)),
          border: Border.all(
        color: theme.isDarkMode.value == true ? context.black2 : context.white,
            width: sizer.w(1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  width: sizer.w(38),
                  height: sizer.h(34),
                  decoration: BoxDecoration(
                    color: context.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(sizer.radius(10)),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: context.white,
                    size: sizer.w(20),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الحصة القادمة',
                      style: context.bodySmall!.copyWith(
                        color: context.white.withOpacity(0.75),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      subject,
                      style: context.bodyLarge!.copyWith(
                        color: context.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$room - $time',
                      style: context.bodySmall!.copyWith(
                        color: context.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: sizer.h(5)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: sizer.w(12),
                    vertical: sizer.h(6),
                  ),
                  decoration: BoxDecoration(
                    color: context.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(sizer.radius(20)),
                  ),
                  child: Text(
                    timeRemaining,
                    style: context.bodySmall!.copyWith(
                        color: context.white,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),

                
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الأستاذ',
                          style:  context.bodySmall!.copyWith(
                        color: context.white.withOpacity(0.75),
                      ),
                        ),
                        Text(
                          teacher,
                          style:  context.bodyMedium!.copyWith(
                        color: context.white,
                        fontWeight: FontWeight.bold,
                      )
                        ),
                      ],
                    ),
                     SizedBox(width: sizer.w(8)),
                    Container(
                      width: sizer.w(32),
                      height: sizer.h(34),
                      decoration: BoxDecoration(
                        color: context.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(sizer.radius(9)),
                      ),
                      child:  Icon(
                        Icons.menu_book_rounded,
                        color: context.white,
                        size: sizer.w(18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
