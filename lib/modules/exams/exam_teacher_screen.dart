import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/home/teacher/widgets/task_card_teacher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherExamsScreen extends StatefulWidget {
  const TeacherExamsScreen({super.key});

  @override
  State<TeacherExamsScreen> createState() => _TeacherExamsScreenState();
}

class _TeacherExamsScreenState extends State<TeacherExamsScreen> {
  final controller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTeacherExams(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreExams();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الاختبارات')),

      body: GetBuilder<HomeController>(
        builder: (ctrl) {
          if (ctrl.isLoadingExams && ctrl.teacherExams.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.teacherExams.isEmpty && !ctrl.isLoadingExams) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: context.grey350,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد اختبارات',
                    style: context.bodyMedium?.copyWith(color: context.grey625),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ctrl.fetchTeacherExams(isRefresh: true),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('تحديث'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ctrl.fetchTeacherExams(isRefresh: true),
            color: context.primary,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: ctrl.teacherExams.length + 1,
              itemBuilder: (context, index) {
                if (index == ctrl.teacherExams.length) {
                  return _buildLoadMoreWidget(ctrl);
                }

                final exam = ctrl.teacherExams[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCardTeacher(item: exam, isExam: true),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreWidget(HomeController ctrl) {
    if (ctrl.hasMoreExams) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: ctrl.isFetchingMoreExams
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: ctrl.loadMoreExams,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('تحميل المزيد'),
                ),
        ),
      );
    } else if (ctrl.teacherExams.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '~ تم تحميل جميع الاختبارات ~',
            style: context.bodySmall?.copyWith(color: context.grey350),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
