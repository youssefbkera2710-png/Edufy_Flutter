// lib/modules/exams/add_exam/widgets/add_exam_subject_dropdown.dart
import 'package:edufy/models/content%20education/teacher_subject.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_controller.dart';
import 'package:edufy/core/shared/widgets/drop_down_def.dart';
import 'package:edufy/core/res/validator_def.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExamSubjectDropdown extends StatelessWidget {
  final AddExamController controller;

  const AddExamSubjectDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return _buildLoadingState(context);
      }

      if (controller.subjects.isEmpty) {
        return _buildEmptyState(context);
      }

      return DropdownFormFieldDef<SubjectModel>(
        label: 'المادة',
        paddingTop: 0,
        icon: Icons.menu_book_outlined,
        items: controller.subjects,
        value: controller.selectedSubject.value,
        itemLabel: (item) => '${item.name ?? ''} _ ${item.code ?? ''}',
        validator: (p0) => ValidatorDef.validatorRequired(p0),
        onChanged: (value) => controller.onSubjectChanged(value),
      );
    });
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'جاري تحميل المواد...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade300, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'لا توجد مواد متاحة. يرجى المحاولة مرة أخرى.',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => controller.loadSubjects(),
            child: const Text('إعادة تحميل'),
          ),
        ],
      ),
    );
  }
}
