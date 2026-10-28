import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerWidget extends StatelessWidget {
  final dynamic controller;

  const FilePickerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? context.white : context.grey900;
    final containerBg = isDark ? context.grey900 : context.white;
    final borderColor = isDark ? context.grey750 : context.grey150;
    final hintColor = isDark
        ? context.grey350.withOpacity(0.6)
        : context.grey350;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الملفات المرفقة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picker = ImagePicker();
            final XFile? file = await picker.pickMedia();
            if (file != null) {
              controller.addPickedFile(File(file.path));
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: DottedBorder(
            options: RectDottedBorderOptions(
              color: context.primary.withOpacity(0.4),
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              strokeCap: StrokeCap.butt,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.02),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 38,
                    color: context.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "اضغط هنا لرفع الملفات والوسائط",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "يدعم الصور والملفات التعليمية",
                    style: TextStyle(fontSize: 12, color: hintColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          // فحص آمن لـ oldFilesUrls لتجنب NoSuchMethodError في شاشات الإضافة
          bool hasOldFiles = false;
          List<dynamic> oldFiles = [];

          try {
            if (controller.oldFilesUrls != null) {
              oldFiles = controller.oldFilesUrls;
              hasOldFiles = oldFiles.isNotEmpty;
            }
          } catch (_) {
            hasOldFiles = false;
          }

          final bool hasNewFiles =
              controller.newPickedFiles != null &&
              controller.newPickedFiles.isNotEmpty;

          if (!hasOldFiles && !hasNewFiles) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (hasOldFiles)
                    ...oldFiles.asMap().entries.map<Widget>((entry) {
                      final index = entry.key;
                      final String url = entry.value;
                      return Chip(
                        avatar: const Icon(
                          Icons.cloud_done_rounded,
                          size: 16,
                          color: Colors.green,
                        ),
                        label: Text(
                          url.split('/').last,
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                        backgroundColor: containerBg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: borderColor, width: 1),
                        ),
                        deleteIcon: Icon(
                          Icons.cancel_rounded,
                          size: 18,
                          color: context.grey625,
                        ),
                        onDeleted: () => controller.removeOldFile(index),
                      );
                    }),

                  if (hasNewFiles)
                    ...controller.newPickedFiles.asMap().entries.map<Widget>((
                      entry,
                    ) {
                      final index = entry.key;
                      final File file = entry.value;
                      return Chip(
                        avatar: Icon(
                          Icons.fiber_new_rounded,
                          size: 20,
                          color: context.primary,
                        ),
                        label: Text(
                          file.path.split('/').last,
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                        backgroundColor: containerBg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: borderColor, width: 1),
                        ),
                        deleteIcon: Icon(
                          Icons.cancel_rounded,
                          size: 18,
                          color: context.grey625,
                        ),
                        onDeleted: () => controller.removeNewFile(index),
                      );
                    }),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}
