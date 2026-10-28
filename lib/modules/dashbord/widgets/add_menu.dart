import 'package:edufy/modules/education%20content/create_education_screen.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_screen.dart';
import 'package:edufy/modules/homework/add&edit%20homework/add_homework_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.all(sizer.w(20)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(sizer.w(20)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: sizer.w(40),
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: sizer.h(20)),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber.withOpacity(0.2),
                child: Icon(
                  FluentIcons.quiz_new_20_filled,
                  color: Colors.amber,
                ),
              ),
              title: const Text("إضافة اختبار جديد"),
              onTap: () {
                Navigator.pop(context);
                Get.to(AddExamScreen());
              },
            ),

            const Divider(),
            // خيار الوظائف
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Icon(
                  FluentIcons.clipboard_task_24_filled,
                  color: Colors.blue,
                ),
              ),
              title: const Text("إضافة وظيفة جديدة"),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const AddHomeworkScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Icon(
                  FluentIcons.video_recording_20_filled,
                  color: Colors.red,
                ),
              ),
              title: const Text("إضافة محتوى تعليمي جديد"),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const CreateEducationScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
