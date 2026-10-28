import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/content%20education/teacher_classes.dart';
import 'package:edufy/models/content%20education/teacher_subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_exam_service.dart';

class AddExamController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final maxScoreController = TextEditingController(text: '100');
  final durationController = TextEditingController();
  final descriptionController = TextEditingController();
  final topicController = TextEditingController();

  final RxBool isEditMode = false.obs;
  final RxInt editingExamId = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingData = false.obs;
  final RxBool isLoadingClasses = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final RxList<ClassModel> availableClasses = <ClassModel>[].obs;

  final Rxn<SubjectModel> selectedSubject = Rxn<SubjectModel>();
  final RxList<ClassModel> selectedClasses = <ClassModel>[].obs;

  String get formattedDate {
    if (selectedDate.value == null) return '';
    final d = selectedDate.value!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get selectedClassesText {
    if (selectedClasses.isEmpty) return 'اختر الصفوف';
    return selectedClasses
        .map(
          (c) =>
              '${c.gradeLevel ?? ''} - ${c.stage ?? ''} ش${c.divisionNumber ?? 0}',
        )
        .join('، ');
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.primary,
            onPrimary: context.white,
            surface: context.white,
            onSurface: context.black2,
          ),
          dialogBackgroundColor: context.white,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> loadSubjects() async {
    if (subjects.isNotEmpty) return;

    try {
      isLoadingData.value = true;
      errorMessage.value = '';

      final result = await AddExamService().getTeacherSubjects();

      if (result != null && result.isNotEmpty) {
        subjects.assignAll(result);
      } else {
        subjects.clear();
        print('⚠️ No subjects available');
      }
    } catch (e) {
      print('Error loading subjects: $e');
      subjects.clear();
      errorMessage.value = 'فشل تحميل المواد: ${e.toString()}';
    } finally {
      isLoadingData.value = false;
    }
  }

  Future<void> loadClassesBySubject(int subjectId) async {
    try {
      isLoadingClasses.value = true;
      final classes = await AddExamService().getTeacherClassesBySubject(
        subjectId,
      );
      availableClasses.assignAll(classes);

      selectedClasses.removeWhere(
        (c) => !availableClasses.any((ac) => ac.id == c.id),
      );
    } catch (e) {
      print('Error loading classes by subject: $e');
      availableClasses.clear();
    } finally {
      isLoadingClasses.value = false;
    }
  }

  Future<void> loadExamForEdit(int id) async {
    isLoadingData.value = true;
    isEditMode.value = true;
    editingExamId.value = id;

    try {
      final examFuture = AddExamService().getExamById(id);
      final subjectsFuture = AddExamService().getTeacherSubjects();

      final results = await Future.wait([examFuture, subjectsFuture]);

      final exam = results[0] as TeacherExam?;
      final subjectList = results[1] as List<SubjectModel>;

      subjects.assignAll(subjectList);

      if (exam == null) {
        errorMessage.value = 'لم يتم العثور على الاختبار';
        return;
      }

      titleController.text = exam.title ?? '';
      descriptionController.text = exam.description ?? '';
      maxScoreController.text = exam.maxScore?.toString() ?? '100';
      if (exam.durationMinutes != null) {
        durationController.text = exam.durationMinutes.toString();
      }
      if (exam.examDate != null) {
        selectedDate.value = DateTime.tryParse(exam.examDate!);
      }

      if (exam.assignments != null && exam.assignments!.isNotEmpty) {
        final firstAssignment = exam.assignments!.first;
        if (firstAssignment.subjectId != null) {
          selectedSubject.value = subjects.firstWhereOrNull(
            (s) => s.id == firstAssignment.subjectId,
          );
          if (firstAssignment.subjectId != null) {
            await loadClassesBySubject(firstAssignment.subjectId!);
          }
        }
        if (firstAssignment.topic != null) {
          topicController.text = firstAssignment.topic!;
        }

        final classIds = exam.assignments!
            .map((a) => a.classId)
            .where((id) => id != null)
            .toList();

        await Future.delayed(Duration(milliseconds: 100));
        selectedClasses.assignAll(
          availableClasses.where((c) => classIds.contains(c.id)).toList(),
        );
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل البيانات: $e';
      print('loadExamForEdit error: $e');
    } finally {
      isLoadingData.value = false;
    }
  }

  // Show class selection dialog
  void showClassSelectionDialog(BuildContext context) {
    if (availableClasses.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لا توجد صفوف متاحة لهذه المادة',
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_rounded),
                      const SizedBox(width: 8),
                      Text(
                        'اختر الصفوف',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableClasses.length,
                        itemBuilder: (context, index) {
                          final classItem = availableClasses[index];
                          final isSelected = selectedClasses.any(
                            (c) => c.id == classItem.id,
                          );
                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(
                              '${classItem.gradeLevel ?? ''} - ${classItem.stage ?? ''} ش${classItem.divisionNumber ?? 0}',
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: classItem.specialization != null
                                ? Text('تخصص: ${classItem.specialization}')
                                : null,
                            onChanged: (selected) {
                              if (selected == true) {
                                if (!selectedClasses.any(
                                  (c) => c.id == classItem.id,
                                )) {
                                  selectedClasses.add(classItem);
                                  setState(() {});
                                }
                              } else {
                                selectedClasses.removeWhere(
                                  (c) => c.id == classItem.id,
                                );
                                setState(() {});
                              }
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: context.primary,
                            checkColor: Colors.white,
                            tileColor: isSelected
                                ? context.primary.withOpacity(0.05)
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: isSelected
                                  ? BorderSide(color: context.primary, width: 1)
                                  : BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: context.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () => Text(
                              'تم اختيار ${selectedClasses.length} صف',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedClasses.isEmpty) {
                            Get.snackbar(
                              'تنبيه',
                              'يرجى اختيار صف واحد على الأقل',
                              backgroundColor: Colors.redAccent,
                            );
                            return;
                          }
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Obx(
                          () => Text(
                            selectedClasses.isEmpty
                                ? 'تأكيد'
                                : 'تأكيد (${selectedClasses.length})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onSubjectChanged(SubjectModel? value) {
    selectedSubject.value = value;
    if (value != null && value.id != null) {
      selectedClasses.clear();
      loadClassesBySubject(value.id!);
    } else {
      availableClasses.clear();
      selectedClasses.clear();
    }
  }

  Future<ExamResponse?> submitExam() async {
    if (!formKey.currentState!.validate()) return null;

    if (selectedDate.value == null) {
      _showError('يرجى اختيار تاريخ الاختبار');
      return null;
    }

    if (selectedSubject.value == null) {
      _showError('يرجى اختيار المادة');
      return null;
    }

    if (selectedClasses.isEmpty) {
      _showError('يرجى اختيار صف واحد على الأقل');
      return null;
    }

    // تجهيز الـ assignments لكل صف مختار
    final assignments = selectedClasses.map((classItem) {
      return {
        "class_id": classItem.id ?? 0,
        "subject_id": selectedSubject.value!.id ?? 0,
        "topic": topicController.text.trim(),
      };
    }).toList();

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final int? duration = durationController.text.trim().isNotEmpty
          ? int.tryParse(durationController.text.trim())
          : null;

      ExamResponse result;

      if (isEditMode.value && editingExamId.value > 0) {
        result = await AddExamService().updateExam(
          id: editingExamId.value,
          title: titleController.text.trim(),
          examDate: formattedDate,
          maxScore: int.tryParse(maxScoreController.text.trim()) ?? 100,
          description: descriptionController.text.trim(),
          assignments: assignments,
          durationMinutes: duration,
        );
      } else {
        result = await AddExamService().createExam(
          title: titleController.text.trim(),
          examDate: formattedDate,
          maxScore: int.tryParse(maxScoreController.text.trim()) ?? 100,
          description: descriptionController.text.trim(),
          assignments: assignments,
          durationMinutes: duration,
        );
      }

      if (result.success) {
        clearForm();
        return result;
      } else {
        errorMessage.value = result.message ?? 'حدث خطأ';
        return result;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar('تنبيه', message, backgroundColor: Colors.redAccent);
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    maxScoreController.text = '100';
    durationController.clear();
    topicController.clear();
    selectedDate.value = null;
    selectedSubject.value = null;
    selectedClasses.clear();
    availableClasses.clear();
    isEditMode.value = false;
    editingExamId.value = 0;
  }

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
  }

  @override
  void onClose() {
    titleController.dispose();
    maxScoreController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    topicController.dispose();
    super.onClose();
  }
}

// Extension للبحث في القوائم
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
