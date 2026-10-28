// lib/modules/exams/add_exam/widgets/add_exam_form_fields.dart
import 'package:edufy/modules/exams/add%20exam/add_exam_controller.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/field_lable.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_def.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class AddExamFormFields extends StatelessWidget {
  final AddExamController controller;
  final Sizer sizer;

  const AddExamFormFields({
    super.key,
    required this.controller,
    required this.sizer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(label: 'الدرجة النهائية', icon: Icons.grade_rounded),
              TextFormFieldDeF(
                controller: controller.maxScoreController,
                label: '100',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'الرجاء تعبئة الحقل المطلوب';
                  }
                  if (int.tryParse(v.trim()) == null) {
                    return 'رقم en فقط';
                  }
                  return null;
                },
                maxLines: 1,
                paddingTop: sizer.h(10),
              ),
            ],
          ),
        ),
        SizedBox(width: sizer.w(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(label: 'الوقت (دقيقة)', icon: Icons.timer_rounded),
              TextFormFieldDeF(
                controller: controller.durationController,
                label: 'مثلاً: 45',
                validator: (v) {
                  if (v != null &&
                      v.trim().isNotEmpty &&
                      int.tryParse(v.trim()) == null) {
                    return 'رقم فقط';
                  }
                  return null;
                },
                maxLines: 1,
                paddingTop: sizer.h(10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
