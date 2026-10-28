// guardian_subject_grades_screen.dart
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/models/grade_guardian.dart';
import 'package:edufy/modules/grade/grade_guardian/guardian_grades_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../../../core/shared/extensions/context_extension.dart';

class GuardianSubjectGradesScreen extends StatelessWidget {
  final int childId;
  final String childName;
  final String subjectName;
  final int subjectId;
  final List<SubjectExam> exams;

  const GuardianSubjectGradesScreen({
    super.key,
    required this.childId,
    required this.childName,
    required this.subjectName,
    required this.subjectId,
    required this.exams,
  });

  @override
  Widget build(BuildContext context) {
    final GuardianGradesController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
        backgroundColor: context.primary,
      ),
      body: ResponsiveWidget(
        builder: (sizer) {
          // ===== عرض شاشة التحميل =====
          if (controller.isSubjectLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("جاري تحميل الدرجات..."),
                ],
              ),
            );
          }

          // ===== لا توجد امتحانات =====
          if (exams.isEmpty) {
            return NoDataWidget(
              message: 'لا توجد امتحانات لهذه المادة',
              icon: Icons.assignment_outlined,
              onRetry: () => controller.getSubjectGrades(subjectId),
              buttonText: 'إعادة المحاولة',
            );
          }

          // ===== عرض الامتحانات =====
          return ListView.builder(
            padding: EdgeInsets.all(sizer.w(20)),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return _buildExamCard(context, exam, controller);
            },
          );
        },
      ),
    );
  }

  Widget _buildExamCard(
    BuildContext context,
    SubjectExam exam,
    GuardianGradesController controller,
  ) {
    // حساب الأداء
    final percentage = exam.percentage ?? 0;
    final color = controller.gradeColor(percentage);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.primaryColorMode,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الامتحان
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.assignment, color: color, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  exam.examTitle ?? "امتحان غير معروف",
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // النسبة
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$percentage%",
                  style: context.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14),

          // التاريخ
          if (exam.examDate != null && exam.examDate!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.calendar_month, size: 16),
                SizedBox(width: 8),
                Text(_formatDate(exam.examDate!), style: context.bodySmall),
              ],
            ),

          SizedBox(height: 14),

          // العلامة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "العلامة",
                style: context.bodyMedium?.copyWith(color: context.black2),
              ),
              Text(
                "${exam.score ?? 0}/${exam.maxScore ?? 0}",
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),

          SizedBox(height: 14),

          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ===== دالة مساعدة لتنسيق التاريخ =====
  String _formatDate(String dateTimeString) {
    try {
      final date = DateTime.parse(dateTimeString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateTimeString;
    }
  }
}
