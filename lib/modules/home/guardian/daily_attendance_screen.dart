import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class DailyAttendanceScreen extends StatefulWidget {
  DailyAttendanceScreen({super.key});
  final int studentId = Get.arguments['studentId'];
  @override
  State<DailyAttendanceScreen> createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends State<DailyAttendanceScreen> {
  final controller = Get.find<HomeController>();

  String selectedStatus = 'present';
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 120));
  DateTime toDate = DateTime.now();

  final List<Map<String, String>> statusOptions = [
    {'label': 'حاضر', 'value': 'present'},
    {'label': 'غائب', 'value': 'absent'},
    {'label': 'متأخر', 'value': 'late'},
  ];

  String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String formatDisplayDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  void fetchData() {
    controller.fetchDailyAttendance(
      studentId: widget.studentId,
      status: selectedStatus,
      from: formatDate(fromDate),
      to: formatDate(toDate),
    );
  }

  Future<void> pickFromDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2024),
      lastDate: toDate,
    );
    if (d != null) {
      setState(() => fromDate = d);
      fetchData();
    }
  }

  Future<void> pickToDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: fromDate,
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() => toDate = d);
      fetchData();
    }
  }

  Color statusColor(String? status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String statusLabel(String? status) {
    switch (status) {
      case 'present':
        return 'حاضر';
      case 'absent':
        return 'غائب';
      case 'late':
        return 'متأخر';
      default:
        return status ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحضور'),
        backgroundColor: context.primary,
      ),
      body: ResponsiveWidget(
        builder: (sizer) => Column(
          children: [
            Container(
              height: sizer.h(60),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: sizer.w(12),
                  vertical: sizer.h(8),
                ),
                itemCount: statusOptions.length,
                itemBuilder: (context, index) {
                  final opt = statusOptions[index];
                  final isSelected = selectedStatus == opt['value'];

                  return Padding(
                    padding: EdgeInsets.only(left: sizer.w(8)),
                    child: ChoiceChip(
                      backgroundColor: context.grey350,
                      label: Text(opt['label']!),
                      selected: isSelected,
                      selectedColor: context.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? context.white : context.black2,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() => selectedStatus = opt['value']!);
                        fetchData();
                      },
                    ),
                  );
                },
              ),
            ),

            // ── فلتر التاريخ ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(12),
                vertical: sizer.h(12),
              ),
              child: Row(
                children: [
                  buildDateBox('من', fromDate, pickFromDate),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizer.w(8)),
                    child: Text(
                      'إلى',
                      style: context.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  buildDateBox('إلى', toDate, pickToDate),
                ],
              ),
            ),

            // ── القائمة الرئيسية ──
            Expanded(
              child: GetBuilder<HomeController>(
                builder: (ctrl) {
                  if (ctrl.isLoadingAttendance) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = ctrl.attendanceAndAbsence.data ?? [];

                  if (data.isEmpty) {
                    return NoDataWidget(
                      message: 'لا توجد سجلات لهذا التاريخ',
                      icon: Icons.assignment_late,
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.all(sizer.w(12)),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => SizedBox(height: sizer.h(10)),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return buildAttendanceCard(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت صندوق التاريخ لتنظيف الكود
  Widget buildDateBox(String label, DateTime date, VoidCallback onTap) {
    return ResponsiveWidget(
      builder: (sizer) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizer.w(10),
              vertical: sizer.h(10),
            ),
            decoration: BoxDecoration(
              // color: Colors.white,
              border: Border.all(color: context.primary),
              borderRadius: BorderRadius.circular(sizer.radius(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: sizer.w(18),
                  color: context.primary,
                ),
                Text(
                  formatDisplayDate(date),
                  style: context.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت البطاقة لتنظيف كود القائمة
  Widget buildAttendanceCard(dynamic item) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.all(sizer.w(16)),
        decoration: BoxDecoration(
          border: Border.all(color: statusColor(item.status)),

          borderRadius: BorderRadius.circular(sizer.radius(16)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(14),
                vertical: sizer.h(6),
              ),
              decoration: BoxDecoration(
                color: statusColor(item.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(sizer.radius(20)),
                border: Border.all(color: statusColor(item.status)),
              ),
              child: Text(
                statusLabel(item.status),
                style: context.bodyMedium!.copyWith(
                  color: statusColor(item.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.date != null ? formatDisplayDate(item.date!) : '-',
                  style: context.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: sizer.h(4)),
                Text(
                  'حاضر: ${item.presentCount ?? 0}  |  غائب: ${item.absentCount ?? 0}',
                  style: context.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
