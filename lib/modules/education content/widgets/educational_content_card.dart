import 'package:edufy/core/classes/subjects_helper.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/models/content%20education/education.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/user_info.dart';
import '../edit_educational_content_screen.dart';
import '../education_content_controller.dart';

class EducationalContentCard extends StatelessWidget {
  const EducationalContentCard({super.key, required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;
    final accent = SubjectHelper.getSubjectColor(
      context,
      education.subjectName,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => Get.toNamed(
          '/EducationalDetailsScreen',
          arguments: {'id': education.id},
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? context.background.withOpacity(0.15) : colors.white,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: accent.withOpacity(isDark ? 0.3 : 0.16),
              width: 1.0,
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: colors.black2.withOpacity(0.045),
                  blurRadius: 18.0,
                  offset: const Offset(0.0, 8.0),
                ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 65.0,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SubjectHelper.getSubjectIcon(education.subjectName),
                        color: Colors.white,
                        size: 26,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 30.0,
                        height: 1.0,
                        color: Colors.white.withOpacity(0.35),
                      ),
                      const SizedBox(height: 10),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          education.subjectName ?? '',
                          maxLines: 1,
                          style: context.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w900,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                education.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? colors.white : colors.grey900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (education.allowComments == true)
                              Container(
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 18,
                                  color: colors.primary,
                                ),
                              ),
                            if (UserInfo.role == 'teacher') ...[
                              const SizedBox(width: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      final controller =
                                          Get.find<
                                            EducationalContentController
                                          >();
                                      controller.prepareEdit(education);
                                      Get.to(
                                        () => EditContentScreen(
                                          education: education,
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      final controller =
                                          Get.find<
                                            EducationalContentController
                                          >();
                                      Get.defaultDialog(
                                        title: "تنبيه",
                                        titleStyle: TextStyle(
                                          color: colors.primary,
                                        ),
                                        middleText:
                                            "هل أنتِ متأكدة من حذف هذا المحتوى؟",
                                        middleTextStyle: TextStyle(
                                          color: colors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textConfirm: "حذف",
                                        confirmTextColor: Colors.white,
                                        buttonColor: colors.primary,
                                        textCancel: "إلغاء",
                                        cancelTextColor: colors.primary,
                                        onConfirm: () {
                                          controller.deleteContent(
                                            education.id!,
                                          );
                                          Get.back();
                                        },
                                        onCancel: () => Get.back(),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: colors.red50.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: colors.red500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          education.body ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodySmall?.copyWith(
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                            color: isDark ? colors.grey150 : colors.grey625,
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            if (education.teacherName != null)
                              _InfoChip(
                                icon: Icons.person_outline_rounded,
                                text: education.teacherName!,
                                accent: accent,
                              ),
                            if (education.topic != null)
                              _InfoChip(
                                icon: Icons.tag_rounded,
                                text: education.topic!,
                                accent: accent,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accent;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: accent.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: accent.withOpacity(isDark ? 0.25 : 0.12),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.0, color: accent),
          const SizedBox(width: 6.0),
          Text(
            text,
            style: context.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isDark ? colors.white : colors.grey900,
            ),
          ),
        ],
      ),
    );
  }
}
