import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_attendance_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';

class AddAttendanceScreen extends StatelessWidget {
  final int classId;
  final int subjectId;
  final int sessionNumber;
  final String subjectName;
  final String className;
  final String date;

  const AddAttendanceScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.sessionNumber,
    required this.subjectName,
    required this.className,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAttendanceController());
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.studentsList.isEmpty && !controller.isFetching.value) {
        controller.getAttendanceList(
          classId: classId,
          subjectId: subjectId,
          date: date,
          sessionNumber: sessionNumber,
        );
      }
    });

    return Scaffold(
      backgroundColor: isDark ? context.background : colors.grey50,
      appBar: AppBar(
        title: Text(
          'الحضور والغياب',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: isDark ? colors.white : colors.grey900,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: isDark ? colors.white : colors.grey900),
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return Center(child: CircularProgressIndicator(color: colors.primary));
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDark ? colors.blue950.withOpacity(0.4) : colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: colors.primary.withOpacity(isDark ? 0.2 : 0.1),
                  width: 1.0,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: colors.black2.withOpacity(0.02),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          subjectName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: isDark ? colors.cyan : colors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'الحصة $sessionNumber',
                          style: context.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? colors.cyan : colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    className,
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? colors.grey350 : colors.grey625,
                    ),
                  ),
                  const Divider(height: 24.0, thickness: 0.8),

                  InkWell(
                    onTap: () async {
                      DateTime initialDateTime = DateTime.now();
                      if (controller.selectedAttendanceDate.value.isNotEmpty) {
                        try {
                          initialDateTime = DateTime.parse(controller.selectedAttendanceDate.value);
                        } catch (e) {
                          initialDateTime = DateTime.now();
                        }
                      }
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDateTime,
                        firstDate: DateTime(2026),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        String formatted = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        controller.updateSelectedDate(
                            newDate: formatted,
                            classId: classId,
                            subjectId: subjectId,
                            sessionNumber: sessionNumber
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isDark ? context.background.withOpacity(0.2) : colors.lightwhite,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: isDark ? colors.blue800 : colors.grey150,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 16.0, color: colors.primary),
                          const SizedBox(width: 8.0),
                          Text(
                            "تاريخ التحضير: ",
                            style: context.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? colors.white : colors.grey900,
                            ),
                          ),
                          Obx(() => Text(
                            controller.selectedAttendanceDate.value.isEmpty ? date : controller.selectedAttendanceDate.value,
                            style: context.bodySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colors.primary,
                            ),
                          )),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, size: 12.0, color: colors.grey625),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.studentsList.isEmpty
                  ? Center(
                child: Text(
                  'لا يوجد طلاب مسجلين في هذه الشعبة',
                  style: context.bodyMedium?.copyWith(color: isDark ? colors.grey350 : colors.grey750),
                ),
              )
                  : ListView.builder(
                itemCount: controller.studentsList.length,
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 90.0),
                itemBuilder: (context, index) {
                  final student = controller.studentsList[index];
                  final studentId = student.studentId;
                  if (studentId == null) return const SizedBox.shrink();

                  return Obx(() {
                    bool isPresent = controller.studentsAttendanceStatus[studentId] ?? true;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isDark ? colors.blue950.withOpacity(0.2) : colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: isPresent
                              ? colors.success500.withOpacity(isDark ? 0.3 : 0.15)
                              : colors.red500.withOpacity(isDark ? 0.3 : 0.15),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: colors.primary.withOpacity(isDark ? 0.15 : 0.08),
                            child: Icon(Icons.person_rounded, color: colors.primary, size: 20.0),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              student.studentName ?? 'طالب بدون اسم',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? colors.white : colors.grey900,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CustomStatusButton(
                                label: 'حاضر',
                                isSelected: isPresent,
                                selectedColor: colors.success500,
                                unselectedColor: isDark ? colors.blue900 : colors.grey50,
                                onTap: () => controller.toggleAttendance(studentId, true),
                              ),
                              const SizedBox(width: 6.0),
                              _CustomStatusButton(
                                label: 'غائب',
                                isSelected: !isPresent,
                                selectedColor: colors.red500,
                                unselectedColor: isDark ? colors.blue900 : colors.grey50,
                                onTap: () => controller.toggleAttendance(studentId, false),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        );
      }),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDark ? context.background : colors.white,
          boxShadow: [
            BoxShadow(
              color: colors.black2.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10.0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() {
            final isSubmitting = controller.isSubmitting.value;

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSubmitting ? colors.primary.withOpacity(0.6) : colors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52.0),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              ),
              onPressed: isSubmitting
                  ? null
                  : () => controller.submitAttendance(
                classId: classId,
                subjectId: subjectId,
                date: controller.selectedAttendanceDate.value.isEmpty ? date : controller.selectedAttendanceDate.value,
                sessionNumber: sessionNumber,
              ),
              child: isSubmitting
                  ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : Text(
                'حفظ التقرير وإرساله',
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _CustomStatusButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _CustomStatusButton({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(isDark ? 0.25 : 0.12)
              : unselectedColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? selectedColor.withOpacity(0.4) : (isDark ? colors.blue800 : colors.grey150),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            color: isSelected
                ? (isDark ? selectedColor.withOpacity(0.9) : selectedColor)
                : (isDark ? colors.grey350 : colors.grey625),
          ),
        ),
      ),
    );
  }
}