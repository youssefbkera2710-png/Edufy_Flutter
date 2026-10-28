import 'package:edufy/components/wave_header.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_controller.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/add_exam_body.dart';
import 'package:edufy/modules/exams/add%20exam/widgets/add_exam_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExamScreen extends StatefulWidget {
  final int? examId;
  final bool isEdit;

  const AddExamScreen({super.key, this.examId, this.isEdit = false});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  late final AddExamController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddExamController());

    if (widget.isEdit && widget.examId != null) {
      controller.loadExamForEdit(widget.examId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return Scaffold(
          appBar: WaveHeader(
            context,
            widget.isEdit ? 'تعديل الاختبار' : 'إضافة اختبار جديد',
            showButtonTheme: false,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.errorMessage.value.isNotEmpty) {
        return Scaffold(
          appBar: WaveHeader(
            context,
            widget.isEdit ? 'تعديل الاختبار' : 'إضافة اختبار جديد',
            showButtonTheme: false,
          ),
          body: NoDataWidget(
            message: controller.errorMessage.value,
            icon: Icons.error_outline,
            onRetry: () => Get.back(),
            buttonText: 'رجوع',
          ),
        );
      }
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: WaveHeader(
            context,
            widget.isEdit ? 'تعديل الاختبار' : 'إضافة اختبار جديد',
            showButtonTheme: false,
          ),
          body: Stack(
            children: [
              AddExamBody(controller: controller, isEdit: widget.isEdit),
              AddExamLoadingOverlay(isLoading: controller.isLoading.value),
            ],
          ),
        ),
      );
    });
  }
}
