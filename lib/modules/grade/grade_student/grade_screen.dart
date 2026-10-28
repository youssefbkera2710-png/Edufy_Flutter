import 'package:edufy/components/AppSkeletonList.dart';
import 'package:edufy/modules/grade/grade_student/grade_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../../core/shared/extensions/context_extension.dart';

class GradesScreen extends StatelessWidget {
  GradesScreen({super.key});

  final GradesController controller = Get.put(GradesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الدرجات"),
        backgroundColor: context.primary,
      ),
      body: ResponsiveWidget(
        builder: (sizer) => Obx(() {
          if (controller.isLoading.value) {
            return const AppSkeletonList(itemCount: 8, itemHeight: 160);
          }
          if (controller.subjects.isEmpty) {
            return Column(
              children: [
                Center(child: Text("لا يوجد درجات حالياً")),
                Icon(Icons.menu_book),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(sizer.w(20)),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(sizer.w(18)),
                    decoration: BoxDecoration(
                      color: context.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.gradeData.value?.performanceMessage ?? "",
                          style: context.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: controller.performanceColor(
                              controller.gradeData.value?.performanceMessage ??
                                  "",
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: sizer.h(20)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _infoItem(
                              context,
                              title: "المعدل",
                              value:
                                  "${controller.gradeData.value?.overallPercentage?.toStringAsFixed(1) ?? 0}%",
                            ),
                            _infoItem(
                              context,
                              title: "عدد الامتحانات",
                              value:
                                  "${controller.gradeData.value?.totalExams ?? 0}",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: sizer.h(25)),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = controller.subjects[index];

                      return GestureDetector(
                        onTap: () {
                          controller.openSubjectDetails(subject);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: sizer.h(18)),
                          padding: EdgeInsets.all(sizer.w(18)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: context.primary.withOpacity(0.5),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.menu_book,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: sizer.w(10)),
                                  Expanded(
                                    child: Text(
                                      subject.subjectName ?? "غير معروف",
                                      style: context.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: sizer.h(20)),

                              /// العلامة
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("المعدل", style: context.bodyMedium),
                                  Text(
                                    "${subject.averageScore}/${subject.averageMax}",
                                    style: context.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: sizer.h(14)),

                              /// progress
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: LinearProgressIndicator(
                                  minHeight: sizer.h(10),
                                  value: (subject.percentage ?? 0) / 100,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    controller.gradeColor(
                                      subject.percentage ?? 0,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: sizer.h(12)),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${subject.percentage ?? 0}%",
                                    style: context.bodyMedium?.copyWith(
                                      color: controller.gradeColor(
                                        subject.percentage ?? 0,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "عدد الامتحانات : ${subject.examsCount}",
                                    style: context.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _infoItem(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(title, style: context.bodySmall),
      ],
    );
  }
}
