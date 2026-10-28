import 'package:edufy/models/teacher_exam.dart';
import 'package:edufy/modules/exams/management%20grade/exam_grades_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class ClassesSummaryCard extends StatelessWidget {
  final List<ClassesSummary> classesSummary;
  final int? examId;
  final String? examTitle;
  final String? maxScore;

  const ClassesSummaryCard({
    super.key,
    required this.classesSummary,
    this.examId,
    this.examTitle,
    this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizer.radius(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(sizer.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.school, size: sizer.w(24), color: Colors.blue),
                  SizedBox(width: sizer.w(8)),
                  Text(
                    'ملخص الصفوف',
                    style: TextStyle(
                      fontSize: sizer.w(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizer.h(12)),
              ...classesSummary
                  .map(
                    (summary) => Padding(
                      padding: EdgeInsets.only(bottom: sizer.h(8)),
                      child: Container(
                        padding: EdgeInsets.all(sizer.w(12)),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(sizer.radius(12)),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${summary.gradeLevel ?? ''} - ${summary.stage ?? ''}',
                                    style: TextStyle(
                                      fontSize: sizer.w(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: sizer.h(4)),
                                  if (summary.specializations != null &&
                                      summary.specializations!.isNotEmpty)
                                    Wrap(
                                      spacing: sizer.w(4),
                                      children: summary.specializations!
                                          .map(
                                            (spec) => Chip(
                                              label: Text(
                                                spec,
                                                style: TextStyle(
                                                  fontSize: sizer.w(12),
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.blue.shade100,
                                              padding: EdgeInsets.zero,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                ],
                              ),
                            ),
                            // ✅ زر "إدخال الدرجات" - يظهر فقط إذا كان الاختبار منتهي
                            if (summary.classesCount != null &&
                                summary.classesCount! > 0)
                              ElevatedButton.icon(
                                onPressed: () {
                                  // ✅ الانتقال إلى صفحة إدخال الدرجات
                                  Get.to(
                                    () => const ExamGradesScreen(),
                                    arguments: {
                                      'examId': examId ?? 0,
                                      'classId':
                                          summary.classId ??
                                          0, // يجب إضافة classId في الـ summary
                                      'examTitle': examTitle ?? 'الاختبار',
                                      'className':
                                          '${summary.gradeLevel ?? ''} - ${summary.stage ?? ''}',
                                      'maxScore':
                                          double.tryParse(maxScore ?? '100') ??
                                          100,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: sizer.w(12),
                                    vertical: sizer.h(6),
                                  ),
                                  textStyle: TextStyle(fontSize: sizer.w(12)),
                                ),
                                icon: Icon(
                                  Icons.edit_note_rounded,
                                  size: sizer.w(16),
                                ),
                                label: Text(
                                  'إدخال الدرجات',
                                  style: TextStyle(fontSize: sizer.w(12)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
