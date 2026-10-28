import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/my%20profile/top%20student/top_student_controller.dart';
import 'package:edufy/modules/my%20profile/top%20student/widgets/top_student_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildBodyTopStudent extends StatelessWidget {
  const BuildBodyTopStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TopStudentsController>();
    return Obx(() {
      if (controller.isLoading.value && controller.students.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty &&
          controller.students.isEmpty) {
        return NoDataWidget(
          message: controller.errorMessage.value,
          icon: Icons.error_outline_rounded,
          onRetry: controller.fetchStudents,
        );
      }

      if (controller.students.isEmpty) {
        return NoDataWidget(
          message: 'لايوجد طلاب متميزين حاليا',
          icon: Icons.bookmark_remove,
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchStudents(refresh: true),
        child: GridView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.80,
          ),
          itemCount:
              controller.students.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.students.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return TopStudentCard(student: controller.students[index]);
          },
        ),
      );
    });
  }
}
