// lib/modules/exams/add_exam/widgets/add_exam_body.dart
import 'package:edufy/core/res/validator_def.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_controller.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/add_exam_class_selection.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/add_exam_form_fields.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/add_exam_section_card.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/add_exam_subject_dropdown.dart';
import 'package:edufy/core/shared/widgets/date_picker_field.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/field_lable.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_def.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/save_exam_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class AddExamBody extends StatelessWidget {
  final AddExamController controller;
  final bool isEdit;

  const AddExamBody({
    super.key,
    required this.controller,
    required this.isEdit,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Obx(() {
          return Form(
            key: controller.formKey,
            autovalidateMode: controller.isLoadingData.value
                ? AutovalidateMode.disabled
                : AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                _buildExamContextSection(sizer, context),
                SizedBox(height: sizer.h(16)),
                _buildExamDataSection(sizer, context),
                SizedBox(height: sizer.h(24)),
                SaveExamButton(ctrl: controller, isEdit: isEdit),
                SizedBox(height: sizer.h(12)),
                _buildNotificationText(context),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildExamContextSection(Sizer sizer, BuildContext context) {
    return AddExamSectionCard(
      title: 'سياق الاختبار',
      titleIcon: Icons.info_outline_rounded,
      children: [
        FieldLabel(label: 'المادة', icon: Icons.menu_book_rounded),
        SizedBox(height: sizer.h(6)),
        AddExamSubjectDropdown(controller: controller),
        SizedBox(height: sizer.h(12)),

        FieldLabel(label: 'الصفوف', icon: Icons.school_rounded),
        SizedBox(height: sizer.h(6)),
        AddExamClassSelection(controller: controller),
        SizedBox(height: sizer.h(16)),
        FieldLabel(
          label: 'عنوان الاختبار',
          icon: Icons.drive_file_rename_outline_rounded,
        ),
        TextFormFieldDeF(
          controller: controller.titleController,
          label: 'أدخل عنوان الاختبار',
          validator: (p0) => ValidatorDef.validatorRequired(p0),
          maxLines: 1,
          paddingTop: sizer.h(10),
        ),
      ],
    );
  }

  Widget _buildExamDataSection(Sizer sizer, BuildContext context) {
    return AddExamSectionCard(
      title: 'بيانات الاختبار',
      titleIcon: Icons.assignment_rounded,
      children: [
        FieldLabel(label: 'الموضوع', icon: Icons.topic_rounded),
        TextFormFieldDeF(
          controller: controller.topicController,
          label: 'مثال: كهرباء',
          validator: (p0) => ValidatorDef.validatorRequired(p0),
          maxLines: 1,
          paddingTop: sizer.h(10),
        ),

        SizedBox(height: sizer.h(16)),

        DatePickerField(
          label: 'تاريخ الاختبار',
          selectedDate: controller.selectedDate,
          formattedDate: controller.formattedDate,
          hintText: 'اختر تاريخ الاختبار',
          onTap: () => controller.pickDate(context),
        ),
        SizedBox(height: sizer.h(16)),

        AddExamFormFields(controller: controller, sizer: sizer),
        SizedBox(height: sizer.h(12)),

        FieldLabel(label: 'ملاحظات الاختبار', icon: Icons.notes_rounded),
        TextFormFieldDeF(
          controller: controller.descriptionController,
          label: 'اكتب تفاصيل إضافية...',
          maxLines: 4,
          paddingTop: sizer.h(10),
        ),
      ],
    );
  }

  Widget _buildNotificationText(BuildContext context) {
    return Text(
      isEdit
          ? 'سيتم إخطار الطلاب بتحديث الاختبار تلقائياً'
          : 'سيتم إخطار الطلاب وأولياء الأمور تلقائياً',
      textAlign: TextAlign.center,
      style: context.bodySmall,
    );
  }
}
