// guardian_grades_controller.dart
import 'package:edufy/models/grade_guardian.dart';
import 'package:edufy/modules/grade/grade_guardian/guardian_grades_service.dart';
import 'package:edufy/modules/grade/grade_guardian/guardian_subject_grades_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuardianGradesController extends GetxController {
  final GuardianGradesService service = GuardianGradesService();

  // ========== حالات التحميل ==========
  RxBool isLoading = false.obs;
  RxBool isSubjectLoading = false.obs;

  // ========== بيانات الطالب ==========
  RxInt childId = 0.obs;
  RxString childName = "".obs;

  // ========== البيانات الرئيسية ==========
  RxList<SubjectExam> allExams = <SubjectExam>[].obs;
  RxList<Subject> subjects = <Subject>[].obs;
  RxDouble overallAverage = 0.0.obs;
  RxString performanceMessage = "".obs;
  RxInt totalExams = 0.obs;

  // ========== بيانات المادة المحددة ==========
  RxList<SubjectExam> subjectExams = <SubjectExam>[].obs;
  RxString selectedSubjectName = "".obs;
  RxInt selectedSubjectId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
  }

  void _handleArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('childId')) {
      childId.value = args['childId'] as int;
      childName.value = args['childName'] ?? "الطالب";
      getData();
    } else {
      // إذا لم يتم تمرير childId
      Get.snackbar(
        "خطأ",
        "لم يتم تحديد الطالب",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// جلب جميع البيانات
  Future<void> getData() async {
    if (childId.value == 0) return;

    isLoading.value = true;

    try {
      final response = await service.getChildGrades(childId.value);

      if (response.status == 200) {
        _processGradesResponse(response);
      } else {
        Get.snackbar(
          "خطأ",
          response.message ?? "حدث خطأ أثناء جلب الدرجات",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('getData error: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// معالجة الـ Response
  void _processGradesResponse(GuardianGradesResponse response) {
    allExams.value = response.grades;
    overallAverage.value =
        response.average ?? _calculateAverage(response.grades);
    performanceMessage.value = _getPerformanceMessage(overallAverage.value);
    totalExams.value = response.grades.length;

    // تحويل الامتحانات إلى مواد
    subjects.value = _groupExamsBySubject(response.grades);
  }

  /// تجميع الامتحانات حسب المادة
  // guardian_grades_controller.dart

  /// تجميع الامتحانات حسب المادة
  List<Subject> _groupExamsBySubject(List<SubjectExam> exams) {
    final Map<int, Subject> subjectMap = {};

    for (var exam in exams) {
      final subjectId = exam.subjectId ?? 0;

      if (!subjectMap.containsKey(subjectId)) {
        subjectMap[subjectId] = Subject(
          id: subjectId,
          subjectName: exam.subjectName ?? "غير معروف",
          examsCount: 0,
          averageScore: 0.0,
          averageMax: 0.0,
          percentage: 0,
        );
      }

      // ✅ استخدم copyWith
      final oldSubject = subjectMap[subjectId]!;
      subjectMap[subjectId] = oldSubject.copyWith(
        examsCount: (oldSubject.examsCount ?? 0) + 1,
        averageScore: (oldSubject.averageScore ?? 0) + (exam.score ?? 0),
        averageMax: (oldSubject.averageMax ?? 0) + (exam.maxScore ?? 0),
      );
    }

    // حساب النسبة المئوية لكل مادة
    for (var subject in subjectMap.values) {
      if ((subject.averageMax ?? 0) > 0) {
        subjectMap[subject.id!] = subject.copyWith(
          percentage:
              ((subject.averageScore ?? 0) / (subject.averageMax ?? 0) * 100)
                  .round(),
        );
      } else {
        subjectMap[subject.id!] = subject.copyWith(percentage: 0);
      }
    }

    return subjectMap.values.toList();
  }

  /// حساب المتوسط
  double _calculateAverage(List<SubjectExam> exams) {
    if (exams.isEmpty) return 0;
    double total = 0;
    for (var exam in exams) {
      total += (exam.percentage ?? 0);
    }
    return total / exams.length;
  }

  /// رسالة الأداء
  String _getPerformanceMessage(double average) {
    if (average >= 85) return "ممتاز";
    if (average >= 70) return "جيد جداً";
    if (average >= 60) return "جيد";
    if (average >= 50) return "مقبول";
    return "ضعيف";
  }

  /// جلب درجات مادة محددة
  Future<void> getSubjectGrades(int subjectId) async {
    if (childId.value == 0) return;

    isSubjectLoading.value = true;

    try {
      final response = await service.getChildSubjectGrades(
        childId.value,
        subjectId,
      );

      if (response.status == 200) {
        subjectExams.value = response.grades;
        selectedSubjectId.value = subjectId;

        // تحديث اسم المادة من القائمة
        final subject = subjects.firstWhere(
          (s) => s.id == subjectId,
          orElse: () => Subject(
            id: subjectId,
            subjectName: "المادة",
            examsCount: 0,
            averageScore: 0,
            averageMax: 0,
            percentage: 0,
          ),
        );
        selectedSubjectName.value = subject.subjectName ?? "المادة";
      } else {
        Get.snackbar(
          "خطأ",
          response.message ?? "حدث خطأ أثناء جلب درجات المادة",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('getSubjectGrades error: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubjectLoading.value = false;
    }
  }

  /// فتح صفحة تفاصيل المادة
  void openSubjectDetails(Subject subject) {
    // جلب الامتحانات الخاصة بهذه المادة من allExams أولاً
    final filteredExams = allExams
        .where((exam) => exam.subjectId == subject.id)
        .toList();

    Get.to(
      () => GuardianSubjectGradesScreen(
        childId: childId.value,
        childName: childName.value,
        subjectName: subject.subjectName ?? "غير معروف",
        subjectId: subject.id ?? 0,
        exams: filteredExams,
      ),
    )?.then((_) {
      // عند العودة، تحديث البيانات إذا تغيرت
      getData();
    });
  }

  // ========== دوال الألوان ==========

  Color gradeColor(int percentage) {
    if (percentage >= 85) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Color performanceColor(String performance) {
    switch (performance) {
      case "ممتاز":
        return Colors.green;
      case "جيد جداً":
        return Colors.orange;
      case "ضعيف":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // ========== دوال مساعدة ==========

  String getChildInfo() {
    return "$childName (ID: $childId)";
  }

  bool hasData() {
    return allExams.isNotEmpty;
  }

  /// ✅ دالة التحديث (الموجودة)
  Future<void> refreshData() async {
    await getData();
  }

  /// ✅ دالة إعادة المحاولة (لـ NoDataWidget)
  void retry() {
    getData();
  }

  /// ✅ دالة تنظيف البيانات (عند الخروج)
  void clearData() {
    allExams.clear();
    subjects.clear();
    overallAverage.value = 0.0;
    performanceMessage.value = "";
    totalExams.value = 0;
    subjectExams.clear();
    selectedSubjectName.value = "";
    selectedSubjectId.value = 0;
  }

  /// ✅ دالة التحقق من وجود بيانات
  bool get hasGrades => allExams.isNotEmpty;

  /// ✅ دالة الحصول على عدد المواد
  int get subjectsCount => subjects.length;

  /// ✅ دالة الحصول على أفضل مادة (أعلى نسبة)
  Subject? get bestSubject {
    if (subjects.isEmpty) return null;
    return subjects.reduce(
      (a, b) => (a.percentage ?? 0) > (b.percentage ?? 0) ? a : b,
    );
  }

  /// ✅ دالة الحصول على أسوأ مادة (أقل نسبة)
  Subject? get worstSubject {
    if (subjects.isEmpty) return null;
    return subjects.reduce(
      (a, b) => (a.percentage ?? 0) < (b.percentage ?? 0) ? a : b,
    );
  }
}
