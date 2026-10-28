import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class BuildExamCardTeacher extends StatelessWidget {
  const BuildExamCardTeacher({super.key, 
    required this.day,
    required this.month,
    required this.classSubject,
    required this.title,
    required this.fullDate,
    required this.maxScore,
    required this.examId,
    required this.source,
  });
  final String day;
  final String month;
  final String classSubject;
  final String title;
  final String fullDate;
  final String maxScore;
  final int examId;
  final String source;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.all(sizer.w(16)),
        decoration: BoxDecoration(
          border: Border.all(color: context.primary),
          borderRadius: BorderRadius.circular(sizer.radius(16)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: sizer.w(60),
                  padding: EdgeInsets.symmetric(vertical: sizer.h(8)),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(sizer.radius(10)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: context.bodySmall?.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        day,
                        style: TextStyle(
                          color: context.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (classSubject.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizer.w(12),
                      vertical: sizer.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: context.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(sizer.radius(20)),
                    ),
                    child: Text(
                      classSubject,
                      style: context.bodySmall?.copyWith(
                        color: context.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: sizer.h(10)),
            Text(
              title,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.end,
            ),
            SizedBox(height: sizer.h(10)),
            Divider(color: Colors.grey.shade200, height: 1),
            SizedBox(height: sizer.h(10)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'الدرجة القصوى: $maxScore',
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: sizer.w(4)),
                    Icon(
                      Icons.star_border_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      fullDate,
                      style: context.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: sizer.w(4)),
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: sizer.h(14)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('تأكيد الحذف؟'),
                          content: const Text(
                            'هل أنت متأكد من حذف الامتحان؟',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final homeController =
                                    Get.find<HomeController>();

                                final success = await homeController
                                    .deleteExamForTeacher(id: examId);

                                if (success) {
                                  Navigator.pop(
                                    context,
                                  ); 
                                }
                              },
                              child: const Text('حذف'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.primary),
                      foregroundColor: context.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sizer.radius(10)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: sizer.h(12)),
                    ),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('حذف'),
                  ),
                ),
                SizedBox(width: sizer.w(10)),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sizer.radius(10)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: sizer.h(12)),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('تعديل'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
