import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/modules/my%20schedule/my_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/string_text.dart';

class DayDetailsHeader extends StatelessWidget {
  final String day;
  final bool isToday;
  final int count;
  final ScheduleController controller;

  const DayDetailsHeader({
    super.key,
    required this.day,
    required this.isToday,
    required this.count,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colors.primary, colors.Turquoise, colors.secondary],
        ),
        borderRadius: BorderRadius.circular(26.0),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.22),
            blurRadius: 18.0,
            offset: const Offset(0.0, 9.0),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => Get.back(),
            child: Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: colors.white,
                size: 24.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
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
                  isToday
                      ? '${AppString.scheduleDay.replaceFirst("{}", controller.translateDay(day))} - ${AppString.today}'
                      : AppString.scheduleDay.replaceFirst(
                          "{}",
                          controller.translateDay(day),
                        ),
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colors.white,
                  ),
                ),

                const SizedBox(height: 6.0),
                Text(
                  AppString.lessonsCount.replaceFirst("{}", count.toString()),
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
