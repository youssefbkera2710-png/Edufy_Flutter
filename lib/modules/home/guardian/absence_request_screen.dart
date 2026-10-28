import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/models/absence.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:url_launcher/url_launcher.dart';

String localizedStatus(String status) {
  if (status == 'approved') return 'مقبول';
  if (status == 'rejected') return 'مرفوض';
  if (status == 'pending') return 'قيد الانتظار';
  return status;
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final String status;

  Color get color {
    if (status == 'مقبول' || status == 'approved') return Colors.green;
    if (status == 'مرفوض' || status == 'rejected') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) => ResponsiveWidget(
    builder: (sizer) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizer.w(12),
        vertical: sizer.h(6),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(sizer.radius(30)),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        localizedStatus(status),
        style: context.bodyMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class AbsenceRequestsPage extends StatefulWidget {
  AbsenceRequestsPage({super.key});

  @override
  State<AbsenceRequestsPage> createState() => _AbsenceRequestsPageState();
}

class _AbsenceRequestsPageState extends State<AbsenceRequestsPage> {
  final String studentName = Get.arguments['studentName'] ?? '';
  final int? absenceRequestId = Get.arguments['absenceRequestId'];
  final bool openDetailsDialog = Get.arguments['openDetailsDialog'] ?? false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().fetchAbsenceByStudentName(
        studentName: studentName,
      );
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (openDetailsDialog && absenceRequestId != null) {
        _showDetailsDialogFromNotification(absenceRequestId!);
      }
    });
  }

  String formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  Future<void> openAttachment(String? url) async {
    if (url == null || url.isEmpty) {
      snackBarDef('تنبيه', 'لا يوجد ملف مرفق لهذا الطلب');
      return;
    }
    try {
      final Uri uri = Uri.parse(url.trim());
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر فتح الرابط',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void _showDetailsDialogFromNotification(int requestId) {
    final ctrl = Get.find<HomeController>();

    final absence = ctrl.absences.firstWhere(
      (item) => item.id == requestId,
      orElse: () => Absence(),
    );

    // إذا تم العثور على العذر، نفتح الـ Dialog
    if (absence.id != null && absence.id! > 0) {
      showDetailsDialog(context, absence);
    } else {
      // إذا لم يتم العثور عليه، ننتظر قليلاً ثم نحاول مرة أخرى
      // قد يكون البيانات لم تكتمل تحميلها بعد
      Future.delayed(const Duration(milliseconds: 500), () {
        final ctrl2 = Get.find<HomeController>();
        final absence2 = ctrl2.absences.firstWhere(
          (item) => item.id == requestId,
          orElse: () => Absence(),
        );
        if (absence2.id != null && absence2.id! > 0) {
          showDetailsDialog(context, absence2);
        } else {
          // إذا لم يتم العثور عليه نهائياً، نعرض رسالة خطأ
          snackBarDef('تنبيه', 'لم يتم العثور على طلب العذر المطلوب');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات الاعذار'),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<HomeController>(
        builder: (ctrl) {
          if (ctrl.isLoadingAbsences) {
            return const Center(child: CircularProgressIndicator());
          }
          final absence = ctrl.absences;

          if (absence.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات عذر',
                    style: context.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ResponsiveWidget(
            builder: (sizer) => ListView.builder(
              itemCount: absence.length,
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(16),
                vertical: sizer.h(16),
              ),
              itemBuilder: (context, index) {
                final item = absence[index];
                return Container(
                  margin: EdgeInsets.only(bottom: sizer.h(14)),
                  decoration: BoxDecoration(
                    color: context.white,
                    borderRadius: BorderRadius.circular(sizer.radius(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(sizer.radius(20)),
                      onTap: () => showDetailsDialog(context, item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sizer.w(16),
                          vertical: sizer.h(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'طلب عذر',
                                        style: context.bodySmall?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.reason!,
                                        style: context.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: context.black2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                StatusBadge(status: item.status!),
                              ],
                            ),
                            SizedBox(height: sizer.h(12)),
                            Divider(color: Colors.grey.shade200, height: 1),
                            SizedBox(height: sizer.h(8)),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: sizer.w(14),
                                  color: context.grey625,
                                ),
                                SizedBox(width: sizer.w(6)),
                                Text(
                                  formatDate(item.absenceDate!),
                                  style: context.bodySmall?.copyWith(
                                    color: context.grey750,
                                  ),
                                ),
                                const Spacer(),
                                if (item.attachment != null &&
                                    item.attachment!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(left: sizer.w(8)),
                                    child: Icon(
                                      Icons.attach_file,
                                      size: sizer.w(16),
                                      color: Colors.blue.shade300,
                                    ),
                                  ),
                                Icon(
                                  Icons.chevron_right,
                                  size: sizer.w(18),
                                  color: context.grey350,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void showDetailsDialog(BuildContext context, Absence absence) {
    showDialog(
      context: context,
      builder: (context) => ResponsiveWidget(
        builder: (sizer) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizer.radius(24)),
          ),
          title: const Text('تفاصيل العذر'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              detailRow('السبب', absence.reason!),
              SizedBox(height: sizer.h(12)),
              detailRow('التاريخ', formatDate(absence.absenceDate!)),
              SizedBox(height: sizer.h(12)),
              detailRow('الحالة', localizedStatus(absence.status!)),
              if (absence.attachment != null &&
                  absence.attachment!.isNotEmpty) ...[
                SizedBox(height: sizer.h(12)),
                ResponsiveWidget(
                  builder: (sizer) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: sizer.w(80),
                        child: const Text(
                          'المرفق',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: sizer.w(8)),
                      Expanded(
                        child: InkWell(
                          onTap: () => openAttachment(absence.attachment!),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.file_present,
                                size: 20,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'عرض المرفق',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('إغلاق')),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return ResponsiveWidget(
      builder: (sizer) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: sizer.w(80),
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          SizedBox(width: sizer.w(8)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
