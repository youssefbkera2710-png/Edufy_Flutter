import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/exams/exam_details_screen.dart';
import 'package:edufy/modules/homework/homework_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class TaskCardTeacher extends StatelessWidget {
  final dynamic item;
  final bool isExam;

  const TaskCardTeacher({super.key, required this.item, required this.isExam});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    final date = isExam ? item.examDate : item.dueDate;
    final days = date != null ? daysUntil(date) : 0;
    final badge = statusBadge(days);

    final isPast = date != null ? date.isBefore(DateTime.now()) : false;

    return ResponsiveWidget(
      builder: (sizer) => GestureDetector(
        onTap: () {
          if (isExam) {
            Get.to(() => const ExamDetailScreen(), arguments: {'exam': item});
          } else {
            Get.to(() => HomeworkDetailScreen(), arguments: {'homework': item});
          }
        },
        child: Container(
          width: sizer.w(260),
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(16),
          ),
          decoration: BoxDecoration(
            color: theme.isDarkMode.value == true
                ? context.backgroundColortheme
                : context.white,
            border: Border.all(
              color: isPast
                  ? Colors.red.withOpacity(0.5)
                  : context.primary.withOpacity(0.3),
              width: sizer.w(1.5),
            ),
            borderRadius: BorderRadius.circular(sizer.radius(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      isExam
                          ? (item.title ?? 'اختبار')
                          : (item.title ?? 'واجب'),
                      style: context.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizer.h(12),
                      vertical: sizer.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: badge.bg,
                      borderRadius: BorderRadius.circular(sizer.radius(20)),
                    ),
                    child: Text(
                      badge.label,
                      style: context.bodyMedium!.copyWith(
                        color: badge.fg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizer.h(8)),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: sizer.w(14),
                    color: Colors.grey,
                  ),
                  SizedBox(width: sizer.w(6)),
                  Text(
                    isExam
                        ? formatDate(item.examDate)
                        : formatDate(item.dueDate),
                    style: context.bodySmall!.copyWith(
                      color: days < 0
                          ? const Color(0xFFE53935)
                          : days == 0
                          ? const Color(0xFFE65100)
                          : context.primary,
                      fontWeight: days < 0 || days == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  if (!isExam && item.subjectName != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizer.w(8),
                        vertical: sizer.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(sizer.radius(8)),
                      ),
                      child: Text(
                        item.subjectName,
                        style: TextStyle(
                          fontSize: sizer.w(10),
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (isExam &&
                      item.assignments != null &&
                      item.assignments!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizer.w(8),
                        vertical: sizer.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(sizer.radius(8)),
                      ),
                      child: Text(
                        item.assignments!.first.subjectName ?? 'بدون مادة',
                        style: TextStyle(
                          fontSize: sizer.w(10),
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: sizer.h(8)),
              if (isExam && item.assignmentsCount != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizer.w(8),
                    vertical: sizer.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(sizer.radius(8)),
                  ),
                  child: Text(
                    '${item.assignmentsCount} صفوف',
                    style: TextStyle(
                      fontSize: sizer.w(10),
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (!isExam && item.topic != null)
                Text(
                  item.topic!,
                  style: TextStyle(
                    fontSize: sizer.w(12),
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (!isExam && item.teacherName != null)
                Padding(
                  padding: EdgeInsets.only(top: sizer.h(4)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: sizer.w(12),
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(width: sizer.w(4)),
                      Text(
                        item.teacherName!,
                        style: TextStyle(
                          fontSize: sizer.w(11),
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  ({String label, Color bg, Color fg}) statusBadge(int days) {
    if (days < 0) {
      return (
        label: 'منتهي',
        bg: const Color(0xFFFFECEC),
        fg: const Color(0xFFE53935),
      );
    } else if (days == 0) {
      return (
        label: 'اليوم',
        bg: const Color(0xFFFFF3E0),
        fg: const Color(0xFFE65100),
      );
    } else {
      return (
        label: 'متبقي $days أيام',
        bg: const Color(0xFFE8F5E9),
        fg: const Color.fromARGB(255, 62, 174, 156),
      );
    }
  }

  int daysUntil(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(DateTime(now.year, now.month, now.day));
    return diff.inDays;
  }

  String formatDate(DateTime date) {
    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
