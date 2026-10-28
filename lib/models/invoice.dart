// To parse this JSON data, do
//
//     final invoice = invoiceFromMap(jsonString);

import 'dart:convert';

Invoice invoiceFromMap(String str) => Invoice.fromMap(json.decode(str));

String invoiceToMap(Invoice data) => json.encode(data.toMap());

class Invoice {
    final int? id;
    final String? student;
    final String? expenseType;
    final String? amount;
    final String? paidAmount;
    final DateTime? dueDate;
    final String? status;

    Invoice({
        this.id,
        this.student,
        this.expenseType,
        this.amount,
        this.paidAmount,
        this.dueDate,
        this.status,
    });

    Invoice copyWith({
        int? id,
        String? student,
        String? expenseType,
        String? amount,
        String? paidAmount,
        DateTime? dueDate,
        String? status,
    }) => 
        Invoice(
            id: id ?? this.id,
            student: student ?? this.student,
            expenseType: expenseType ?? this.expenseType,
            amount: amount ?? this.amount,
            paidAmount: paidAmount ?? this.paidAmount,
            dueDate: dueDate ?? this.dueDate,
            status: status ?? this.status,
        );

    factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        student: json["student"],
        expenseType: json["expense_type"],
        amount: json["amount"],
        paidAmount: json["paid_amount"],
        dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "student": student,
        "expense_type": expenseType,
        "amount": amount,
        "paid_amount": paidAmount,
        "due_date": dueDate?.toIso8601String(),
        "status": status,
    };
}
