import 'package:edufy/models/homework_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/homework/homework_detail_screen.dart';

// الكارد تبع الوظيفة الظاهر بالهوم والصفحة تبع الوظايف لل guardian&student
class HomeworkCard extends StatelessWidget {
  const HomeworkCard({super.key, required this.homework});
  final HomeworkModel homework;

  int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    final diff = dueDate.difference(today);
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
        fg: const Color(0xFF2E7D32),
      );
    }
  }

  Color getStatusColor(int days) {
    if (days < 0) {
      return const Color(0xFFE53935);
    } else if (days == 0) {
      return const Color(0xFFE65100);
    } else {
      return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    final days = homework.dueDate != null ? daysUntil(homework.dueDate!) : 0;
    final badge = getStatusBadge(days);
    final statusColor = getStatusColor(days);

    return ResponsiveWidget(
      builder: (sizer) => GestureDetector(
        onTap: () {
          Get.to(
            () => HomeworkDetailScreen(),
            arguments: {'homework': homework},
          );
        },
        child: Container(
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
                      homework.title ?? 'بدون عنوان',
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
                      '📚 ${homework.subjectName ?? 'بدون مادة'}',
                      textDirection: TextDirection.rtl,
                      style: context.bodySmall!.copyWith(
                        color: context.grey625,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (homework.topic != null && homework.topic!.isNotEmpty)
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
                        homework.topic!,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: sizer.w(10),
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
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
                        homework.dueDate != null
                            ? formatDate(homework.dueDate!)
                            : "غير محدد",
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
                  if (homework.teacherName != null &&
                      homework.teacherName!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: sizer.w(12),
                          color: context.grey625,
                        ),
                        SizedBox(width: sizer.w(2)),
                        Text(
                          homework.teacherName!,
                          textDirection: TextDirection.rtl,
                          style: context.bodySmall!.copyWith(
                            color: context.grey625,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              if (homework.description != null &&
                  homework.description!.isNotEmpty) ...[
                SizedBox(height: sizer.h(8)),
                Text(
                  homework.description!,
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
