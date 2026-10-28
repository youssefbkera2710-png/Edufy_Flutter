import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class InvoicesScreen extends StatelessWidget {
  InvoicesScreen({super.key});
  final String studentName = Get.arguments['studentName'];
  String formatDate(DateTime? date) =>
      '${date!.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().fetchInvoicesByStudentName(
        studentName: studentName,
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الفواتير')),
      body: GetBuilder<HomeController>(
        builder: (ctrl) {
          if (ctrl.isLoadingInvoices) {
            return const Center(child: CircularProgressIndicator());
          }
          if (ctrl.invoices.isEmpty) {
            return ResponsiveWidget(
              builder: (sizer) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: sizer.w(75),
                      color: context.grey350,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد فواتير',
                      style: context.bodyMedium?.copyWith(
                        color: context.grey625,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ResponsiveWidget(
            builder: (sizer) => ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(12),
                vertical: sizer.h(12),
              ),
              itemCount: ctrl.invoices.length,
              itemBuilder: (context, index) {
                final inv = ctrl.invoices[index];
                final amount = double.tryParse(inv.amount ?? '0') ?? 0;
                final paid = double.tryParse(inv.paidAmount ?? '0') ?? 0;
                final remaining = amount - paid;

                return Card(
                  margin: EdgeInsets.only(bottom: sizer.h(12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizer.w(12),
                      vertical: sizer.h(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                inv.expenseType!,
                                style: context.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizer.w(8),
                                vertical: sizer.w(4),
                              ),
                              decoration: BoxDecoration(
                                color: inv.status == 'paid'
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(
                                  sizer.radius(12),
                                ),
                              ),
                              child: Text(
                                inv.status == 'paid' ? 'مدفوع' : 'جزئي',
                                style: context.bodyMedium!.copyWith(
                                  color: context.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sizer.h(12)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'المبلغ: ${amount.toStringAsFixed(2)} ل.س',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'مدفوع: ${paid.toStringAsFixed(2)} ل.س',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sizer.h(8)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'المتبقي: ${remaining.toStringAsFixed(2)} ل.س',
                                style: TextStyle(
                                  color: remaining > 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'تاريخ الاستحقاق: ${formatDate(inv.dueDate)}',
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
