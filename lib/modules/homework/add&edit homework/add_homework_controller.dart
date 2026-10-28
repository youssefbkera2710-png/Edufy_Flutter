import 'dart:io';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/content%20education/teacher_classes.dart';
import 'package:edufy/models/content%20education/teacher_subject.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/modules/homework/add&edit%20homework/add_homework_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class AddHomeworkController extends GetxController {
  final AddHomeworkService _service = AddHomeworkService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final topicController = TextEditingController();

  // State variables
  final RxInt editingHomeworkId = RxInt(0);
  final RxBool isEditMode = RxBool(false);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxList<File> newAttachments = <File>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingData = RxBool(true);
  final RxString errorMessage = ''.obs;

  // Data lists
  final RxList<ClassModel> classes = <ClassModel>[].obs;
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;

  // Selected items
  final Rxn<ClassModel> selectedClass = Rxn<ClassModel>();
  final Rxn<SubjectModel> selectedSubject = Rxn<SubjectModel>();

  // Existing attachments
  final RxList<HomeworkAttachment> existingAttachments =
      <HomeworkAttachment>[].obs;

  String get formattedDate {
    if (selectedDate.value == null) return '';
    final d = selectedDate.value!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  List<int> get keepAttachmentIds => existingAttachments
      .where((att) => att.id != null)
      .map((att) => att.id!)
      .toList();

  Future<void> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Attachments - New files
  Future<void> pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            newAttachments.add(File(file.path!));
          }
        }
      }
    } catch (e) {
      print('Error picking attachment: $e');
      Get.snackbar('خطأ', 'فشل في اختيار الملف');
    }
  }

  void removeNewAttachment(int index) {
    if (index >= 0 && index < newAttachments.length) {
      newAttachments.removeAt(index);
    }
  }

  // Attachments - Existing files
  void removeExistingAttachment(int attachmentId) {
    existingAttachments.removeWhere((att) => att.id == attachmentId);
  }

  // Load data
  Future<void> loadClasses() async {
    if (classes.isNotEmpty) return;
    try {
      classes.assignAll(await _service.getTeacherClasses());
    } catch (e) {
      print('Error loading classes: $e');
    }
  }

  Future<void> loadSubjects() async {
    if (subjects.isNotEmpty) return;
    try {
      subjects.assignAll(await _service.getTeacherSubjects());
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  Future<void> loadHomeworkForEdit(int id) async {
    isLoading.value = true;
    isLoadingData.value = true;
    isEditMode.value = true;
    editingHomeworkId.value = id;

    try {
      final homework = await _service.getHomeworkById(id);
      if (homework == null) return;

      titleController.text = homework.title ?? '';
      descriptionController.text = homework.description ?? '';
      topicController.text = homework.topic ?? '';
      selectedDate.value = homework.dueDate;

      await Future.wait([loadClasses(), loadSubjects()]);

      if (homework.classId != null && homework.classId! > 0) {
        final foundClass = classes.firstWhereOrNull(
          (c) => c.id == homework.classId,
        );
        if (foundClass != null) {
          selectedClass.value = foundClass;
        }
      }

      if (homework.subjectId != null && homework.subjectId! > 0) {
        final foundSubject = subjects.firstWhereOrNull(
          (s) => s.id == homework.subjectId,
        );
        if (foundSubject != null) {
          selectedSubject.value = foundSubject;
        }
      }

      existingAttachments.assignAll(homework.attachments ?? []);
    } catch (e) {
      print('Error loading homework: $e');
    } finally {
      isLoading.value = false;
      isLoadingData.value = false;
    }
  }

  Future<HomeworkResponse?> submitHomework() async {
    final classId = selectedClass.value!.id ?? 0;
    final subjectId = selectedSubject.value!.id ?? 0;
    final titleText = titleController.text.trim();
    final descriptionText = descriptionController.text.trim();
    final topicText = topicController.text.trim();
    isLoading.value = true;
    errorMessage.value = '';

    try {
      HomeworkResponse? response;

      if (isEditMode.value && editingHomeworkId.value > 0) {
        // Edit mode
        print('📝 Editing homework ID: ${editingHomeworkId.value}');
        print('   Keeping attachments: ${keepAttachmentIds.length}');
        print('   New attachments: ${newAttachments.length}');

        response = await _service.updateHomework(
          id: editingHomeworkId.value,
          title: titleText,
          description: descriptionText,
          dueDate: formattedDate,
          classId: classId,
          subjectId: subjectId,
          topic: topicText,
          newAttachmentPaths: newAttachments.isNotEmpty
              ? newAttachments.map((file) => file.path).toList()
              : null,
          existingAttachments: existingAttachments.toList(),
        );
      } else {
        // Create mode
        print('✨ Creating new homework');
        response = await _service.createHomework(
          title: titleText,
          description: descriptionText,
          dueDate: formattedDate,
          classId: classId,
          subjectId: subjectId,
          topic: topicText,
          attachmentPaths: newAttachments.isNotEmpty
              ? newAttachments.map((file) => file.path).toList()
              : null,
        );
      }

      if (response != null &&
          (response.status == 200 || response.status == 201)) {
        _clearForm();
        return response;
      } else {
        errorMessage.value = response?.message ?? 'فشل في حفظ الواجب';
        return response;
      }
    } catch (e) {
      print('Error in submitHomework: $e');
      errorMessage.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    topicController.clear();
    newAttachments.clear();
    selectedDate.value = null;
    selectedClass.value = null;
    selectedSubject.value = null;
    isEditMode.value = false;
    editingHomeworkId.value = 0;
    existingAttachments.clear();
  }

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    loadClasses();
    loadSubjects();
    isLoadingData.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    topicController.dispose();
    super.onClose();
  }
}

// ✅ Extension for firstWhereOrNull
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
