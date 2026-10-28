import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/expenses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class BuildFeesCard extends StatelessWidget {
  const BuildFeesCard({super.key, required this.expense});
  final Expenses expense;
  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(16),
          vertical: sizer.h(16),
        ),
        decoration: BoxDecoration(
          color: theme.isDarkMode.value == true
              ? context.primaryColorMode
              : context.white,
          borderRadius: BorderRadius.circular(sizer.radius(18)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('إجمالي المدفوع', style: context.bodySmall),
                Text('إجمالي المستحق', style: context.bodySmall),
              ],
            ),
            SizedBox(height: sizer.h(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: context.primary,
                      size: sizer.w(20),
                    ),
                    SizedBox(width: 6),
                    Text(
                      expense.totalPaid.toString(),
                      style: context.extraLargeBody!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: sizer.w(22),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: context.primary,
                      size: sizer.w(20),
                    ),
                    SizedBox(width: 6),
                    Text(
                      expense.totalDue.toString(),
                      style: context.extraLargeBody!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: sizer.w(22),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: sizer.h(12)),
            Divider(height: sizer.h(1), color: Color(0xFFEEEEEE)),
            SizedBox(height: sizer.h(12)),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'عدد الفواتير: ${expense.invoicesCount}',
                  style: TextStyle(
                    color: context.lightblue,
                    fontSize: sizer.w(11),
                  ),
                ),
                SizedBox(width: sizer.w(4)),

                Icon(
                  Icons.info_outline_rounded,
                  color: context.primary,
                  size: sizer.w(14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'عدد الدفعات: ${expense.paymentsCount}',
                  style: TextStyle(
                    color: context.lightblue,
                    fontSize: sizer.w(11),
                  ),
                ),
                SizedBox(width: sizer.w(4)),
                Icon(
                  Icons.info_outline_rounded,
                  color: context.primary,
                  size: sizer.w(14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
