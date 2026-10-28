import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/top_student.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/top_student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class TopStudentCard extends StatelessWidget {
  final TopStudent student;
  const TopStudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    return ResponsiveWidget(
      builder: (sizer) => GestureDetector(
        onTap: () =>
            Get.to(() => TopStudentDetailScreen(studentId: student.id!)),
        child: Container(
          decoration: BoxDecoration(
            color: theme.isDarkMode.value == true
                ? context.black2
                : context.white,
            borderRadius: BorderRadius.circular(sizer.radius(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAvatar(context,sizer),
               SizedBox(height: sizer.h(10)),
              // الاسم
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: sizer.w(8)),
                child: Text(
                  student.studentName ?? '—',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
               SizedBox(height: sizer.h(4)),
              Text(
                'الصف',
                style: context.bodySmall!.copyWith(color: context.grey625),
              ),
              Text(
                student.currentClass ?? '—',
                style: context.bodySmall!.copyWith(
                  color: context.primary
                ),
              ),
               SizedBox(height: sizer.h(8)),
              // شريط الإنجاز
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 14),
              //   child: Column(
              //     children: [
              //       ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: const LinearProgressIndicator(
              //           value: 0.9,
              //           minHeight: 6,
              //           backgroundColor: Color(0xFFE0F2F1),
              //           valueColor: AlwaysStoppedAnimation<Color>(
              //             Color(0xFF00897B),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 4),
              //       Text(
              //         student.achievement ?? '—',
              //         style: const TextStyle(
              //           fontSize: 11,
              //           color: Color(0xFF00897B),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAvatar(BuildContext context,Sizer sizer) {
    final hasImage = student.image != null && student.image!.trim().isNotEmpty;
    return Container(
      width: sizer.w(80),
      height: sizer.h(80),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.primary, width: sizer.w(2.5)),
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                student.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, size: sizer.w(44), color: context.primary),
              )
            : Icon(Icons.person, size: sizer.w(44), color: context.primary),
      ),
    );
  }
}
