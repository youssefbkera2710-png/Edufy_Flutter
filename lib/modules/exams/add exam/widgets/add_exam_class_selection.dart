// lib/modules/exams/add_exam/widgets/add_exam_class_selection.dart
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExamClassSelection extends StatelessWidget {
  final AddExamController controller;

  const AddExamClassSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasSelected = controller.selectedClasses.isNotEmpty;
      final isLoading = controller.isLoadingClasses.value;

      return GestureDetector(
        onTap: () {
          if (controller.selectedSubject.value == null) {
            Get.snackbar(
              'تنبيه',
              'يرجى اختيار المادة أولاً',
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            );
            return;
          }
          if (isLoading) return;
          controller.showClassSelectionDialog(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasSelected
                  ? context.primary
                  : context.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.school_outlined, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر الصفوف',
                      style: TextStyle(
                        fontSize: hasSelected ? 14 : 10,
                        fontWeight: hasSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.selectedClassesText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.primary,
                  ),
                )
              else if (hasSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.selectedClasses.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: context.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      );
    });
  }
}
