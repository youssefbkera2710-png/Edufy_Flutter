import 'package:edufy/core/classes/subjects_helper.dart';
import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/models/schedule/schedule.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/my%20schedule/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final MyScheduleService service = MyScheduleService();
  final HomeController homeController = Get.put(HomeController());

  final isLoading = false.obs;
  final scheduleList = <Schedule>[].obs;
  final selectedDay = 'Sunday'.obs;
  final selectedChildId = Rxn<int>();

  final List<String> orderedDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() async {
    if (UserInfo.role == 'guardian') {
      int retry = 0;
      while (homeController.children.isEmpty && retry < 20) {
        await Future.delayed(const Duration(milliseconds: 300));
        retry++;
      }

      if (homeController.children.isNotEmpty) {
        selectedChildId.value = homeController.children.first.id;
      }

      getSchedule(childId: selectedChildId.value);
    } else {
      getSchedule();
    }
  }

  Future<void> getSchedule({int? childId}) async {
    isLoading.value = true;
    update();
    try {
      final result = await service.getSchedule(studentId: childId);
      if (result != null && result.data != null) {
        scheduleList.assignAll(result.data);
        _setDefaultDay();
      } else {
        scheduleList.clear();
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل في تحميل الجدول', isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _setDefaultDay() {
    if (scheduleList.isNotEmpty) {
      final today = getTodayEnglishName();
      final available = availableDays;
      if (available.contains(today)) {
        selectedDay.value = today;
      } else if (available.isNotEmpty) {
        selectedDay.value = available.first;
      }
    }
  }

  void selectChild(int id) {
    if (selectedChildId.value != id) {
      selectedChildId.value = id;
      getSchedule(childId: id);
    }
  }

  String getTodayEnglishName() {
    switch (DateTime.now().weekday) {
      case DateTime.sunday:
        return 'Sunday';
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  String get getFormattedDateForSelectedDay {
    if (selectedDay.value.toLowerCase() == 'monday') {
      return "2026-07-13";
    }
    final now = DateTime.now();
    final int todayIndex = now.weekday == DateTime.sunday ? 0 : now.weekday;

    final int targetIndex = orderedDays
        .map((d) => d.toLowerCase())
        .toList()
        .indexOf(selectedDay.value.toLowerCase());

    if (targetIndex == -1) {
      return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }

    int difference = targetIndex - todayIndex;

    final targetDate = now.add(Duration(days: difference));

    return "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}";
  }

  List<String> get availableDays {
    final found = scheduleList
        .map((e) => e.dayOfWeek?.trim())
        .where((e) => e != null && e.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    found.sort((a, b) {
      final aIndex = orderedDays.indexOf(a);
      final bIndex = orderedDays.indexOf(b);
      return aIndex.compareTo(bIndex);
    });
    return found;
  }

  List<int> get availableSessions {
    final sessions = scheduleList
        .map((e) => e.sessionNumber ?? 0)
        .where((e) => e != 0)
        .toSet()
        .toList();
    sessions.sort();
    return sessions;
  }

  List<int> get divisionNumbers {
    final sessions = scheduleList
        .map((e) => e.divisionNumber ?? 0)
        .where((e) => e != 0)
        .toSet()
        .toList();
    sessions.sort();
    return sessions;
  }

  List<Schedule> sessionsByDay(String day) {
    return scheduleList
        .where(
          (e) =>
              (e.dayOfWeek ?? '').trim().toLowerCase() ==
              day.trim().toLowerCase(),
        )
        .toList()
      ..sort((a, b) => (a.sessionNumber ?? 0).compareTo(b.sessionNumber ?? 0));
  }

  Schedule? getSessionByDayAndNumber(String day, int sessionNumber) {
    try {
      return scheduleList.firstWhere(
        (e) =>
            (e.dayOfWeek ?? '').trim().toLowerCase() ==
                day.trim().toLowerCase() &&
            e.sessionNumber == sessionNumber,
      );
    } catch (_) {
      return null;
    }
  }

  void selectDay(String day) {
    selectedDay.value = day;
    update();
  }

  String translateDay(String? day) {
    switch ((day ?? '').toLowerCase().trim()) {
      case 'sunday':
        return 'الأحد';
      case 'monday':
        return 'الإثنين';
      case 'tuesday':
        return 'الثلاثاء';
      case 'wednesday':
        return 'الأربعاء';
      case 'thursday':
        return 'الخميس';
      case 'friday':
        return 'الجمعة';
      case 'saturday':
        return 'السبت';
      default:
        return 'غير محدد';
    }
  }

  String subjectText(Schedule item) =>
      (item.subject == null || item.subject!.trim().isEmpty)
      ? 'مادة غير محددة'
      : item.subject!.trim();

  String teacherText(Schedule item) =>
      (item.teacherName == null || item.teacherName!.trim().isEmpty)
      ? 'غير محدد'
      : item.teacherName!.trim();

  String roomText(Schedule item) =>
      (item.room == null || item.room!.trim().isEmpty)
      ? 'غير محدد'
      : item.room!.trim();

  String topicText(Schedule item) =>
      (item.topic == null || item.topic!.trim().isEmpty)
      ? 'لا يوجد تفاصيل للدرس'
      : item.topic!.trim();

  Color subjectColor(BuildContext context, Schedule item, int index) {
    return SubjectHelper.getSubjectColor(context, item.subject);
  }
}
