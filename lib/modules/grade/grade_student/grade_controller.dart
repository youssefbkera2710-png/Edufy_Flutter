import 'package:edufy/models/grade.dart';
import 'package:edufy/modules/grade/grade_student/grade_services.dart';
import 'package:edufy/modules/grade/grade_student/subject_grades_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradesController extends GetxController {
  final   service = GradesService();

  RxBool isLoading = false.obs;

  Rx<Grade?> gradeData = Rx<Grade?>(null);

  RxList<Subject> subjects = <Subject>[].obs;

  RxList<SubjectExam> allExams = <SubjectExam>[].obs;

  @override
  void onInit() {
    getData();

    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;

    try {
      final summary = await service.getGradesSummary();

      final exams = await service.getAllExams();

      if (summary != null && summary.status == 200 && summary.grade != null) {
        gradeData.value = summary.grade;

        subjects.value = summary.grade?.subjects ?? [];

        allExams.value = exams;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void openSubjectDetails(Subject subject) {
    final exams = allExams.where((exam) {
      return exam.subjectName == subject.subjectName;
    }).toList();

    Get.to(
      () => SubjectGradesScreen(
        subjectName: subject.subjectName ?? "",

        exams: exams,
      ),
    );
  }

  Color gradeColor(int percentage) {
    if (percentage >= 85) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color performanceColor(String performance) {
    if (performance == "ممتاز") {
      return Colors.green;
    } else if (performance == "جيد جداً") {
      return Colors.orange;
    } else if (performance == "ضعيف") {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
