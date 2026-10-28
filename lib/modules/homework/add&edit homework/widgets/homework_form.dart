import 'package:edufy/core/res/validator_def.dart';
import 'package:edufy/core/shared/widgets/date_picker_field.dart';
import 'package:edufy/core/shared/widgets/drop_down_def.dart';
import 'package:edufy/core/shared/widgets/elevated_button_def.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/models/content%20education/teacher_classes.dart';
import 'package:edufy/models/content%20education/teacher_subject.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_def.dart';
import 'package:edufy/modules/homework/add&edit%20homework/add_homework_controller.dart';
import 'package:edufy/modules/homework/add&edit%20homework/widgets/attachments_section.dart';
import 'package:edufy/modules/homework/add&edit%20homework/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class HomeworkForm extends StatelessWidget {
  final AddHomeworkController controller;
  final GlobalKey<FormState> formKey;
  final bool isDataLoaded;
  final bool isEdit;
  final FocusNode classFocusNode;
  final FocusNode subjectFocusNode;

  const HomeworkForm({
    super.key,
    required this.controller,
    required this.formKey,
    required this.isDataLoaded,
    required this.isEdit,
    required this.classFocusNode,
    required this.subjectFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(20),
          vertical: sizer.h(16),
        ),
        child: Form(
          key: formKey,
          autovalidateMode: isDataLoaded
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(sizer, context),
              SizedBox(height: sizer.h(16)),
              _buildDetailsSection(sizer, context),
              SizedBox(height: sizer.h(16)),
              _buildAttachmentsSection(sizer, context),
              SizedBox(height: sizer.h(24)),
              _buildSubmitButton(sizer, context),
              SizedBox(height: sizer.h(12)),
              _buildFooterText(context),
              SizedBox(height: sizer.h(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Sizer sizer, BuildContext context) {
    return SectionCard(
      title: 'معلومات الواجب',
      icon: Icons.assignment_outlined,
      children: [
        TextFormFieldDeF(
          controller: controller.titleController,
          label: 'عنوان الواجب',
          validator: (p0) => ValidatorDef.validatorRequired(p0),
          maxLines: 1,
          paddingTop: sizer.h(20),
        ),
        SizedBox(height: sizer.h(12)),
        TextFormFieldDeF(
          controller: controller.topicController,
          label: 'الموضوع',
          maxLines: 1,
          paddingTop: sizer.h(20),
        ),
        SizedBox(height: sizer.h(12)),
        TextFormFieldDeF(
          controller: controller.descriptionController,
          label: 'وصف الواجب',
          maxLines: 3,
          paddingTop: sizer.h(20),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(Sizer sizer, BuildContext context) {
    return SectionCard(
      title: 'تفاصيل الواجب',
      icon: Icons.info_outline,
      children: [
        Obx(
          () => DropdownFormFieldDef<ClassModel>(
            focusNode: classFocusNode,
            label: 'الصف',
            paddingTop: sizer.h(20),
            icon: Icons.school_outlined,
            items: controller.classes,
            value: controller.selectedClass.value,
            itemLabel: (item) =>
                ' ${item.gradeLevel ?? 'لايوجد صفوف تدرسها '} _ ${item.stage ?? ''}  _ ش ${item.divisionNumber ?? 0}',
            validator: (p0) => ValidatorDef.validatorRequired(p0),
            onChanged: (value) {
              controller.selectedClass.value = value;
            },
          ),
        ),
        SizedBox(height: sizer.h(12)),
        Obx(
          () => DropdownFormFieldDef<SubjectModel>(
            focusNode: subjectFocusNode,
            label: 'المادة',
            paddingTop: sizer.h(20),
            icon: Icons.menu_book_outlined,
            items: controller.subjects,
            value: controller.selectedSubject.value,
            itemLabel: (item) =>
                ' ${item.name ?? 'لايوجد مواد تدرسها '} _ ${item.code ?? ''}',
            validator: (p0) => ValidatorDef.validatorRequired(p0),
            onChanged: (value) {
              controller.selectedSubject.value = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection(Sizer sizer, BuildContext context) {
    return SectionCard(
      title: 'التسليم والمرفقات',
      icon: Icons.attach_file_outlined,
      children: [
        // DatePickerField(
        //   label: 'تاريخ التسليم',
        //   controller: controller,
        //   onTap: () => controller.pickDueDate(context),
        // ),
        DatePickerField(
          label: 'تاريخ الاختبار',
          selectedDate: controller.selectedDate,
          formattedDate: controller.formattedDate,
          hintText: 'اختر تاريخ الاختبار',
          onTap: () => controller.pickDate(context),  
        ),
        SizedBox(height: sizer.h(16)),
        AttachmentsSection(
          attachments: controller.newAttachments,
          onPickAttachment: controller.pickAttachment,
          onRemoveAttachment: controller.removeNewAttachment,
          existingAttachments: controller.existingAttachments,
          onRemoveExistingAttachment: (index) {
            final attachmentId = controller.existingAttachments[index].id;
            if (attachmentId != null) {
              controller.removeExistingAttachment(attachmentId);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(Sizer sizer, BuildContext context) {
    return ElevatedButtonDef(
      press: () async {
        if (formKey.currentState!.validate()) {
          if (controller.selectedDate.value == null) {
            snackBarDef(
              'تنبيه',
              'يرجى اختيار تاريخ تسليم الواجب',
              isError: true,
            );
            return;
          }

          progressDef(context);
          final result = await controller.submitHomework();
          Get.back();

          if (result != null &&
              (result.status == 200 || result.status == 201)) {
            Get.offAllNamed('/dashboard');
            snackBarDef(
              'تم بنجاح ✓',
              isEdit
                  ? 'تم تحديث الواجب بنجاح'
                  : (result.message ?? 'تم إضافة الواجب بنجاح'),
            );
          } else {
            snackBarDef(
              'خطأ',
              result?.message ?? controller.errorMessage.value,
              isError: true,
            );
          }
        }
      },
      text: isEdit ? 'تحديث الواجب' : 'حفظ الواجب',
    );
  }

  Widget _buildFooterText(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        isEdit
            ? 'سيتم إخطار الطلاب بتحديث الواجب تلقائياً'
            : 'سيتم إخطار الطلاب بالواجب الجديد تلقائياً',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      ),
    );
  }
}
