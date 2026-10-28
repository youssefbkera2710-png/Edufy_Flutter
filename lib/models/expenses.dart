// To parse this JSON data, do
//
//     final expenses = expensesFromMap(jsonString);

import 'dart:convert';

Expenses expensesFromMap(String str) => Expenses.fromMap(json.decode(str));

String expensesToMap(Expenses data) => json.encode(data.toMap());

class Expenses {
    final int? totalDue;
    final int? totalPaid;
    final int? invoicesCount;
    final int? paymentsCount;

    Expenses({
        this.totalDue,
        this.totalPaid,
        this.invoicesCount,
        this.paymentsCount,
    });

    Expenses copyWith({
        int? totalDue,
        int? totalPaid,
        int? invoicesCount,
        int? paymentsCount,
    }) => 
        Expenses(
            totalDue: totalDue ?? this.totalDue,
            totalPaid: totalPaid ?? this.totalPaid,
            invoicesCount: invoicesCount ?? this.invoicesCount,
            paymentsCount: paymentsCount ?? this.paymentsCount,
        );

    factory Expenses.fromMap(Map<String, dynamic> json) => Expenses(
        totalDue: json["total_due"],
        totalPaid: json["total_paid"],
        invoicesCount: json["invoices_count"],
        paymentsCount: json["payments_count"],
    );

    Map<String, dynamic> toMap() => {
        "total_due": totalDue,
        "total_paid": totalPaid,
        "invoices_count": invoicesCount,
        "payments_count": paymentsCount,
    };
}
