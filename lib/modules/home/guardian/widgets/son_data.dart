import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/grade/grade_guardian/guardian_grades_screen.dart';
import 'package:edufy/modules/home/guardian/behaviors_screen.dart';
import 'package:edufy/modules/homework/homework_guardian_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class SonData extends StatelessWidget {
  const SonData({
    super.key,
    required this.studentName,
    required this.studentId,
  });
  final String studentName;
  final int studentId;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 1.3,
      children: [
        GridItem(
          icon: Icons.star_border_rounded,
          label: 'درجات الابن',
          // onTap: () {
          //   Get.toNamed('/gradeScreen', arguments: {'studentId': studentId});
          // },
          onTap: () {
            Get.to(
              () => const GuardianGradesScreen(),
              arguments: {'childId': studentId, 'childName': studentName},
            );
          },
        ),
        GridItem(
          icon: Icons.calendar_today_outlined,
          label: 'سجل الصفوف',
          onTap: () {
            Get.toNamed(
              '/classHistoryScreen',
              arguments: {'studentId': studentId},
            );
          },
        ),
        GridItem(
          icon: Icons.help_outline_rounded,
          label: 'الاختبارات',
          onTap: () => Get.toNamed(
            '/ExamGuardianStudent',
            arguments: {'studentId': studentId},
          ),
        ),
        GridItem(
          icon: Icons.assignment_outlined,
          label: 'الواجبات',
          onTap: () =>
              Get.to(() => HomeworkGuardianStudentScreen(childId: studentId)),
        ),
        GridItem(
          icon: Icons.history_edu_outlined,
          label: 'قائمة الفواتير ',
          onTap: () => Get.toNamed(
            '/InvoicesScreen',
            arguments: {'studentName': studentName},
          ),
        ),
        GridItem(
          icon: Icons.boy_rounded,
          label: 'ملاحظات وسلوكيات ',
          onTap: () => Get.to(() => BehaviorsScreen(studentName: studentName)),
        ),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const GridItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ResponsiveWidget(
        builder: (sizer) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.primary),
            borderRadius: BorderRadius.circular(sizer.radius(16)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: sizer.w(52),
                height: sizer.h(52),
                decoration: BoxDecoration(
                  color: context.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: context.primary, size: sizer.w(26)),
              ),
              SizedBox(height: sizer.h(10)),
              Text(
                label,
                style: context.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
