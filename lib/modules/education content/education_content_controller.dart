import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/content education/teacher_classes.dart';
import '../../models/content education/teacher_subject.dart';
import '../../models/content%20education/education.dart';
import 'education_content_service.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/modules/home/home_controller.dart';

class EducationalContentController extends GetxController {
  final EducationalContentService service = EducationalContentService();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isSubmitting = false.obs;

  final contentList = <Education>[].obs;
  final subjectsList = <SubjectModel>[].obs;
  final classesList = <ClassModel>[].obs;

  final selectedChildId = RxnInt();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final topicController = TextEditingController();

  var allowComments = true.obs;

  var selectedSubjectId = RxnInt();
  var selectedClassesIds = <int>[].obs;

  var oldFilesUrls = <String>[].obs;
  var newPickedFiles = <File>[].obs;

  int _currentPage = 1;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    if (UserInfo.role == 'guardian') {
      try {
        final homeController = Get.find<HomeController>();
        if (homeController.children.isNotEmpty) {
          selectedChildId.value = homeController.children.first.id;
        }
      } catch (e) {
        debugPrint("Error setting initial child: $e");
      }
    }

    await getAllContents(isRefresh: true);
    await fetchSubjectsAndClasses();
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
  void selectChild(int childId) {
    selectedChildId.value = childId;
    getAllContents(isRefresh: true);
  }

  void addPickedFile(File file) => newPickedFiles.add(file);
  void removeNewFile(int index) => newPickedFiles.removeAt(index);
  void removeOldFile(int index) => oldFilesUrls.removeAt(index);

  Future<void> getAllContents({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      isLoading.value = true;
    } else {
      if (!_hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final result = await service.getAllContent(
        childId: selectedChildId.value,
        page: _currentPage,
      );

      if (result != null && result.data != null) {
        final List<Education> fetchedContents = result.data!;

        if (isRefresh) {
          contentList.assignAll(fetchedContents);
        } else {
          contentList.addAll(fetchedContents);
        }

        if (result.pagination?.hasMorePages == false ||
            fetchedContents.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage++;
        }
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل تحميل المحتوى', isError: true);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> createContent() async {
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
        Navigator.of(Get.context!).pop();
        clearAllFields();
        getAllContents(
          isRefresh: true,
        );
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل الإضافة', isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateContent({required int id}) async {
    if (selectedSubjectId.value == null) {
      snackBarDef('تنبيه', 'يرجى اختيار المادة التعليمية', isError: true);
      return;
    }
    if (selectedClassesIds.isEmpty) {
      snackBarDef('تنبيه', 'يرجى اختيار صف واحد على الأقل', isError: true);
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await service.updateEducationalContent(
        id: id,
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
        clearAllFields();
        Get.back();
        getAllContents(isRefresh: true);
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل التعديل', isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteContent(int id) async {
    try {
      final result = await service.deleteEducationalContent(id);
      if (result != null) {
        snackBarDef('نجاح', 'تم حذف المحتوى بنجاح');
        getAllContents(isRefresh: true);
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل حذف المحتوى', isError: true);
    }
  }

  void prepareEdit(Education education) {
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

  void clearAllFields() {
    titleController.clear();
    bodyController.clear();
    topicController.clear();
    selectedSubjectId.value = null;
    selectedClassesIds.clear();
    newPickedFiles.clear();
    oldFilesUrls.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    topicController.dispose();
    super.onClose();
  }
}
