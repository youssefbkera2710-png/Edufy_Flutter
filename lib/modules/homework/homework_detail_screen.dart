import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/components/wave_header.dart';
import 'package:edufy/modules/exams/widgets/action_button.dart';
import 'package:edufy/core/shared/widgets/chip.dart';
import 'package:edufy/modules/exams/widgets/description_card.dart';
import 'package:edufy/modules/home/widgets/build_section_header.dart';
import 'package:edufy/modules/homework/add&edit%20homework/add_homework_screen.dart';
import 'package:edufy/modules/homework/widgets/attachment_tile.dart';
import 'package:edufy/modules/homework/widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_s/responsive_s.dart';

class HomeworkDetailScreen extends StatelessWidget {
  const HomeworkDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final HomeworkModel homework = args['homework'];
    final int daysDiff = _getDaysDifference(homework.dueDate);
    final String statusLabel = _getStatusLabel(daysDiff);
    final Color statusColor = _getStatusColor(daysDiff);

    String dueDateString = _formatDate(homework.dueDate);
    return Scaffold(
      appBar: WaveHeader(context, 'تفاصيل الواجب', showButtonTheme: false),
      body: ResponsiveWidget(
        builder: (sizer) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: sizer.w(8),
                runSpacing: sizer.h(8),
                children: [
                  if (homework.subjectName != null)
                    ChipSubject(
                      label: homework.subjectName!,
                      icon: Icons.book_outlined,
                      fontSize: 14,
                    ),
                  if (homework.topic != null)
                    ChipSubject(label: homework.topic!, fontSize: 14),
                  ChipSubject(
                    label: statusLabel,
                    icon: daysDiff < 0
                        ? Icons.warning_rounded
                        : daysDiff == 0
                        ? Icons.today_rounded
                        : Icons.event_available_rounded,
                    fontSize: 14,
                    color: statusColor,
                  ),
                ],
              ),
              SizedBox(height: sizer.h(12)),
              Text(
                homework.title ?? 'بدون عنوان',
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: sizer.h(16)),
              InfoRow(
                icon: Icons.calendar_today_rounded,
                iconColor: statusColor,
                label: 'تاريخ التسليم  ',
                value: dueDateString,
                valueColor: statusColor,
              ),
              SizedBox(height: sizer.h(12)),

              InfoRow(
                icon: Icons.person_outline_rounded,
                iconColor: context.primary,
                label: 'المعلم ',
                value: homework.teacherName ?? '-',
              ),
              SizedBox(height: sizer.h(12)),

              InfoRow(
                icon: Icons.groups_outlined,
                iconColor: context.primary,
                label: 'الصف ',
                value: homework.className ?? '-',
              ),

              if (homework.description != null &&
                  homework.description!.trim().isNotEmpty) ...[
                SizedBox(height: sizer.h(10)),
                Divider(color: context.grey350),
                SizedBox(height: sizer.h(4)),
                BuildSectionHeader(
                  title: 'الوصف ',
                  icon: Icons.description_outlined,
                  isHomework: true,
                ),
                SizedBox(height: sizer.h(10)),
                DescriptionCard(description: homework.description ?? ''),
              ],

              if (homework.attachments != null &&
                  homework.attachments!.isNotEmpty) ...[
                SizedBox(height: sizer.h(10)),
                Divider(color: context.grey350),
                SizedBox(height: sizer.h(6)),
                BuildSectionHeader(
                  title: 'المرفقات ( ${homework.attachments!.length} )',
                  icon: Icons.attach_file_rounded,
                  isHomework: true,
                ),
                SizedBox(height: sizer.h(6)),
                ...homework.attachments!.map((attachment) {
                  final url = attachment.url?.toString() ?? '';
                  final name = attachment.name?.toString() ?? 'مرفق';
                  final type = attachment.type?.toString() ?? '';
                  final size = attachment.size?.toString() ?? '';
                  final isImage = type.startsWith('image/');
                  final isPdf =
                      type == 'application/pdf' ||
                      type.endsWith('pdf') ||
                      url.toLowerCase().endsWith('.pdf');

                  return AttachmentTile(
                    url: url,
                    name: name,
                    type: type,
                    size: size,
                    isImage: isImage,
                    isPdf: isPdf,
                    primary: context.primary,
                    grey: context.grey750,
                  );
                }).toList(),
              ],
              Divider(color: context.grey350),
              SizedBox(height: sizer.h(14)),

              ActionButtons(
                id: homework.id ?? 0,
                title: 'الواجب',
                isHomework: true,
                onEditPressed: () {
                  Get.to(
                    () => AddHomeworkScreen(
                      homeworkId: homework.id,
                      isEdit: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getDaysDifference(DateTime? date) {
    if (date == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final diff = targetDate.difference(today);
    return diff.inDays;
  }

  String _getStatusLabel(int daysDiff) {
    if (daysDiff < 0) {
      return 'منتهي';
    } else if (daysDiff == 0) {
      return 'اليوم';
    } else {
      return 'قادم';
    }
  }

  Color _getStatusColor(int daysDiff) {
    if (daysDiff < 0) {
      return const Color(0xFFE53935);
    } else if (daysDiff == 0) {
      return const Color(0xFFE65100);
    } else {
      return const Color(0xFF2E7D32);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    try {
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return '-';
    }
  }
}
