import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/elevated_button_def.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:responsive_s/responsive_s.dart';

class SubmitAbsencePage extends StatefulWidget {
  const SubmitAbsencePage({super.key, required this.studentId});
  final int studentId;

  @override
  State<SubmitAbsencePage> createState() => _SubmitAbsencePageState();
}

class _SubmitAbsencePageState extends State<SubmitAbsencePage> {
  final formKey = GlobalKey<FormState>();
  String? reason;

  String selectedDate =
      '${DateTime.now().year}-'
      '${DateTime.now().month.toString().padLeft(2, '0')}-'
      '${DateTime.now().day.toString().padLeft(2, '0')}';
  PlatformFile? pickedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'txt'],
    );
    if (result != null) {
      setState(() => pickedFile = result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تقديم طلب عذر')),
    body: Form(
      key: formKey,
      child: ResponsiveWidget(
        builder: (sizer) => ListView(
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(16),
          ),
          children: [
            Container(
              padding:  EdgeInsets.all(sizer.radius(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizer.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'تاريخ الغياب',
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: sizer.h(10)),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate =
                              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: sizer.h(14),
                        vertical: sizer.w(14),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.gray700),
                        borderRadius: BorderRadius.circular(sizer.radius(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.calendar_today_outlined),
                          Text(selectedDate),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: sizer.h(16)),

                  Text(
                    'سبب الغياب',
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: sizer.h(10)),
                  TextFormField(
                    maxLines: 4,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'اكتب سبب الغياب هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(sizer.radius(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(sizer.radius(10)),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'الرجاء إدخال سبب الغياب'
                        : null,
                    onSaved: (v) => reason = v,
                  ),
                  SizedBox(height: sizer.h(16)),

                  // ── المرفق (اختياري) ──
                  Text(
                    'المرفق (اختياري)',
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: sizer.h(10)),
                  InkWell(
                    onTap: pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: sizer.w(14),
                        vertical: sizer.h(14),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.gray700),
                        borderRadius: BorderRadius.circular(sizer.radius(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.attach_file_outlined),
                          Expanded(
                            child: Text(
                              pickedFile != null
                                  ? pickedFile!.name
                                  : 'اختر صورة أو ملف PDF...',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: sizer.w(4)),
                          if (pickedFile != null)
                            GestureDetector(
                              onTap: () => setState(() => pickedFile = null),
                              child: Icon(
                                Icons.close,
                                size: sizer.w(16),
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sizer.h(20)),

            // ── زر الإرسال ──
            GetBuilder<HomeController>(
              builder: (controller) => SizedBox(
                width: double.infinity,
                height: sizer.h(50),
                child: controller.isSubmitting
                    ? Center(child: const CircularProgressIndicator())
                    : ElevatedButtonDef(
                        press: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            controller.submitAbsenceRequest(
                              studentId: widget.studentId.toString(),
                              absenceDate: selectedDate,
                              reason: reason!,
                              attachmentPath: pickedFile?.path,
                            );
                          }
                        },
                        text: 'تقديم الطلب',
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

