import 'dart:convert';

Absence absenceFromMap(String str) => Absence.fromMap(json.decode(str));

String absenceToMap(Absence data) => json.encode(data.toMap());

class Absence {
  final int? id;
  final DateTime? absenceDate;
  final String? reason;
  final String? status;
  final String? rejectionReason;
  final dynamic attachment;
  final String? studentName;
  final DateTime? createdAt;

  Absence({
    this.id,
    this.absenceDate,
    this.reason,
    this.status,
    this.rejectionReason,
    this.attachment,
    this.studentName,
    this.createdAt,
  });

  Absence copyWith({
    int? id,
    DateTime? absenceDate,
    String? reason,
    String? status,
    String? rejectionReason,
    dynamic attachment,
    String? studentName,
    DateTime? createdAt,
  }) => Absence(
    id: id ?? this.id,
    absenceDate: absenceDate ?? this.absenceDate,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    rejectionReason: rejectionReason ?? this.rejectionReason,
    attachment: attachment ?? this.attachment,
    studentName: studentName ?? this.studentName,
    createdAt: createdAt ?? this.createdAt,
  );

  factory Absence.fromMap(Map<String, dynamic> json) => Absence(
    id: json["id"],
    absenceDate: json["absence_date"] == null
        ? null
        : DateTime.parse(json["absence_date"]),
    reason: json["reason"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    attachment: json["attachment"],
    studentName: json["student_name"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "absence_date": absenceDate?.toIso8601String(),
    "reason": reason,
    "status": status,
    "rejection_reason": rejectionReason,
    "attachment": attachment,
    "student_name": studentName,
    "created_at": createdAt?.toIso8601String(),
  };
}
