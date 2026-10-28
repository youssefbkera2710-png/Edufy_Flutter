import 'package:edufy/modules/home/guardian/submit_absence_screen.dart';
import 'package:edufy/modules/home/guardian/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsForExcusesCard extends StatelessWidget {
  const RequestsForExcusesCard({
    super.key,
    required this.studentName,
    required this.studentId,
  });
  final String studentName;
  final int studentId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListItem(
          icon: Icons.calendar_today_outlined,
          label: 'سجل الحضور ',
          onTap: () => Get.toNamed(
            '/DailyAttendanceScreen',
            arguments: {'studentId': studentId},
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        ListItem(
          icon: Icons.add_circle_outline,
          label: 'تقديم طلب عذر غياب',
          onTap: () => Get.to(SubmitAbsencePage(studentId: studentId)),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),

        ListItem(
          icon: Icons.list_alt_outlined,
          label: 'قائمة طلبات الأعذار الخاصة بي',
          onTap: () => Get.toNamed(
            '/AbsenceRequestsPage',
            arguments: {'studentName': studentName},
          ),
        ),
      ],
    );
  }
}
