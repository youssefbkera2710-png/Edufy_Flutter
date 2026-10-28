class ClassHistoryResponse {
  final String? message;
  final int? status;
  final List<Class> data;

  ClassHistoryResponse({this.message, this.status, required this.data});

  factory ClassHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ClassHistoryResponse(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Class>.from(json["data"].map((x) => Class.fromMap(x))),
    );
  }
}

class Class {
  final int? classId;
  final String? className;
  final String? stage;
  final String? academicYear;
  final String? semester;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isCurrent;

  Class({
    this.classId,
    this.className,
    this.stage,
    this.academicYear,
    this.semester,
    this.startDate,
    this.endDate,
    this.isCurrent,
  });

  factory Class.fromMap(Map<String, dynamic> json) {
    return Class(
      classId: json["class_id"],
      className: json["class_name"],
      stage: json["stage"],
      academicYear: json["academic_year"],
      semester: json["semester"],
      startDate: json["start_date"] != null
          ? DateTime.parse(json["start_date"])
          : null,
      endDate: json["end_date"] != null
          ? DateTime.parse(json["end_date"])
          : null,
      isCurrent: json["is_current"],
    );
  }
}
