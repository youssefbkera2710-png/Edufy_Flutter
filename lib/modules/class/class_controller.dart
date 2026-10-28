import 'package:edufy/models/class.dart';
import 'package:edufy/modules/class/class_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassController extends GetxController {
  final ClassService service = ClassService();

  RxBool isLoading = false.obs;

  RxList<Class> classes = <Class>[].obs;
  int? studentId;

  @override
  void onInit() {
    if (Get.arguments != null) {
      studentId = Get.arguments['studentId'];
    }
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;

    try {
      ClassHistoryResponse? response;
      if (studentId != null) {
        response = await service.getGuardianClassHistory(studentId!);
      } else {
        response = await service.getClassHistory();
      }
      if (response != null && response.status == 200) {
        final sortedClasses = response.data;

        sortedClasses.sort((a, b) {
          if (a.isCurrent == true) return -1;
          if (b.isCurrent == true) return 1;
          return 0;
        });

        classes.value = sortedClasses;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Color semesterColor(String semester) {
    if (semester == "first") {
      return Colors.blue;
    } else if (semester == "second") {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  String semesterText(String semester) {
    if (semester == "first") {
      return "الفصل الأول";
    } else if (semester == "second") {
      return "الفصل الثاني";
    } else {
      return semester;
    }
  }

  String stageText(String stage) {
    switch (stage) {
      case "primary":
        return "ابتدائي";

      case "middle":
        return "إعدادي";

      case "secondary":
        return "ثانوي";

      default:
        return stage;
    }
  }
}
