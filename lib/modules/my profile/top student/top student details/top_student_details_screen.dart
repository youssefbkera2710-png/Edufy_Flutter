import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/widgets/achievement_card.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/widgets/build_app_bar_details.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/widgets/card_top_details.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/widgets/info_row_details.dart';
import 'package:edufy/modules/my%20profile/top%20student/top_student_controller.dart';
import 'package:edufy/modules/my%20profile/top%20student/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class TopStudentDetailScreen extends StatelessWidget {
  final int studentId;
  const TopStudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TopStudentsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchStudentDetail(studentId);
    });

    return ResponsiveWidget(
      builder: (sizer) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Obx(() {
            if (controller.isLoadingDetail.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.detailError.value.isNotEmpty) {
              return NoDataWidget(
                message: controller.detailError.value,
                icon: Icons.error_outline_rounded,
                onRetry: () => controller.fetchStudentDetail(studentId),
              );
            }

            final student = controller.selectedStudent.value;
            if (student == null) return const SizedBox.shrink();

            return CustomScrollView(
              slivers: [
                BuildAppBarDetails(student: student),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizer.w(20),
                      vertical: sizer.h(20),
                    ),
                    child: Column(
                      children: [
                        CardTopDetails(
                          title: 'المعلومات الأساسية',
                          icon: Icons.info_outline,
                          children: [
                            InfoRowDetails(
                              label: 'الاسم الكامل',
                              value: student.studentName ?? '—',
                            ),
                            InfoRowDetails(
                              label: 'الصف الدراسي',
                              value: student.currentClass ?? '—',
                            ),
                          ],
                        ),
                        SizedBox(height: sizer.h(16)),
                        AchievementCard(student: student),
                        SizedBox(height: sizer.h(30)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
