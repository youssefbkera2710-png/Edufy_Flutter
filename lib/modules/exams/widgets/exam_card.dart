import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/exam.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  const ExamCard({super.key, required this.exam});

  int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final examDate = DateTime(date.year, date.month, date.day);
    final diff = examDate.difference(today);
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

  ({String label, Color bg, Color fg}) getStatusBadge(int days) {
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

  Color getStatusColor(int days) {
    if (days < 0) {
      return const Color(0xFFE53935);
    } else if (days == 0) {
      return const Color(0xFFE65100);
    } else {
      return const Color.fromARGB(255, 62, 174, 156);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    final days = exam.examDate != null ? daysUntil(exam.examDate!) : 0;
    final badge = getStatusBadge(days);
    final statusColor = getStatusColor(days);

    return ResponsiveWidget(
      builder: (sizer) => Obx(
        () => Container(
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(16),
          ),
          decoration: BoxDecoration(
            color: theme.isDarkMode.value == true
                ? context.primaryColorMode
                : context.white,
            border: Border.all(
              color: statusColor.withOpacity(0.5),
              width: sizer.w(1.5),
            ),
            borderRadius: BorderRadius.circular(sizer.radius(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      exam.title ?? 'بدون عنوان',
                      textDirection: TextDirection.rtl,
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
                      textDirection: TextDirection.rtl,
                      style: context.bodyMedium!.copyWith(
                        color: badge.fg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizer.h(12)),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '📚 ${exam.subjectName ?? 'بدون مادة'}',
                      textDirection: TextDirection.rtl,
                      style: context.bodySmall!.copyWith(
                        color: context.grey625,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (exam.maxScore != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizer.w(10),
                        vertical: sizer.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: context.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(sizer.radius(8)),
                      ),
                      child: Text(
                        '⭐ ${exam.maxScore}',
                        textDirection: TextDirection.rtl,
                        style: context.bodySmall!.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: sizer.h(8)),

              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: sizer.w(14),
                        color: statusColor,
                      ),
                      SizedBox(width: sizer.w(2)),
                      Text(
                        '${exam.examDate != null ? formatDate(exam.examDate!) : "غير محدد"}',
                        textDirection: TextDirection.rtl,
                        style: context.bodySmall!.copyWith(
                          color: statusColor,
                          fontWeight: days <= 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  if (exam.source != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizer.w(8),
                        vertical: sizer.h(2),
                      ),
                      decoration: BoxDecoration(
                        color: exam.source == 'admin'
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(sizer.radius(6)),
                      ),
                      child: Text(
                        exam.source == 'admin'
                            ? 'الإدارة'
                            : exam.source == 'teacher'
                            ? 'المعلم'
                            : exam.source ?? 'المدرسة',
                        textDirection: TextDirection.rtl,
                        style: context.bodySmall!.copyWith(
                          color: exam.source == 'admin'
                              ? Colors.blue
                              : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              if (exam.description != null && exam.description!.isNotEmpty) ...[
                SizedBox(height: sizer.h(8)),
                Text(
                  exam.description!,
                  textDirection: TextDirection.rtl,
                  style: context.bodySmall!.copyWith(
                    color: context.grey625,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
