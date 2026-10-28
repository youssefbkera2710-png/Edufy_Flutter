// To parse this JSON data, do
//
//     final paymentHistory = paymentHistoryFromMap(jsonString);

import 'dart:convert';

PaymentHistory paymentHistoryFromMap(String str) => PaymentHistory.fromMap(json.decode(str));

String paymentHistoryToMap(PaymentHistory data) => json.encode(data.toMap());

class PaymentHistory {
    final int? id;
    final String? amount;
    final DateTime? paymentDate;
    final String? paymentMethod;
    final int? invoiceNumber;
    final String? studentName;

    PaymentHistory({
        this.id,
        this.amount,
        this.paymentDate,
        this.paymentMethod,
        this.invoiceNumber,
        this.studentName,
    });

    PaymentHistory copyWith({
        int? id,
        String? amount,
        DateTime? paymentDate,
        String? paymentMethod,
        int? invoiceNumber,
        String? studentName,
    }) => 
        PaymentHistory(
            id: id ?? this.id,
            amount: amount ?? this.amount,
            paymentDate: paymentDate ?? this.paymentDate,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            invoiceNumber: invoiceNumber ?? this.invoiceNumber,
            studentName: studentName ?? this.studentName,
        );

    factory PaymentHistory.fromMap(Map<String, dynamic> json) => PaymentHistory(
        id: json["id"],
        amount: json["amount"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        paymentMethod: json["payment_method"],
        invoiceNumber: json["invoice_number"],
        studentName: json["student_name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
        "payment_date": paymentDate?.toIso8601String(),
        "payment_method": paymentMethod,
        "invoice_number": invoiceNumber,
        "student_name": studentName,
    };
}
