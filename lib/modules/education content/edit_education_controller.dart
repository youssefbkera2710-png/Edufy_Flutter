import 'dart:io';
import 'package:edufy/modules/education%20content/education_content_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import '../../models/content education/teacher_classes.dart';
import '../../models/content education/teacher_subject.dart';
import '../../../models/content%20education/education.dart';
import 'education_content_service.dart';

class EditEducationController extends GetxController {
  final Education education;
  final EducationalContentService service = EducationalContentService();

  EditEducationController({required this.education});

  final isLoading = true.obs;
  final isSubmitting = false.obs;

  final subjectsList = <SubjectModel>[].obs;
  final classesList = <ClassModel>[].obs;

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final topicController = TextEditingController();

  final allowComments = true.obs;
  final selectedSubjectId = RxnInt();
  final selectedClassesIds = <int>[].obs;

  final oldFilesUrls = <String>[].obs;
  final newPickedFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAndPrepareData();
  }

  Future<void> _loadAndPrepareData() async {
    isLoading.value = true;
    try {
      await fetchSubjectsAndClasses();
      _prepareEditFields();
    } catch (e) {
      debugPrint("Error preparing data: $e");
    } finally {
      isLoading.value = false;
    }
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
      debugPrint("Error loading dropdown data: $e");
    }
  }

  void _prepareEditFields() {
    titleController.text = education.title ?? "";
    bodyController.text = education.body ?? "";
    topicController.text = education.topic ?? "";
    allowComments.value = education.allowComments ?? true;

    final matchingSubject = subjectsList.firstWhereOrNull(
      (sub) => sub.id == education.subjectId,
    );
    selectedSubjectId.value = matchingSubject?.id;

    selectedClassesIds.clear();
    if (education.classesIds != null) {
      selectedClassesIds.assignAll(education.classesIds!);
    }

    if (education.files != null) {
      oldFilesUrls.assignAll(
        education.files!
            .map((m) => m.url ?? "")
            .where((url) => url.isNotEmpty)
            .toList(),
      );
    } else {
      oldFilesUrls.clear();
    }
    newPickedFiles.clear();
  }

  void addPickedFile(File file) => newPickedFiles.add(file);
  void removeNewFile(int index) => newPickedFiles.removeAt(index);
  void removeOldFile(int index) => oldFilesUrls.removeAt(index);

  Future<void> updateContent() async {
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
      final result = await service.updateEducationalContent(
        id: education.id!,
        title: titleController.text,
        body: bodyController.text,
        topic: topicController.text,
        subjectId: selectedSubjectId.value!,
        classesIds: selectedClassesIds.toList(),
        allowComments: allowComments.value,
        oldFilesUrls: oldFilesUrls.toList(),
        newFiles: newPickedFiles.toList(),
      );

      if (result != null) {
        snackBarDef('نجاح', 'تم تعديل المحتوى بنجاح');

        if (Get.isRegistered<EducationalContentController>()) {

          Get.find<EducationalContentController>().loadInitialData();
        }

        Navigator.of(Get.context!).pop();
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل التعديل', isError: true);
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
