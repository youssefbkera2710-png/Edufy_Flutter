import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/teacher/widgets/task_card_teacher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

enum TaskType { exam, homework }

class HometaskSection extends StatelessWidget {
  const HometaskSection({
    super.key,
    required this.items,
    required this.taskType,
    required this.sizer,
  });

  final List<dynamic> items;
  final TaskType taskType;
  final Sizer sizer;

  bool get isExam => taskType == TaskType.exam;

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    if (items.isEmpty) {
      return Container(
        height: sizer.h(100),
        decoration: BoxDecoration(
          color: theme.isDarkMode.value == true
              ? context.backgroundColortheme
              : context.white,
          borderRadius: BorderRadius.circular(sizer.radius(24)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isExam ? 'لا توجد اختبارات قادمة' : 'لا توجد وظائف قادمة',
            style: context.bodyMedium?.copyWith(color: context.grey625),
          ),
        ),
      );
    }
    return SizedBox(
      height: sizer.h(180),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: sizer.w(12)),
        itemBuilder: (_, index) {
          final item = items[index];
          return TaskCardTeacher(item: item, isExam: isExam);
        },
      ),
    );
  }
}
