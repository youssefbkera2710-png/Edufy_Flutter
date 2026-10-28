// lib/modules/teacher/grades/screens/exam_grades_screen.dart

import 'package:edufy/modules/exams/management%20grade/exam_grades_controller.dart';
import 'package:edufy/modules/exams/management%20grade/widgets/student_grade_tile.dart';
import 'package:edufy/modules/exams/management%20grade/widgets/submit_grades_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class ExamGradesScreen extends StatelessWidget {
  const ExamGradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExamGradesController>(
      init: ExamGradesController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'درجات ${controller.examTitle}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            centerTitle: true,
            actions: [
              // زر إعادة تحميل
              IconButton(
                onPressed: controller.refreshData,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: ResponsiveWidget(
            builder: (sizer) => Column(
              children: [
                // ✅ معلومات رأس الصفحة
                _buildHeader(sizer, context),

                // ✅ حالة التحميل أو الخطأ أو القائمة
                Expanded(child: _buildBody(sizer, context)),

                // ✅ زر الحفظ الثابت في الأسفل
                SafeArea(
                  child: SubmitGradesButton(
                    onPressed: controller.submitGrades,
                    isLoading: controller.isSubmitting.value,
                    count: controller.enteredStudentsCount,
                    total: controller.students.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// رأس الصفحة
  Widget _buildHeader(Sizer sizer, BuildContext context) {
    return GetBuilder<ExamGradesController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(12),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Row(
            children: [
              // معلومات الصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصف: ${controller.className}',
                      style: TextStyle(
                        fontSize: sizer.w(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: sizer.h(4)),
                    Text(
                      'الدرجة القصوى: ${controller.maxScore.value}',
                      style: TextStyle(
                        fontSize: sizer.w(14),
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // إحصائيات
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sizer.w(12),
                  vertical: sizer.h(8),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(sizer.radius(12)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${controller.enteredStudentsCount}',
                      style: TextStyle(
                        fontSize: sizer.w(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/ ${controller.students.length}',
                      style: TextStyle(
                        fontSize: sizer.w(12),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// المحتوى الرئيسي
  Widget _buildBody(Sizer sizer, BuildContext context) {
    return GetBuilder<ExamGradesController>(
      builder: (controller) {
        // حالة التحميل
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // حالة الخطأ
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: sizer.w(64),
                  color: Colors.red.shade300,
                ),
                SizedBox(height: sizer.h(16)),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: sizer.w(16),
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: sizer.h(16)),
                ElevatedButton.icon(
                  onPressed: controller.refreshData,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        // لا يوجد طلاب
        if (controller.students.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: sizer.w(64),
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: sizer.h(16)),
                Text(
                  'لا يوجد طلاب في هذا الصف',
                  style: TextStyle(
                    fontSize: sizer.w(16),
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        // قائمة الطلاب
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: Theme.of(context).primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: sizer.w(16),
              vertical: sizer.h(8),
            ),
            itemCount: controller.students.length,
            itemBuilder: (context, index) {
              final student = controller.students[index];
              final studentId = student.studentId ?? 0;
              final controllerText = controller.scoreControllers[studentId];
              final isModified = controller.modifiedStudentIds.contains(
                studentId,
              );

              return StudentGradeTile(
                student: student,
                controller: controllerText,
                maxScore: controller.maxScore.value,
                isModified: isModified,
                onChanged: (value) {
                  // يتم التحديث تلقائياً من خلال الـ controller
                },
              );
            },
          ),
        );
      },
    );
  }
}
