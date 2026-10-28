import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/student/widgets/academic_performance.dart';
import 'package:edufy/modules/home/teacher/teacher_home_screen.dart';
import 'package:edufy/modules/home/widgets/build_fees_card.dart';
import 'package:edufy/modules/home/widgets/build_header.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/home/widgets/build_section_header.dart';
import 'package:edufy/modules/home/student/widgets/build_state_card.dart';
import 'package:edufy/modules/home/guardian/widgets/build_child_card.dart';
import 'package:edufy/modules/home/widgets/home_loading_skeleton.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/home/widgets/recent_exams_section.dart';
import 'package:edufy/modules/home/widgets/recent_homeworks_section.dart';
import 'package:edufy/modules/homework/homework_guardian_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const HomeLoadingSkeleton();
          }
          if (controller.errorMessage != null && !controller.isRefreshing) {
            if (!controller.errorMessage!.contains('لا توجد بيانات')) {
              return NoDataWidget(
                message: controller.errorMessage!,
                onRetry: () => controller.fetchAllData(),
              );
            }
          }
          if (UserInfo.role == 'teacher') {
            if (controller.teacherStatistics == null) {
              return NoDataWidget(
                message: 'لا توجد بيانات للمعلم',
                icon: Icons.person_off_outlined,
                onRetry: () => controller.fetchAllData(),
              );
            }
          }

          return RefreshIndicator(
            onRefresh: () async =>
                await controller.fetchAllData(isRefresh: true),
            color: context.primary,
            child: ResponsiveWidget(
              builder: (sizer) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: sizer.h(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildHeader(user: controller.user),
                    SizedBox(height: sizer.h(16)),

                    if (UserInfo.role == 'guardian') ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
                        child: Column(
                          children: [
                            BuildSectionHeader(
                              title: 'اولادي ',
                              icon: Icons.child_care_rounded,
                            ),
                            Transform.translate(
                              offset: Offset(0, -20),
                              child: ListView.separated(
                                itemCount: controller.children.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: sizer.h(12)),
                                itemBuilder: (context, index) {
                                  return BuildStudentCard(
                                    child: controller.children[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sizer.h(20)),

                      BuildSectionHeader(
                        title: 'المصاريف',
                        action: 'التقرير الكامل',
                        onTap: () => Get.toNamed(
                          '/paymentsHistoryScreen',
                          arguments: {
                            'paymentHistory': controller.payments,
                            'totalPaid': controller.expenses.totalPaid ?? 0,
                          },
                        ),
                        icon: Icons.bar_chart_rounded,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BuildFeesCard(expense: controller.expenses),
                      ),
                      SizedBox(height: sizer.h(20)),
                    ],

                    if (UserInfo.role == 'student') ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: BuildStatCard(
                                icon: Icons.calendar_today_rounded,
                                iconColor: context.green,
                                label: 'نسبة الحضور',
                                onTap: () => Get.toNamed(
                                  '/DailyAttendanceScreen',
                                  arguments: {
                                    'studentId': controller.user.id ?? 0,
                                  },
                                ),
                                value:
                                    '${controller.attendanceStatistics.attendancePercentage.toString()} %',
                                badge:
                                    controller
                                        .attendanceStatistics
                                        .performanceMessage ??
                                    '',
                                badgeColor: context.green,
                              ),
                            ),
                            SizedBox(width: sizer.w(12)),

                            Expanded(
                              child: BuildStatCard(
                                icon: Icons.trending_up_rounded,
                                iconColor: context.orange,
                                label: 'المعدل التراكمي',
                                value: controller.grade.overallAverage
                                    .toString(),
                                badge:
                                    controller.grade.performanceMessage ?? '',
                                badgeColor: context.orange,
                                onTap: () {
                                  Get.toNamed('/gradeScreen');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      BuildSectionHeader(
                        title: 'الأداء الأكاديمي',
                        action: 'التقرير الكامل',
                        icon: Icons.bar_chart_rounded,
                        onTap: () {
                          Get.toNamed('/gradeScreen');
                        },
                      ),
                      SizedBox(height: sizer.h(10)),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: buildAcademicPerformance(
                          context,
                          grade: controller.grade,
                        ),
                      ),
                      SizedBox(height: sizer.h(20)),

                      BuildSectionHeader(
                        title: 'سجل الاختبارت ',
                        action: 'عرض الكل',
                        onTap: () => Get.toNamed('/ExamGuardianStudent'),
                        icon: Icons.assignment_turned_in_outlined,
                      ),
                      SizedBox(height: sizer.h(10)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
                        child: RecentExamsSection(
                          exams: controller.studentExams,
                        ),
                      ),
                      SizedBox(height: sizer.h(20)),
                      BuildSectionHeader(
                        title: 'سجل الواجبات',
                        action: 'عرض الكل',
                        onTap: () =>
                            Get.to(() => const HomeworkGuardianStudentScreen()),
                        icon: Icons.assignment_outlined,
                      ),
                      SizedBox(height: sizer.h(10)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
                        child: RecentHomeworksSection(
                          homeworks: controller.studentHomeworks,
                        ),
                      ),
                      SizedBox(height: sizer.h(20)),
                    ],

                    if (UserInfo.role == 'teacher') ...[
                      const TeacherHomeScreen(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
