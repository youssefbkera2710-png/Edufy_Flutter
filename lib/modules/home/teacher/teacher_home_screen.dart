import 'package:edufy/modules/exams/exam_teacher_screen.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/home/teacher/widgets/home_task_section.dart';
import 'package:edufy/modules/home/teacher/widgets/subject_grid.dart';
import 'package:edufy/modules/home/teacher/widgets/summary_card.dart';
import 'package:edufy/modules/home/teacher/widgets/today_time_table.dart';
import 'package:edufy/modules/home/widgets/build_section_header.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/homework/homework_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => GetBuilder<HomeController>(
        builder: (ctrl) {
          final stats = ctrl.teacherStatistics;

          if (stats == null && ctrl.errorMessage != null) {
            return NoDataWidget(
              message: 'تعذّر تحميل بيانات المعلم',
              onRetry: () => ctrl.fetchAllData(isRefresh: true),
            );
          }
          if (stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── الاحصائيات العامة ──
              BuildSectionHeader(
                title: 'الاحصائيات العامة',
                icon: Icons.stacked_bar_chart,
              ),
              SizedBox(height: sizer.h(10)),
              SummaryCard(summary: stats.summary),

              // ── الجدول اليومي ──
              if (stats.todayTimetable != null &&
                  stats.todayTimetable!.isNotEmpty) ...[
                SizedBox(height: sizer.h(10)),
                BuildSectionHeader(
                  title: 'الجدول اليومي',
                  icon: Icons.calendar_month,
                ),
                SizedBox(height: sizer.h(15)),
                TodayTimeTable(
                  sessions: stats.todayTimetable!.take(6).toList(),
                ),
              ],

              // ── الاختبارات ──
              SizedBox(height: sizer.h(10)),
              BuildSectionHeader(
                title: 'الاختبارات',
                action: 'عرض الكل',
                onTap: () {
                  Get.to(() => const TeacherExamsScreen());
                },
                icon: Icons.list_alt_sharp,
              ),
              SizedBox(height: sizer.h(10)),
              HometaskSection(
                taskType: TaskType.exam,
                items: ctrl.homeTeacherExams.take(5).toList(),
                sizer: sizer,
              ),

              // ── الوظائف ──
              SizedBox(height: sizer.h(10)),
              BuildSectionHeader(
                title: 'الوظائف',
                action: 'عرض الكل',
                onTap: () {
                  Get.to(() => const TeacherHomeworkScreen());
                },
                icon: Icons.list_alt_sharp,
              ),
              SizedBox(height: sizer.h(10)),
              HometaskSection(
                taskType: TaskType.homework,
                items: ctrl.teacherHomework.take(5).toList(),
                sizer: sizer,
              ),
              SizedBox(height: sizer.h(10)),

              // ── المواد المسندة ──
              SizedBox(height: sizer.h(10)),
              if (stats.classSubjectAssignments != null &&
                  stats.classSubjectAssignments!.isNotEmpty) ...[
                BuildSectionHeader(
                  title: 'المواد المسندة',
                  action: 'عرض الكل',
                  onTap: () {
                    Get.snackbar(
                      'قريباً',
                      'سيتم إضافة صفحة المواد المسندة قريباً',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: Icons.list_alt_sharp,
                ),
                SizedBox(height: sizer.h(15)),
                SubjectsGrid(
                  assignments: stats.classSubjectAssignments!.take(6).toList(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
