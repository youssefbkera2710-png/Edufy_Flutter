import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/modules/my%20schedule/my_schedule_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/string_text.dart';

class ScheduleHeader extends StatelessWidget {
  final ScheduleController controller;

  const ScheduleHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 14.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colors.primary,
            colors.Turquoise,
            colors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.24),
            blurRadius: 22.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(
              Icons.calendar_view_week_rounded,
              color: colors.white,
              size: 28.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            AppString.myScheduleTitle,
                  style: context.bodyLarge?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                    AppString.scheduleSubtitle,
                  style: context.bodySmall?.copyWith(
                    color: colors.white.withOpacity(0.88),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100.0),
            ),
            // child: Obx(
            //       () => Text(
            //         AppString.daysCount.replaceFirst(
            //           '{}',
            //           controller.totalDays.toString(),
            //         ),
            //     style: context.bodySmall?.copyWith(
            //       color: colors.white,
            //       fontWeight: FontWeight.w800,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}