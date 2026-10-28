import 'dart:io';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentsSection extends StatelessWidget {
  final RxList<File> attachments;
  final VoidCallback onPickAttachment;
  final Function(int) onRemoveAttachment;
  final RxList<HomeworkAttachment> existingAttachments;
  final Function(int) onRemoveExistingAttachment;

  const AttachmentsSection({
    super.key,
    required this.attachments,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.existingAttachments,
    required this.onRemoveExistingAttachment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme, context),
        const SizedBox(height: 10),
        _buildExistingAttachments(theme, isDark, context),
        const SizedBox(height: 12),
        _buildAddFileButton(theme, context),
        const SizedBox(height: 12),
        _buildNewAttachments(theme, isDark, context),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.attachment_outlined,
          color: theme.colorScheme.onBackground,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          'المرفقات',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildExistingAttachments(
    ThemeData theme,
    bool isDark,
    BuildContext context,
  ) {
    return Obx(() {
      if (existingAttachments.isEmpty) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.5)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'المرفقات الحالية:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...existingAttachments.asMap().entries.map((entry) {
              final index = entry.key;
              final attachment = entry.value;
              return ListTile(
                leading: Icon(
                  _getIconForType(attachment.type ?? ''),
                  color: theme.primaryColor,
                ),
                title: Text(
                  attachment.name ?? 'مرفق',
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  attachment.size ?? '',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => onRemoveExistingAttachment(index),
                  color: Colors.red,
                ),
              );
            }),
            const Divider(),
          ],
        ),
      );
    });
  }

  Widget _buildAddFileButton(ThemeData theme, BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPickAttachment,
      icon: Icon(
        Icons.upload_file,
        size: 18,
        color: theme.colorScheme.onBackground,
      ),
      label: const Text('إضافة ملفات جديدة'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildNewAttachments(
    ThemeData theme,
    bool isDark,
    BuildContext context,
  ) {
    return Obx(() {
      if (attachments.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey.shade800.withOpacity(0.3)
                : Colors.white30,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'لا توجد ملفات جديدة مرفقة',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.5)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'الملفات الجديدة:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attachments.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final file = attachments[index];
                return ListTile(
                  leading: Icon(
                    Icons.insert_drive_file,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    file.path.split('/').last,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => onRemoveAttachment(index),
                    color: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  IconData _getIconForType(String type) {
    if (type.startsWith('image/')) return Icons.image;
    if (type == 'application/pdf') return Icons.picture_as_pdf;
    if (type.startsWith('video/')) return Icons.video_file;
    return Icons.insert_drive_file;
  }
}
