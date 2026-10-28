
import 'dart:convert';

Behaviors behaviorsFromMap(String str) => Behaviors.fromMap(json.decode(str));

String behaviorsToMap(Behaviors data) => json.encode(data.toMap());

class Behaviors {
  final int? id;
  final int? studentId;
  final String? studentName;
  final String? studentCode;
  final int? createdBy;
  final String? creatorName;
  final int? academicYearId;
  final String? academicYearName;
  final String? type;
  final String? typeLabel;
  final String? title;
  final String? description;
  final DateTime? behaviorDate;
  final bool? isResolved;
  final String? isResolvedLabel;

  Behaviors({
    this.id,
    this.studentId,
    this.studentName,
    this.studentCode,
    this.createdBy,
    this.creatorName,
    this.academicYearId,
    this.academicYearName,
    this.type,
    this.typeLabel,
    this.title,
    this.description,
    this.behaviorDate,
    this.isResolved,
    this.isResolvedLabel,
  });

  Behaviors copyWith({
    int? id,
    int? studentId,
    String? studentName,
    String? studentCode,
    int? createdBy,
    String? creatorName,
    int? academicYearId,
    String? academicYearName,
    String? type,
    String? typeLabel,
    String? title,
    String? description,
    DateTime? behaviorDate,
    bool? isResolved,
    String? isResolvedLabel,
  }) => Behaviors(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    studentName: studentName ?? this.studentName,
    studentCode: studentCode ?? this.studentCode,
    createdBy: createdBy ?? this.createdBy,
    creatorName: creatorName ?? this.creatorName,
    academicYearId: academicYearId ?? this.academicYearId,
    academicYearName: academicYearName ?? this.academicYearName,
    type: type ?? this.type,
    typeLabel: typeLabel ?? this.typeLabel,
    title: title ?? this.title,
    description: description ?? this.description,
    behaviorDate: behaviorDate ?? this.behaviorDate,
    isResolved: isResolved ?? this.isResolved,
    isResolvedLabel: isResolvedLabel ?? this.isResolvedLabel,
  );

  factory Behaviors.fromMap(Map<String, dynamic> json) => Behaviors(
    id: json["id"],
    studentId: json["student_id"],
    studentName: json["student_name"],
    studentCode: json["student_code"],
    createdBy: json["created_by"],
    creatorName: json["creator_name"],
    academicYearId: json["academic_year_id"],
    academicYearName: json["academic_year_name"],
    type: json["type"],
    typeLabel: json["type_label"],
    title: json["title"],
    description: json["description"],
    behaviorDate: json["behavior_date"] == null
        ? null
        : DateTime.parse(json["behavior_date"]),
    isResolved: json["is_resolved"],
    isResolvedLabel: json["is_resolved_label"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "student_id": studentId,
    "student_name": studentName,
    "student_code": studentCode,
    "created_by": createdBy,
    "creator_name": creatorName,
    "academic_year_id": academicYearId,
    "academic_year_name": academicYearName,
    "type": type,
    "type_label": typeLabel,
    "title": title,
    "description": description,
    "behavior_date": behaviorDate == null
        ? null
        : "${behaviorDate!.year.toString().padLeft(4, '0')}-${behaviorDate!.month.toString().padLeft(2, '0')}-${behaviorDate!.day.toString().padLeft(2, '0')}",
    "is_resolved": isResolved,
    "is_resolved_label": isResolvedLabel,
  };
}
