// guardian_grades_screen.dart
import 'package:edufy/components/AppSkeletonList.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/models/grade_guardian.dart';
import 'package:edufy/modules/grade/grade_guardian/guardian_grades_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../../../core/shared/extensions/context_extension.dart';

class GuardianGradesScreen extends StatelessWidget {
  const GuardianGradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GuardianGradesController controller = Get.put(
      GuardianGradesController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("درجات ${controller.childName.value}")),
        backgroundColor: context.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: ResponsiveWidget(
        builder: (sizer) {
          return Obx(() {
            // ========== حالة التحميل ==========
            if (controller.isLoading.value) {
              return const AppSkeletonList(itemCount: 8, itemHeight: 160);
            }

            // ========== لا توجد بيانات ==========
            if (controller.subjects.isEmpty) {
              return NoDataWidget(
                message: 'لا توجد درجات لهذا الطالب',
                icon: Icons.person_off_outlined,
                onRetry: controller.retry, // ✅ هذا يعمل لأنها void
                buttonText: 'إعادة المحاولة',
              );
            }

            // ========== عرض البيانات ==========
            return RefreshIndicator(
              onRefresh: controller.refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(sizer.w(20)),
                child: Column(
                  children: [
                    // ===== بطاقة الملخص =====
                    _buildSummaryCard(context, controller),

                    SizedBox(height: sizer.h(25)),

                    // ===== قائمة المواد =====
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = controller.subjects[index];
                        return _buildSubjectCard(context, subject, controller);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ===== بطاقة الملخص =====
  Widget _buildSummaryCard(
    BuildContext context,
    GuardianGradesController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.primary.withOpacity(.2), width: 1),
      ),
      child: Column(
        children: [
          // رسالة الأداء
          Obx(
            () => Text(
              controller.performanceMessage.value,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: controller.performanceColor(
                  controller.performanceMessage.value,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 20),

          // معلومات إضافية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoItem(
                context,
                title: "المعدل",
                value: controller.overallAverage.value.toStringAsFixed(1),
                suffix: "%",
              ),
              _infoItem(
                context,
                title: "عدد الامتحانات",
                value: controller.totalExams.value.toString(),
              ),
              _infoItem(
                context,
                title: "عدد المواد",
                value: controller.subjects.length.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== بطاقة المادة =====
  Widget _buildSubjectCard(
    BuildContext context,
    Subject subject,
    GuardianGradesController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.openSubjectDetails(subject),
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: context.primaryColorMode,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان المادة
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.menu_book,
                    color: context.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    subject.subjectName ?? "غير معروف",
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // نسبة المادة
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: controller
                        .gradeColor(subject.percentage ?? 0)
                        .withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${subject.percentage ?? 0}%",
                    style: context.bodySmall?.copyWith(
                      color: controller.gradeColor(subject.percentage ?? 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            // المعدل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "المعدل",
                  style: context.bodyMedium?.copyWith(color: context.black2),
                ),
                Text(
                  "${subject.averageScore?.toStringAsFixed(1) ?? 0}/${subject.averageMax?.toStringAsFixed(1) ?? 0}",
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 14),

            // شريط التقدم
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: ((subject.percentage ?? 0) / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  controller.gradeColor(subject.percentage ?? 0),
                ),
              ),
            ),

            SizedBox(height: 12),

            // عدد الامتحانات + سهم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 14,
                      color: context.black2,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "عدد الامتحانات: ${subject.examsCount}",
                      style: context.bodySmall?.copyWith(color: context.black2),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: context.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== عنصر معلومات =====
  Widget _infoItem(
    BuildContext context, {
    required String title,
    required String value,
    String suffix = "",
  }) {
    return Column(
      children: [
        Text(
          "$value$suffix",
          style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: context.bodySmall?.copyWith(color: context.black2)),
      ],
    );
  }
}
