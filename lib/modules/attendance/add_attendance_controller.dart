import 'package:edufy/models/attendance/attendance_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'attendance_service.dart';

class AddAttendanceController extends GetxController {
  final AttendanceService _service = AttendanceService();

  final isFetching = false.obs;
  final studentsList = <StudentAttendance>[].obs;
  final studentsAttendanceStatus = <int, bool>{}.obs;
  final selectedAttendanceDate = ''.obs;
  final isSubmitting = false.obs;

  Future<void> getAttendanceList({
    required int classId,
    required int subjectId,
    required String date,
    required int sessionNumber,
  }) async {
    if (selectedAttendanceDate.value.isEmpty) {
      selectedAttendanceDate.value = date;
    }

    isFetching.value = true;
    try {
      final res = await _service.fetchAttendanceList(
        classId: classId,
        subjectId: subjectId,
        date: selectedAttendanceDate.value,
        sessionNumber: sessionNumber,
      );

      if (res != null && res.data != null) {
        studentsList.assignAll(res.data!);
        studentsAttendanceStatus.clear();

        for (var student in res.data!) {
          if (student.studentId != null) {
            studentsAttendanceStatus[student.studentId!] =
                (student.status == "present");
          }
        }
      } else {
        studentsAttendanceStatus.clear();
        studentsList.clear();
      }
    } catch (e) {
      String errorMsg = 'فشل في تحميل قائمة الطلاب';
      if (e is DioException && e.response != null && e.response?.data != null) {
        if (e.response?.data['message'] != null) {
          errorMsg = e.response?.data['message'];
        }
      }
      snackBarDef('خطأ', errorMsg, isError: true);
    } finally {
      isFetching.value = false;
    }
  }

  void updateSelectedDate({
    required String newDate,
    required int classId,
    required int subjectId,
    required int sessionNumber,
  }) {
    selectedAttendanceDate.value = newDate;
    getAttendanceList(
      classId: classId,
      subjectId: subjectId,
      date: newDate,
      sessionNumber: sessionNumber,
    );
  }

  void toggleAttendance(int studentId, bool isPresent) {
    studentsAttendanceStatus[studentId] = isPresent;
  }

  Future<void> submitAttendance({
    required int classId,
    required int subjectId,
    required String date,
    required int sessionNumber,
  }) async {
    if (studentsList.isEmpty) return;

    isSubmitting.value = true;

    try {
      List<Map<String, dynamic>> attendancePayload = [];

      for (var student in studentsList) {
        if (student.studentId != null) {
          int id = student.studentId!;
          bool isPresent = studentsAttendanceStatus[id] ?? true;
          attendancePayload.add({
            "student_id": id,
            "status": isPresent ? "present" : "absent",
          });
        }
      }

      final result = await _service.addAttendance(
        classId: classId,
        subjectId: subjectId,
        date: selectedAttendanceDate.value.isEmpty
            ? date
            : selectedAttendanceDate.value,
        sessionNumber: sessionNumber,
        attendanceList: attendancePayload,
      );

      if (result != null) {
        snackBarDef(
          'نجاح',
          result.message ?? 'تم حفظ التغييرات بنجاح',
          isError: false,
        );
        Future.delayed(const Duration(milliseconds: 600), () {
          if (Get.isOverlaysOpen) Get.back();
          Get.back();
        });
      } else {
        snackBarDef(
          'تنبيه',
          'فشل في الحفظ، قد لا توجد حصة مسجلة في هذا اليوم',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error in submitAttendance: $e");
      String errorMsg = 'حدث خطأ غير متوقع أثناء إرسال البيانات';

      if (e is DioException && e.response != null && e.response?.data != null) {
        if (e.response?.data['message'] != null) {
          errorMsg = e.response?.data['message'];
        }
      }

      snackBarDef('تنبيه', errorMsg, isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }
}
