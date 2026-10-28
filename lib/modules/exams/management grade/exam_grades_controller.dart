// lib/modules/teacher/grades/controllers/exam_grades_controller.dart

import 'package:edufy/models/student_grade_model.dart';
import 'package:edufy/modules/exams/management%20grade/exam_grades_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamGradesController extends GetxController {
  final ExamGradesService _service = ExamGradesService();

  // البيانات
  final RxList<StudentGrade> students = <StudentGrade>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble maxScore = 100.0.obs;

  // معاملات الصفحة
  late int examId;
  late int classId;
  late String examTitle;
  late String className;

  // خريطة لتخزين القيم المؤقتة لكل طالب
  final Map<int, TextEditingController> scoreControllers = {};
  final Map<int, double> tempScores = {};
  final RxSet<int> modifiedStudentIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // استقبال المعاملات
    examId = Get.arguments['examId'] ?? 0;
    classId = Get.arguments['classId'] ?? 0;
    examTitle = Get.arguments['examTitle'] ?? 'الاختبار';
    className = Get.arguments['className'] ?? 'الصف';
    maxScore.value = (Get.arguments['maxScore'] ?? 100).toDouble();

    print('📌 ExamGradesController initialized:');
    print('   examId: $examId');
    print('   classId: $classId');
    print('   examTitle: $examTitle');
    print('   className: $className');
    print('   maxScore: ${maxScore.value}');

    fetchStudentsGrades();
  }

  @override
  void onClose() {
    // تنظيف الـ controllers
    for (var controller in scoreControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  /// جلب طلاب الصف مع درجاتهم
  Future<void> fetchStudentsGrades() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Fetching students grades...');

      final result = await _service.getStudentsGrades(
        examId: examId,
        classId: classId,
      );

      if (result != null) {
        print('✅ Received ${result.length} students');
        students.value = result;
        _initScoreControllers();
      } else {
        errorMessage.value = 'فشل في جلب بيانات الطلاب';
        print('❌ Failed to fetch students');
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ: ${e.toString()}';
      print('❌ fetchStudentsGrades error: $e');
    } finally {
      // ✅ التأكد من إيقاف التحميل في كل الحالات
      isLoading.value = false;
      print('🔄 isLoading set to false');
    }
  }

  /// تهيئة حاويات إدخال الدرجات
  void _initScoreControllers() {
    // تنظيف الـ controllers القديمة
    for (var controller in scoreControllers.values) {
      controller.dispose();
    }
    scoreControllers.clear();
    tempScores.clear();
    modifiedStudentIds.clear();

    print('🔄 Initializing score controllers for ${students.length} students');

    for (var student in students) {
      final controller = TextEditingController();
      final studentId = student.studentId!;

      if (student.score != null) {
        controller.text = student.score!.toString();
        tempScores[studentId] = student.score!;
        print('   Student $studentId: existing score = ${student.score}');
      } else {
        controller.text = '';
        print('   Student $studentId: no score yet');
      }

      scoreControllers[studentId] = controller;

      // إضافة listener لتحديث القيم المؤقتة
      controller.addListener(() {
        _updateTempScore(studentId, controller.text);
      });
    }

    // ✅ تحديث الـ UI بعد تهيئة الـ controllers
    update();
  }

  /// تحديث الدرجة المؤقتة
  void _updateTempScore(int studentId, String value) {
    if (value.isEmpty) {
      tempScores.remove(studentId);
      modifiedStudentIds.remove(studentId);
      return;
    }
    final score = double.tryParse(value);
    if (score != null && score >= 0 && score <= maxScore.value) {
      tempScores[studentId] = score;
      modifiedStudentIds.add(studentId);
    } else if (score != null) {
      tempScores.remove(studentId);
      modifiedStudentIds.remove(studentId);
    }
  }

  /// التحقق من صحة الدرجة
  String? validateScore(String value, int studentId) {
    if (value.isEmpty) return null;
    final score = double.tryParse(value);
    if (score == null) {
      return 'يرجى إدخال رقم صحيح';
    }
    if (score < 0) {
      return 'الدرجة لا يمكن أن تكون سالبة';
    }
    if (score > maxScore.value) {
      return 'الدرجة لا تتجاوز ${maxScore.value}';
    }
    return null;
  }

  /// الحصول على الدرجة المدخلة للطالب
  double? getStudentScore(int studentId) {
    return tempScores[studentId];
  }

  /// هل الطالب لديه درجة مدخلة؟
  bool hasStudentScore(int studentId) {
    return tempScores.containsKey(studentId) && tempScores[studentId] != null;
  }

  /// عدد الطلاب الذين تم إدخال درجاتهم
  int get enteredStudentsCount {
    return modifiedStudentIds.length;
  }

  /// حفظ الدرجات
  Future<void> submitGrades() async {
    if (modifiedStudentIds.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لم تقم بإدخال أي درجات جديدة',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final grades = <GradeSubmission>[];
    for (var studentId in modifiedStudentIds) {
      final score = tempScores[studentId];
      if (score != null) {
        grades.add(GradeSubmission(studentId: studentId, score: score));
      }
    }

    if (grades.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لا توجد درجات صالحة للإرسال',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print('📤 Submitting ${grades.length} grades...');

    try {
      isSubmitting.value = true;

      final success = await _service.submitGrades(
        examId: examId,
        grades: grades,
      );

      if (success) {
        Get.snackbar(
          'تم بنجاح ✓',
          'تم حفظ درجات الطلاب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchStudentsGrades();
      } else {
        Get.snackbar(
          'فشل',
          'حدث خطأ أثناء حفظ الدرجات',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// إعادة تعيين جميع الدرجات
  void resetAllGrades() {
    for (var controller in scoreControllers.values) {
      controller.clear();
    }
    tempScores.clear();
    modifiedStudentIds.clear();
    Get.snackbar(
      'تم',
      'تم مسح جميع الدرجات',
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// إعادة تحميل البيانات
  Future<void> refreshData() async {
    await fetchStudentsGrades();
  }
}
