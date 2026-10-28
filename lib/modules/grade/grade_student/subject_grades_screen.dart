import 'package:edufy/models/grade.dart';
import 'package:edufy/modules/grade/grade_student/grade_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../../core/shared/extensions/context_extension.dart';

class SubjectGradesScreen extends StatelessWidget {
  final String subjectName;

  final List<SubjectExam> exams;

  SubjectGradesScreen({
    super.key,
    required this.subjectName,
    required this.exams,
  });

  final GradesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
        backgroundColor: context.primary,
      ),

      body: ResponsiveWidget(
        builder: (sizer) {
          if (exams.isEmpty) {
            return const Center(child: Text("لا يوجد امتحانات"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(sizer.w(20)),

            itemCount: exams.length,

            itemBuilder: (context, index) {
              final exam = exams[index];

              return Container(
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
                    Text(
                      exam.examTitle ?? "",

                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: sizer.h(12)),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,

                          size: 18,

                          color: Colors.grey,
                        ),

                        SizedBox(width: sizer.w(8)),

                        Text(
                          exam.examDate?.substring(0, 10) ?? "",

                          style: context.bodySmall,
                        ),
                      ],
                    ),

                    SizedBox(height: sizer.h(18)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text("العلامة", style: context.bodyMedium),

                        Text(
                          "${exam.score}/${exam.maxScore}",

                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sizer.h(14)),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),

                      child: LinearProgressIndicator(
                        minHeight: sizer.h(10),

                        value: (exam.percentage ?? 0) / 100,

                        backgroundColor: Colors.grey.shade300,

                        valueColor: AlwaysStoppedAnimation<Color>(
                          controller.gradeColor(exam.percentage ?? 0),
                        ),
                      ),
                    ),

                    SizedBox(height: sizer.h(10)),

                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "${exam.percentage ?? 0}%",

                        style: context.bodyMedium?.copyWith(
                          color: controller.gradeColor(exam.percentage ?? 0),

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
