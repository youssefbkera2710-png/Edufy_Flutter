import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/content education/teacher_classes.dart';
import '../../models/content education/teacher_subject.dart';
import 'education_content_service.dart';
import 'education_content_controller.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';

class CreateEducationController extends GetxController {
  final EducationalContentService service = EducationalContentService();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final topicController = TextEditingController();

  final selectedSubjectId = Rxn<int>();
  final selectedClassesIds = <int>[].obs;
  final allowComments = true.obs;
  final isSubmitting = false.obs;

  final subjectsList = <SubjectModel>[].obs;
  final classesList = <ClassModel>[].obs;
  final newPickedFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjectsAndClasses();
  }

  Future<void> fetchSubjectsAndClasses() async {
    try {
      final subjectRes = await service.getSubjects();
      final classRes = await service.getClasses();

      if (subjectRes != null && subjectRes.data != null) {
        subjectsList.assignAll(subjectRes.data!);
      }
      if (classRes != null && classRes.data != null) {
        classesList.assignAll(classRes.data!);
      }
    } catch (e) {
      print("Error loading dropdown data: $e");
    }
  }

  void resetFields() {
    titleController.clear();
    bodyController.clear();
    topicController.clear();
    newPickedFiles.clear();
    selectedSubjectId.value = null;
    selectedClassesIds.clear();
    allowComments.value = true;
    isSubmitting.value = false;
  }

  void addPickedFile(File file) => newPickedFiles.add(file);
  void removeNewFile(int index) => newPickedFiles.removeAt(index);

  void createContent() async {
    if (selectedSubjectId.value == null) {
      snackBarDef('تنبيه', 'يرجى اختيار المادة التعليمية', isError: true);
      return;
    }
    if (selectedClassesIds.isEmpty) {
      snackBarDef('تنبيه', 'يرجى اختيار صف واحد على الأقل', isError: true);
      return;
    }
    if (titleController.text.trim().isEmpty ||
        bodyController.text.trim().isEmpty) {
      snackBarDef('تنبيه', 'يرجى ملء العنوان والمحتوى', isError: true);
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await service.addEducationalContent(
        title: titleController.text,
        body: bodyController.text,
        topic: topicController.text,
        subjectId: selectedSubjectId.value!,
        classesIds: selectedClassesIds.toList(),
        allowComments: allowComments.value,
        selectedFiles: newPickedFiles,
      );

      if (result != null && (result.status == 200 || result.status == 201)) {
        snackBarDef('نجاح', 'تم إضافة المحتوى بنجاح');

        if (Get.isRegistered<EducationalContentController>()) {
          Get.find<EducationalContentController>().getAllContents();
        }

        resetFields();
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل الإضافة', isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    topicController.dispose();
    super.onClose();
  }
}
