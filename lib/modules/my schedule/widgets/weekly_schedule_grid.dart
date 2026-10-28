import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/modules/my%20schedule/my_schedule_controller.dart';
import 'package:edufy/modules/my%20schedule/schedule_day_details_screen.dart';
import 'package:edufy/modules/my%20schedule/widgets/schedule_grid_cells.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyScheduleGrid extends StatelessWidget {
  final ScheduleController controller;
  static const double cellHeight = 75.0;

  const WeeklyScheduleGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final days = controller.availableDays;
    final sessions = controller.availableSessions;
    final todayName = controller.getTodayEnglishName();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 24.0),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(color: context.primary, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: colors.black2.withOpacity(0.04),
                  blurRadius: 18.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const GridHeaderCell(
                      title: 'اليوم',
                      width: 95.0,
                      height: cellHeight,
                      isMain: true,
                    ),
                    ...sessions.map(
                      (session) => GridHeaderCell(
                        title: 'الحصة $session',
                        width: 135.0,
                        height: cellHeight,
                      ),
                    ),
                  ],
                ),

                ...days.map((day) {
                  final isToday =
                      day.toLowerCase().trim() ==
                      todayName.toLowerCase().trim();
                  final daySessions = controller.sessionsByDay(day);

                  final int? currentDayDivision = daySessions.isNotEmpty
                      ? daySessions.first.divisionNumber
                      : null;

                  return InkWell(
                    onTap: () {
                      controller.selectDay(day);
                      if (UserInfo.role == 'teacher') {
                        Get.to(
                          () => ScheduleDayDetailsScreen(
                            day: day,
                            isToday: isToday,
                            items: daySessions,
                            controller: controller,
                            divisionNumber: currentDayDivision ?? 1,
                          ),
                        );
                      } else {
                        Get.to(
                          () => ScheduleDayDetailsScreen(
                            day: day,
                            isToday: isToday,
                            items: daySessions,
                            controller: controller,
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        GridDayCell(
                          title: controller.translateDay(day),
                          isToday: isToday,
                          isSelected: false,
                          width: 95.0,
                          height: cellHeight,
                        ),
                        ...sessions.map((sessionNumber) {
                          final item = controller.getSessionByDayAndNumber(
                            day,
                            sessionNumber,
                          );
                          final index = daySessions.indexWhere(
                            (e) => e.sessionNumber == sessionNumber,
                          );
                          final accent = item == null
                              ? colors.primary
                              : controller.subjectColor(
                                  context,
                                  item,
                                  index < 0 ? 0 : index,
                                );

                          return UserInfo.role == 'teacher'
                              ? GridSubjectCell(
                                  divisionNumber: item?.divisionNumber,
                                  subject: item == null
                                      ? ''
                                      : controller.subjectText(item),
                                  isToday: isToday,
                                  isSelected: false,
                                  accent: accent,
                                  width: 135.0,
                                  height: cellHeight,
                                )
                              : GridSubjectCell(
                                  subject: item == null
                                      ? ''
                                      : controller.subjectText(item),
                                  isToday: isToday,
                                  isSelected: false,
                                  accent: accent,
                                  width: 135.0,
                                  height: cellHeight,
                                );
                        }),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
