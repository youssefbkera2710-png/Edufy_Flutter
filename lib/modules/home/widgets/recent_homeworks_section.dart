import 'package:edufy/models/homework_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/homework/widgets/homework_card.dart';

//RecentHomeworksSection لجزء الوظايف الظاهر بالهوم لل gurdian & student
class RecentHomeworksSection extends StatelessWidget {
  const RecentHomeworksSection({super.key, required this.homeworks});
  final List<HomeworkModel> homeworks;

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final recentHomeworks =
        homeworks.where((homework) {
          if (homework.dueDate == null) return false;
          final dueDate = DateTime(
            homework.dueDate!.year,
            homework.dueDate!.month,
            homework.dueDate!.day,
          );
          return dueDate.isAfter(today) || dueDate.isAtSameMomentAs(today);
        }).toList()..sort((a, b) {
          return a.dueDate!.compareTo(b.dueDate!);
        });

    final displayHomeworks = recentHomeworks.take(3).toList();

    return ResponsiveWidget(
      builder: (sizer) => displayHomeworks.isEmpty
          ? Container(
              height: sizer.h(100),
              decoration: BoxDecoration(
                color: theme.isDarkMode.value == true
                    ? context.primaryColorMode
                    : context.white,
                borderRadius: BorderRadius.circular(sizer.radius(24)),
              ),
              child: Center(
                child: Text(
                  'لا يوجد لديك واجبات حديثة ',
                  style: context.bodyMedium?.copyWith(color: context.grey625),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(10),
                vertical: sizer.h(10),
              ),
              decoration: BoxDecoration(
                color: theme.isDarkMode.value == true
                    ? context.primaryColorMode
                    : context.white,
                borderRadius: BorderRadius.circular(sizer.radius(24)),
                boxShadow: [
                  BoxShadow(
                    color: context.black2.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: displayHomeworks
                    .map(
                      (homework) => Padding(
                        padding: EdgeInsets.only(bottom: sizer.h(12)),
                        child: HomeworkCard(homework: homework),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
