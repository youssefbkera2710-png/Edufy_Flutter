import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/models/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class PaymentsHistoryScreen extends StatelessWidget {
  PaymentsHistoryScreen({super.key});

  final args = Get.arguments as Map<String, dynamic>?;

  late final List<PaymentHistory> paymentHistory = List<PaymentHistory>.from(
    args?['paymentHistory'] ?? [],
  );

  late final int totalPaid = args?['totalPaid'] ?? 0;

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color paymentMethodColor(String method) {
    switch (method) {
      case 'cash':
        return Colors.green;
      case 'bank_transfer':
        return Colors.blue;
      case 'cheque':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String methodLocalizedName(String method) {
    switch (method) {
      case 'cash':
        return 'نقدي';
      case 'bank_transfer':
        return 'تحويل بنكي';
      case 'cheque':
        return 'شيك';
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('سجل المدفوعات'), elevation: 0),
      body: ResponsiveWidget(
        builder: (sizer) {
          if (paymentHistory.isEmpty) {
            return NoDataWidget(
              message: 'لا توجد مدفوعات مسجلة حتى الآن',
              icon: Icons.payment_outlined,
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: sizer.w(16),
              vertical: sizer.h(16),
            ),
            itemCount: paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = paymentHistory[index];
              return Container(
                margin: EdgeInsets.only(bottom: sizer.h(16)),
                decoration: BoxDecoration(
                  color: theme.isDarkMode.value == true
                      ? context.black2
                      : context.white,
                  borderRadius: BorderRadius.circular(sizer.radius(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizer.w(16),
                    vertical: sizer.h(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'فاتورة #${payment.invoiceNumber}',
                            style: context.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.black2,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizer.h(10),
                              vertical: sizer.w(4),
                            ),
                            decoration: BoxDecoration(
                              color: paymentMethodColor(
                                payment.paymentMethod!,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                sizer.radius(20),
                              ),
                              border: Border.all(
                                color: paymentMethodColor(
                                  payment.paymentMethod!,
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  payment.paymentMethod == 'cash'
                                      ? Icons.money
                                      : payment.paymentMethod == 'bank_transfer'
                                      ? Icons.account_balance
                                      : Icons.description,
                                  size: sizer.w(14),
                                  color: paymentMethodColor(
                                    payment.paymentMethod!,
                                  ),
                                ),
                                SizedBox(width: sizer.w(4)),
                                Text(
                                  methodLocalizedName(payment.paymentMethod!),
                                  style: context.bodySmall!.copyWith(
                                    color: paymentMethodColor(
                                      payment.paymentMethod!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizer.h(12)),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: sizer.w(16),
                            color: Colors.grey,
                          ),
                          SizedBox(width: sizer.w(4)),
                          Text(
                            payment.studentName!,
                            style: context.bodySmall!.copyWith(
                              color: context.black2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${payment.amount} ل.س',
                            style: context.bodySmall!.copyWith(
                              color: context.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizer.h(8)),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: sizer.w(14),
                            color: context.grey625,
                          ),
                          SizedBox(width: 4),
                          Text(
                            formatDate(payment.paymentDate!),
                            style: context.bodySmall!.copyWith(
                              color: context.grey625,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
