import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/models/exam.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/exams/widgets/exam_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamGuardianStudent extends StatelessWidget {
  ExamGuardianStudent({super.key});
  final int? studentId = Get.arguments?['studentId'];

  bool get isGuardian => UserInfo.role == "guardian";
  bool get isStudent => UserInfo.role == "student";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<HomeController>();
      if (isGuardian) {
        controller.getAllExamForChildren(studentId: studentId!);
      } else {
        controller.getAllExamForStudent();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("الاختبارات"),
        backgroundColor: context.primary,
      ),
      body: GetBuilder<HomeController>(
        builder: (ctrl) {
          final isLoading = isGuardian
              ? ctrl.isLoadingGuardianExams
              : ctrl.isLoadingStudentExams;

          final exams = isGuardian ? ctrl.guardianExams : ctrl.studentExams;

          if (isLoading && exams.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (exams.isEmpty) {
            return NoDataWidget(
              message: isGuardian
                  ? 'لا توجد اختبارات لهذا الابن'
                  : 'لا توجد اختبارات',
              icon: Icons.assignment_outlined,
              onRetry: () => isGuardian
                  ? ctrl.getAllExamForChildren(studentId: studentId!)
                  : ctrl.getAllExamForStudent(),
            );
          }
          final sortedExams = List<Exam>.from(exams)
            ..sort((a, b) {
              if (a.examDate == null) return 1;
              if (b.examDate == null) return -1;
              return a.examDate!.compareTo(b.examDate!);
            });
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: sortedExams.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ExamCard(exam: sortedExams[index]),
              );
            },
          );
        },
      ),
    );
  }
}
