import 'package:edufy/models/absence.dart';
import 'package:edufy/models/attendance_and_absence.dart';
import 'package:edufy/models/attendance_statistics.dart';
import 'package:edufy/models/behaviors.dart';
import 'package:edufy/models/children.dart';
import 'package:edufy/models/exam.dart';
import 'package:edufy/models/expenses.dart';
import 'package:edufy/models/grade.dart';
import 'package:edufy/models/invoice.dart';
import 'package:edufy/models/payment_history.dart';
import 'package:edufy/models/teacher_exam.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/models/teacher_statistics.dart';
import 'package:edufy/models/user.dart';
import 'package:edufy/modules/home/guardian/guardian_service.dart';
import 'package:edufy/modules/home/home_service.dart';
import 'package:edufy/modules/home/student/student_service.dart';
import 'package:edufy/modules/home/teacher/teacher_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:edufy/core/config/user_info.dart';

class HomeController extends GetxController {
  User user = User();
  AttendanceStatistics attendanceStatistics = AttendanceStatistics();
  AttendanceAndAbsence attendanceAndAbsence = .new();
  Grade grade = Grade();
  Expenses expenses = Expenses();
  List<Exam> exams = [];
  List<Exam> studentExams = [];
  List<Exam> guardianExams = [];
  List<Children> children = [];
  List<PaymentHistory> payments = [];
  List<Invoice> invoices = [];
  List<Absence> absences = [];
  List<Datums> teacherExams = [];
  List<HomeworkModel> teacherHomework = [];
  List<Datums> homeTeacherExams = [];
  List<HomeworkModel> studentHomeworks = [];
  List<HomeworkModel> guardianHomeworks = [];
  List<Behaviors> behaviors = [];

  int currentExamPage = 1;
  bool isFetchingMoreExams = false;
  bool hasMoreExams = true;

  int currentHomeworkPage = 1;
  bool isFetchingMoreHomeWork = false;
  bool hasMoreHomework = true;
  bool isDeleteLoading = false;
  bool isLoadingHomework = false;
  bool isLoadingBehaviors = false;

  bool isLoadingAttendance = false;
  bool isLoadingExams = false;
  bool isLoadingExamsStudent = false;
  bool isLoadingInvoices = false;
  bool isLoading = true;
  bool isLoadingAbsences = false;
  bool isLoadingHomeworks = false;
  bool isLoadingGuardianHomeworks = false;
  bool isLoadingStudentExams = false;
  bool isLoadingGuardianExams = false;
  bool isRefreshing = false;
  bool isSubmitting = false;
  TeacherStatistics? teacherStatistics;
  String? errorMessage;
  bool isTeacherDataLoaded = false;
  bool isStudentDataLoaded = false;
  RxInt notificationCount = 0.obs;
  final HomeService service = HomeService();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await fetchAllData();
    await loadNotificationCount();
  }

  Future<bool> hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> loadNotificationCount() async {
    try {
      notificationCount.value = await service.getNotificationCount();
    } catch (e) {
      print('Failed to load notification count: $e');
      notificationCount.value = 0;
    }
  }

  Future<bool> fetchAllData({bool isRefresh = false}) async {
    // تعيين حالة التحميل
    if (isRefresh) {
      isRefreshing = true;
    } else {
      isLoading = true;
      errorMessage = null;
      isStudentDataLoaded = false;
      isTeacherDataLoaded = false;
    }
    update();

    // التحقق من الاتصال بالإنترنت
    if (!await hasInternet()) {
      errorMessage = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';
      finishLoading(isRefresh);
      return false;
    }

    try {
      // 1. جلب بيانات المستخدم
      final userData = await StudentService().getUserData();
      if (userData != null) {
        user = userData;
      } else {
        errorMessage = 'فشل في جلب بيانات المستخدم';
        finishLoading(isRefresh);
        return false;
      }

      // 2. جلب البيانات حسب الدور
      if (UserInfo.role == 'student') {
        await fetchStudentData();
        isStudentDataLoaded = true;
      } else if (UserInfo.role == 'guardian') {
        await fetchGuardianData();
      } else if (UserInfo.role == 'teacher') {
        await fetchTeacherData();
        isTeacherDataLoaded = true;
      } else {
        errorMessage = 'صلاحية المستخدم غير معروفة';
      }

      // التحقق من وجود أخطاء بعد التحميل
      if (errorMessage != null) {
        print('⚠️ Error after loading: $errorMessage');
      }
    } catch (e) {
      print('❌ fetchAllData error: $e');
      errorMessage = 'حدث خطأ: ${e.toString()}';
    } finally {
      finishLoading(isRefresh);
    }

    return errorMessage == null;
  }

  Future<void> fetchStudentData() async {
    try {
      final results = await Future.wait([
        StudentService().getAttendanceStatistics(),
        StudentService().getGrade(),
        StudentService().getAllExamStudent(),
        StudentService().getStudentHomeworks(),
      ]);

      if (results[0] != null) {
        attendanceStatistics = results[0] as AttendanceStatistics;
      }

      if (results[1] != null) {
        grade = results[1] as Grade;
      }
      if (results[2] != null) {
        studentExams = results[2] as List<Exam>;
        exams = studentExams;
      }
      if (results[3] != null) {
        studentHomeworks = results[3] as List<HomeworkModel>;
      }

      if (grade == null) {
        grade = Grade(); // إنشاء كائن فارغ بدلاً من تعيين errorMessage
      }
    } catch (e) {
      print('❌ fetchStudentData error: $e');
      errorMessage = 'فشل في جلب بيانات الطالب';
    }
  }

  Future<void> fetchGuardianData() async {
    final results = await Future.wait([
      GuardianService().getAllChildren(),
      GuardianService().getExpenses(),
      GuardianService().getPaymentHistory(),
    ]);

    if (results[0] != null) children = results[0] as List<Children>;
    if (results[1] != null) expenses = results[1] as Expenses;
    if (results[2] != null) payments = results[2] as List<PaymentHistory>;
  }

  void finishLoading(bool isRefresh) {
    if (isRefresh) {
      isRefreshing = false;
    } else {
      isLoading = false;
    }
    update();
  }

  Future<void> fetchBehaviors({String? studentName}) async {
    isLoadingBehaviors = true;
    update();
    try {
      final result = await GuardianService().getBehaviors(
        studentName: studentName,
      );
      if (result != null) behaviors = result;
    } catch (e) {
      print('fetchBehaviors error: $e');
    } finally {
      isLoadingBehaviors = false;
      update();
    }
  }

  Future<void> fetchInvoicesByStudentName({required String studentName}) async {
    isLoadingInvoices = true;
    update();
    try {
      final List<Invoice>? invoice = await GuardianService().getInvoice(
        studentName: studentName,
      );
      if (invoice != null) invoices = invoice;
    } catch (e) {
      errorMessage = 'فشل جلب الفواتير: $e';
    } finally {
      isLoadingInvoices = false;
      update();
    }
  }

  Future<void> fetchAbsenceByStudentName({required String studentName}) async {
    isLoadingAbsences = true;
    update();
    try {
      final List<Absence>? absence = await GuardianService().getAbsence(
        studentName: studentName,
      );
      if (absence != null) absences = absence;
    } catch (e) {
      errorMessage = 'فشل جلب الاعذار: $e';
    } finally {
      isLoadingAbsences = false;
      update();
    }
  }

  Future<void> submitAbsenceRequest({
    required String studentId,
    required String absenceDate,
    required String reason,
    String? attachmentPath,
  }) async {
    isSubmitting = true;
    update();
    try {
      final success = await GuardianService().submitAbsenceRequest(
        studentId: studentId,
        absenceDate: absenceDate,
        reason: reason,
        attachmentPath: attachmentPath,
      );
      if (success) {
        Get.back();
        Get.snackbar(
          'تم بنجاح ✓',
          'تم تقديم طلب العذر بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'فشل',
          'حدث خطأ أثناء تقديم الطلب',
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
      isSubmitting = false;
      update();
    }
  }

  Future<void> getAllExamForChildren({required int studentId}) async {
    if (guardianExams.isNotEmpty) {
      print('✅ Using cached guardian exams: ${guardianExams.length} exams');
      exams = guardianExams;
      return;
    }

    isLoadingGuardianExams = true;
    update();
    try {
      final List<Exam>? examsChild = await GuardianService().getAllExam(
        id: studentId,
      );
      if (examsChild != null) {
        guardianExams = examsChild;
        exams = guardianExams;
      }
    } catch (e) {
      print('Error loading guardian exams: $e');
    } finally {
      isLoadingGuardianExams = false;
      update();
    }
  }

  Future<void> getAllExamForStudent() async {
    if (studentExams.isNotEmpty) {
      print('✅ Using cached student exams: ${studentExams.length} exams');
      exams = studentExams;
      return;
    }
    isLoadingStudentExams = true;
    update();
    try {
      final List<Exam>? examsChild = await StudentService().getAllExamStudent();
      if (examsChild != null) {
        studentExams = examsChild;
        exams = studentExams;
      }
    } catch (e) {
      print('Error loading student exams: $e');
    } finally {
      isLoadingStudentExams = false;
      update();
    }
  }

  Future<void> fetchDailyAttendance({
    required int studentId,
    String? status,
    String? from,
    String? to,
  }) async {
    isLoadingAttendance = true;
    attendanceAndAbsence = AttendanceAndAbsence();
    update();
    try {
      final result = UserInfo.role == "guardian"
          ? await GuardianService().getDailyAttendance(
              studentId: studentId,
              status: status,
              from: from,
              to: to,
            )
          : await StudentService().getDailyAttendanceStudent(
              status: status,
              from: from,
              to: to,
            );
      if (result != null) attendanceAndAbsence = result;
    } catch (e) {
      print('fetchDailyAttendance error: $e');
    } finally {
      isLoadingAttendance = false;
      update();
    }
  }

  Future<void> fetchTeacherData() async {
    try {
      await Future.wait([
        fetchTeacherExams(limit: 3),
        fetchTeacherHomework(),
        fetchTeacherStatistics(),
      ]);

      if (teacherStatistics == null) {
        errorMessage = 'لا توجد بيانات للمعلم';
      }
    } catch (e) {
      print('❌ fetchTeacherData error: $e');
      errorMessage = 'فشل في جلب بيانات المعلم';
      // ❌ لا تستخدم rethrow هنا
    }
  }

  Future<void> fetchTeacherExams({bool isRefresh = false, int? limit}) async {
    if (isRefresh) {
      currentExamPage = 1;
      hasMoreExams = true;
      teacherExams.clear();
    }

    if (limit == null) {
      if (currentExamPage == 1) {
        isLoadingExams = true;
      } else {
        isFetchingMoreExams = true;
      }
      update();
    }

    try {
      final result = await TeacherService().getTeacherExams(
        page: currentExamPage,
        limit: limit ?? 15,
      );
      if (result != null && result.data != null) {
        if (limit != null) {
          homeTeacherExams = result.data!;
        } else {
          if (currentExamPage == 1) {
            teacherExams = result.data!;
          } else {
            teacherExams.addAll(result.data!);
          }
          hasMoreExams = result.pagination?.hasMorePages ?? false;
          if (hasMoreExams) currentExamPage++;
        }
      }
    } catch (e) {
      print('fetchTeacherExams error: $e');
    } finally {
      if (limit == null) {
        isLoadingExams = false;
        isFetchingMoreExams = false;
      }
      update();
    }
  }

  Future<bool> deleteExamForTeacher({required int id}) async {
    isDeleteLoading = true;
    update();
    try {
      final success = await TeacherService().deleteExam(id);
      if (success) {
        await fetchTeacherExams(isRefresh: true);
        await fetchTeacherExams(limit: 3);
        Get.snackbar(
          'تم بنجاح ✓',
          'تم حذف الاختبار بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'فشل',
          'حدث خطأ في حذف الاختبار',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print('deleteExamForTeacher error: $e');
      return false;
    } finally {
      isDeleteLoading = false;
      update();
    }
  }

  Future<void> fetchTeacherStatistics() async {
    try {
      final result = await TeacherService().getTeacherStatistics();
      if (result != null) teacherStatistics = result;
    } catch (e) {
      print('fetchTeacherStatistics error: $e');
    }
  }

  Future<bool> deleteHomewrokForTeacher({required int id}) async {
    isDeleteLoading = true;
    update();

    try {
      final success = await TeacherService().deleteHomework(id);

      if (success) {
        await fetchTeacherData();
        Get.snackbar(
          'تم بنجاح ✓',
          'تم حذف الواجب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'فشل',
          'حدث خطأ في حذف الواجب حاول مجدداً',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (error) {
      print('deleteHomewrokForTeacher error: $error');
      return false;
    } finally {
      isDeleteLoading = false;
      update();
    }
  }

  Future<void> loadMoreExams() async {
    if (isFetchingMoreExams || !hasMoreExams) return;
    await fetchTeacherExams();
  }

  Future<void> loadMoreHomework() async {
    if (isFetchingMoreHomeWork || !hasMoreHomework) return;
    await fetchTeacherHomework();
  }

  Future<void> fetchTeacherHomework({bool isRefresh = false}) async {
    if (isRefresh) {
      currentHomeworkPage = 1;
      hasMoreHomework = true;
      teacherHomework.clear();
    }

    if (currentHomeworkPage == 1) {
      isLoadingHomework = true;
    } else {
      isFetchingMoreHomeWork = true;
    }
    update();

    try {
      final result = await TeacherService().getTeacherHomework(
        page: currentHomeworkPage,
      );
      if (result != null) {
        if (currentHomeworkPage == 1) {
          teacherHomework = result.data;
        } else {
          teacherHomework.addAll(result.data);
        }
        hasMoreHomework = result.pagination?.hasMorePages ?? false;
        if (hasMoreHomework) currentHomeworkPage++;
      }
    } catch (e) {
      print('fetchTeacherHomework error: $e');
    } finally {
      isLoadingHomework = false;
      isFetchingMoreHomeWork = false;
      update();
    }
  }

  Future<void> getStudentHomeworks() async {
    isLoadingHomeworks = true;
    update();
    try {
      final result = await StudentService().getStudentHomeworks();
      if (result != null) {
        studentHomeworks = result;
      }
    } catch (e) {
      print('Error loading student homeworks: $e');
    } finally {
      isLoadingHomeworks = false;
      update();
    }
  }

  Future<void> getGuardianChildHomeworks({required int childId}) async {
    isLoadingGuardianHomeworks = true;
    update();
    try {
      final result = await GuardianService().getChildHomeworks(
        childId: childId,
      );
      if (result != null) {
        guardianHomeworks = result;
      }
    } catch (e) {
      print('Error loading guardian child homeworks: $e');
    } finally {
      isLoadingGuardianHomeworks = false;
      update();
    }
  }
}
