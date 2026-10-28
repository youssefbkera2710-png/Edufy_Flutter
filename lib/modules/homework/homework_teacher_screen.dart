// lib/modules/home/teacher/teacher_homework_screen.dart
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/home/teacher/widgets/task_card_teacher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  const TeacherHomeworkScreen({super.key});

  @override
  State<TeacherHomeworkScreen> createState() => _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState extends State<TeacherHomeworkScreen> {
  final controller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTeacherHomework(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreHomework();
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
      appBar: AppBar(title: const Text('الواجبات المضافة')),
      body: GetBuilder<HomeController>(
        builder: (ctrl) {
          if (ctrl.isLoadingHomework && ctrl.teacherHomework.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.teacherHomework.isEmpty && !ctrl.isLoadingHomework) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: context.grey350,
                  ),
                  SizedBox(height: 16),
                  Text('لا توجد واجبات', style: context.bodyMedium),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ctrl.fetchTeacherHomework(isRefresh: true),
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

          // عرض القائمة العمودية
          return RefreshIndicator(
            onRefresh: () => ctrl.fetchTeacherHomework(isRefresh: true),
            color: context.primary,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: ctrl.teacherHomework.length + 1,
              itemBuilder: (context, index) {
                if (index == ctrl.teacherHomework.length) {
                  return _buildLoadMoreWidget(ctrl);
                }

                final homework = ctrl.teacherHomework[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCardTeacher(item: homework, isExam: false),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreWidget(HomeController ctrl) {
    if (ctrl.hasMoreHomework) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: ctrl.isFetchingMoreHomeWork
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: ctrl.loadMoreHomework,
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
    } else if (ctrl.teacherHomework.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '~ تم تحميل جميع الوظائف ~',
            style: context.bodySmall?.copyWith(color: context.grey350),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
