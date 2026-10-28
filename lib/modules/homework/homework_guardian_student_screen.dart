import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/homework/widgets/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeworkGuardianStudentScreen extends StatelessWidget {
  const HomeworkGuardianStudentScreen({super.key, this.childId});

  final int? childId;

  bool get isGuardian => childId != null;
  bool get isStudent => childId == null;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<HomeController>();
      if (isGuardian) {
        controller.getGuardianChildHomeworks(childId: childId!);
      } else {
        controller.getStudentHomeworks();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isGuardian ? 'واجبات الابن' : 'الواجبات'),
        backgroundColor: context.primary,
      ),
      body: GetBuilder<HomeController>(
        builder: (ctrl) {
          final isLoading = isGuardian
              ? ctrl.isLoadingGuardianHomeworks
              : ctrl.isLoadingHomeworks;

          final homeworks = isGuardian
              ? ctrl.guardianHomeworks
              : ctrl.studentHomeworks;
          if (isLoading && homeworks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (homeworks.isEmpty) {
            return NoDataWidget(
              message: isGuardian
                  ? 'لا توجد واجبات لهذا الابن'
                  : 'لا توجد واجبات',
              icon: Icons.assignment_outlined,
              onRetry: () => isGuardian
                  ? ctrl.getGuardianChildHomeworks(childId: childId!)
                  : ctrl.getStudentHomeworks(),
            );
          }
          final sortedHomeworks = List<HomeworkModel>.from(homeworks)
            ..sort((a, b) {
              if (a.dueDate == null) return 1;
              if (b.dueDate == null) return -1;
              return a.dueDate!.compareTo(b.dueDate!);
            });
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: sortedHomeworks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HomeworkCard(homework: sortedHomeworks[index]),
              );
            },
          );
        },
      ),
    );
  }
}
