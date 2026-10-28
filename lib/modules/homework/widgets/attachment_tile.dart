import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentTile extends StatefulWidget {
  const AttachmentTile({
    super.key,
    required this.url,
    required this.name,
    required this.type,
    required this.size,
    required this.isImage,
    required this.isPdf,
    required this.primary,
    required this.grey,
  });

  final String url, name, type, size;
  final bool isImage, isPdf;
  final Color primary, grey;

  @override
  State<AttachmentTile> createState() => _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile> {
  int status = 0;
  double progress = 0;
  String? savedPath;

  // ── فتح الملف ──────────────────────────────────────────────
  void open() {
    if (widget.url.isEmpty) return;
    if (widget.isImage) {
      showImageDialog();
    } else {
      _launchUrl(widget.url);
    }
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (_) => ResponsiveWidget(
        builder: (sizer) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(16),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(sizer.radius(16)),
                child: InteractiveViewer(
                  child: Image.network(
                    widget.url,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, p) {
                      if (p == null) return child;
                      return Container(
                        width: double.infinity,
                        height: sizer.h(300),
                        color: Colors.black,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: sizer.h(20),
                      color: context.black2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: sizer.w(48),
                          ),
                          SizedBox(height: sizer.h(8)),
                          Text(
                            'تعذّر تحميل الصورة',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.black2,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: sizer.w(6),
                      vertical: sizer.h(6),
                    ),
                    child: Icon(
                      Icons.close,
                      color: context.white,
                      size: sizer.w(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizer.w(14),
                    vertical: sizer.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(sizer.radius(16)),
                      bottomRight: Radius.circular(sizer.radius(16)),
                    ),
                  ),
                  child: Text(
                    widget.name,
                    style: context.bodyMedium!.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'تنبيه',
        'لا يمكن فتح هذا الملف',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: context.white,
      );
    }
  }

  // ── تحميل الملف ────────────────────────────────────────────
  Future<void> _download() async {
    if (status == 1) return; // جاري التحميل بالفعل

    // ── طلب الصلاحية ──
    final granted = await requestPermission();
    if (!granted) {
      Get.snackbar(
        'تنبيه',
        'يجب منح إذن التخزين لتحميل الملفات',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      status = 1;
      progress = 0;
    });

    try {
      final dir = await getSaveDirectory();
      final filePath = '${dir.path}/${widget.name}';

      await Dio().download(
        widget.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => progress = received / total);
          }
        },
      );

      if (mounted) {
        setState(() {
          status = 2;
          savedPath = filePath;
        });
      }

      Get.snackbar(
        'تم التحميل ✓',
        'تم حفظ الملف: ${widget.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      if (mounted) setState(() => status = 3);
      Get.snackbar(
        'خطأ',
        'فشل التحميل، حاول مجدداً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
    }
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ لا يحتاج WRITE_EXTERNAL_STORAGE
      if (await Permission.storage.isGranted) return true;
      final result = await Permission.storage.request();
      if (result.isGranted) return true;
      // Android 13+
      final photos = await Permission.photos.request();
      return photos.isGranted || result.isGranted;
    }
    return true; // iOS لا يحتاج إذن للتحميل في documents
  }

  Future<Directory> getSaveDirectory() async {
    if (Platform.isAndroid) {
      // حفظ في مجلد Downloads
      final dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) return dir;
    }
    // iOS أو fallback
    return await getApplicationDocumentsDirectory();
  }

  // ── بناء أيقونة زر التحميل ─────────────────────────────────
  Widget buildDownloadButton() {
    switch (status) {
      case 1: // جاري التحميل
        return SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            value: progress > 0 ? progress : null,
            strokeWidth: 2.5,
            color: widget.primary,
          ),
        );
      case 2: // اكتمل
        return Icon(Icons.check_circle_rounded, color: Colors.green, size: 22);
      case 3: // خطأ
        return Icon(
          Icons.refresh_rounded,
          color: const Color(0xFFBA1A1A),
          size: 22,
        );
      default: // idle
        return Icon(Icons.download_rounded, color: widget.primary, size: 22);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: widget.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.primary.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // ── أيقونة النوع ──
                InkWell(
                  onTap: open,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: iconBg(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon(), color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),

                // ── اسم الملف والحجم ──
                Expanded(
                  child: InkWell(
                    onTap: open,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.size.isNotEmpty)
                          Text(
                            widget.size,
                            style: TextStyle(fontSize: 11, color: widget.grey),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── زر فتح ──
                IconButton(
                  onPressed: open,
                  icon: Icon(
                    Icons.open_in_new_rounded,
                    color: widget.primary,
                    size: 20,
                  ),
                  tooltip: 'فتح',
                  visualDensity: VisualDensity.compact,
                ),

                // ── زر تحميل ──
                IconButton(
                  onPressed: status == 1 ? null : _download,
                  icon: buildDownloadButton(),
                  tooltip: status == 2 ? 'تم التحميل' : 'تحميل',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            // ── شريط التقدم ──
            if (status == 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress > 0 ? progress : null,
                    backgroundColor: widget.primary.withOpacity(0.15),
                    color: widget.primary,
                    minHeight: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData icon() {
    if (widget.isImage) return Icons.image_outlined;
    if (widget.isPdf) return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  Color iconBg() {
    if (widget.isImage) return Colors.teal;
    if (widget.isPdf) return const Color(0xFFBA1A1A);
    return widget.primary;
  }
}
