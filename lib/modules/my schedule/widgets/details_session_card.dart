import 'package:edufy/core/classes/subjects_helper.dart';
import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/models/schedule/schedule.dart';
import 'package:edufy/modules/my%20schedule/my_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/string_text.dart';
import '../../attendance/add_attendance_screen.dart';

class DetailsSessionCard extends StatelessWidget {
  final Schedule item;
  final int index;
  final ScheduleController controller;
  final int? divisionNumber;

  const DetailsSessionCard({
    super.key,
    required this.item,
    required this.index,
    required this.controller,
    this.divisionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;
    final accent = SubjectHelper.getSubjectColor(context, item.subject);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.background.withOpacity(0.15) : colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: accent.withOpacity(isDark ? 0.3 : 0.16),
          width: 1.0,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colors.black2.withOpacity(0.045),
              blurRadius: 18.0,
              offset: const Offset(0.0, 8.0),
            ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 78.0,
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.session,
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w800,
                      fontSize: 11.0,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    '${item.sessionNumber ?? ''}',
                    style: context.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: 36.0,
                    height: 1.0,
                    color: Colors.white.withOpacity(0.35),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    item.startTime ?? AppString.timePlaceholder,
                    textAlign: TextAlign.center,
                    style: context.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.0,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    item.endTime ?? AppString.timePlaceholder,
                    textAlign: TextAlign.center,
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w800,
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserInfo.role == 'teacher'
                          ? controller.subjectText(item) +
                                (divisionNumber ?? item.divisionNumber ?? "")
                                    .toString()
                          : controller.subjectText(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark ? colors.white : colors.grey900,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      controller.topicText(item),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodySmall?.copyWith(
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: isDark ? colors.grey150 : colors.grey625,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: _InfoChip(
                                  icon: Icons.location_on_outlined,
                                  text: controller.roomText(item),
                                  accent: accent,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Flexible(
                                child: _InfoChip(
                                  icon: Icons.person_outline_rounded,
                                  text: controller.teacherText(item),
                                  accent: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        (UserInfo.role != 'student' &&
                                UserInfo.role != 'parent' &&
                                UserInfo.role != 'guardian')
                            ? ElevatedButton(
                                onPressed: () {
                                  final int finalClassId = item.classId ?? 1;
                                  final int finalSubjectId =
                                      item.subjectId ?? 1;
                                  final String selectedDate =
                                      controller.getFormattedDateForSelectedDay;

                                  Get.to(
                                    () => AddAttendanceScreen(
                                      classId: finalClassId,
                                      subjectId: finalSubjectId,
                                      sessionNumber: item.sessionNumber ?? 1,
                                      subjectName:
                                          item.subject ?? 'مادة غير محددة',
                                      className:
                                          'الشعبة ${divisionNumber ?? item.divisionNumber ?? "1"}',
                                      date: selectedDate,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 6.0,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  'أخذ الحضور',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10.5,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accent;
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: accent.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: accent.withOpacity(isDark ? 0.25 : 0.16),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.0, color: accent),
          const SizedBox(width: 4.0),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 10.0,
                color: isDark ? colors.white : colors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
