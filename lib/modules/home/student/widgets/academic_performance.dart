import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class AcademicPerformance extends StatelessWidget {
  const AcademicPerformance({
    required this.subject,
    required this.subjectColor,
  });
  final Subject subject;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Column(
        children: [
          Row(
            children: [
              Container(
                width: sizer.w(42),
                height: sizer.h(30),
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(sizer.radius(6)),
                ),
                child: Center(
                  child: Text(
                    '${subject.percentage} %',
                    style: context.bodySmall?.copyWith(color: subjectColor),
                  ),
                ),
              ),
              const Spacer(),
              Text(subject.subjectName ?? '-', style: context.bodyMedium),
            ],
          ),
          SizedBox(height: sizer.h(6)),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: (subject.percentage ?? 0.0).toDouble() / 100,
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(sizer.radius(6)),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFEEEEEE),
                  valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
                ),
              );
            },
          ),
          SizedBox(height: sizer.h(6)),
        ],
      ),
    );
  }
}

Widget buildAcademicPerformance(BuildContext context, {required Grade grade}) {
  final theme = Get.find<ThemeController>();

  const kPrimary = Color(0xFF3EC6C6);
  const kPrimaryDark = Color(0xFF2AA8A8);
  const kPrimaryLight = Color(0xFFE8F8F8);
  const kBg = Color(0xFFEFF8F8);
  const kText = Color(0xFF1A2E35);
  const kTextLight = Color(0xFF7A9BA5);
  const kGreen = Color(0xFF4CAF50);
  const kOrange = Color(0xFFFF9800);
  const kRed = Color(0xFFF44336);

  List<Color> color = [
    kGreen,
    kPrimary,
    kOrange,
    kRed,
    kPrimaryDark,
    kPrimaryLight,
    kBg,
    kText,
    kTextLight,
  ];

  return ResponsiveWidget(
    builder: (sizer) {
      final hasSubjects = grade.subjects != null && grade.subjects!.isNotEmpty;

      if (!hasSubjects) {
        return Container(
          height: sizer.h(100),
          decoration: BoxDecoration(
            color: theme.isDarkMode.value == true
                ? context.primaryColorMode
                : context.white,
            borderRadius: BorderRadius.circular(sizer.radius(24)),
          ),
          child: Center(
            child: Text(
              'لا يوجد لديك بيانات للدرجات',
              style: context.bodyMedium?.copyWith(color: context.grey625),
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(16),
          vertical: sizer.h(16),
        ),
        decoration: BoxDecoration(
          color: theme.isDarkMode.value == true
              ? context.primaryColorMode
              : context.white,
          borderRadius: BorderRadius.circular(sizer.radius(18)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: List.generate(grade.subjects!.length, (index) {
            return AcademicPerformance(
              subject: grade.subjects![index],
              subjectColor: color[index % color.length],
            );
          }),
        ),
      );
    },
  );
}
