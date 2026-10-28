import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/exam.dart';
import 'package:edufy/modules/exams/widgets/exam_card.dart';
 
 // RecentExamsSection لجزء الاختبارات الظاهر بالهوم لل gurdian & student 
class RecentExamsSection extends StatelessWidget {
  const RecentExamsSection({super.key, required this.exams});
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final recentExams =
        exams.where((exam) {
          if (exam.examDate == null) return false;
          final examDate = DateTime(
            exam.examDate!.year,
            exam.examDate!.month,
            exam.examDate!.day,
          );
          return examDate.isAfter(today) || examDate.isAtSameMomentAs(today);
        }).toList()..sort((a, b) {
          return a.examDate!.compareTo(b.examDate!);
        });

    final displayExams = recentExams.take(3).toList();

    return ResponsiveWidget(
      builder: (sizer) => displayExams.isEmpty
          ? Container(
              height: sizer.h(100),
              decoration: BoxDecoration(
                color: theme.isDarkMode.value == true
                    ? context.primaryColorMode
                    : context.white,
                borderRadius: BorderRadius.circular(sizer.radius(24)),
              ),
              child: Center(
                child: Text(
                  'لا يوجد لديك اختبارات حديثة ',
                  style: context.bodyMedium?.copyWith(color: context.grey625),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(10),
                vertical: sizer.h(10),
              ),
              decoration: BoxDecoration(
                color: theme.isDarkMode.value == true
                    ? context.primaryColorMode
                    : context.white,
                borderRadius: BorderRadius.circular(sizer.radius(24)),
              ),
              child: Column(
                children: displayExams
                    .map(
                      (exam) => Padding(
                        padding: EdgeInsets.only(bottom: sizer.h(12)),
                        child: ExamCard(exam: exam),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
