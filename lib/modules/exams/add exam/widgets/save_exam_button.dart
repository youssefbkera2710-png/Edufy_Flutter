import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_controller.dart';
import 'package:edufy/modules/home/home_controller.dart'; // ✅ إضافة الاستيراد
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class SaveExamButton extends StatelessWidget {
  final AddExamController ctrl;
  final bool isEdit;

  const SaveExamButton({super.key, required this.ctrl, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Obx(() {
        final isLoading = ctrl.isLoading.value;
        final error = ctrl.errorMessage.value;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: sizer.h(56),
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final response = await ctrl.submitExam();
                        if (response != null && response.success) {
                          if (Get.isRegistered<HomeController>()) {
                            final home = Get.find<HomeController>();
                            await home.fetchTeacherExams(isRefresh: true);
                            await home.fetchTeacherExams(limit: 3);
                          }

                          Get.back(result: true);
                          snackBarDef(
                            'نجاح',
                            isEdit
                                ? 'تم تحديث الاختبار بنجاح'
                                : 'تم إضافة الاختبار بنجاح',
                          );
                        } else if (response != null && !response.success) {
                          snackBarDef(
                            'خطأ',
                            response.message ?? 'حدث خطأ أثناء الحفظ',
                            isError: true,
                          );
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEdit ? 'تحديث الاختبار' : 'حفظ الاختبار',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (error.isNotEmpty) ...[
              SizedBox(height: sizer.h(8)),
              Text(
                error,
                style: context.bodySmall?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      }),
    );
  }
}
