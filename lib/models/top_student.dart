import 'dart:convert';

TopStudent topStudentFromMap(String str) =>
    TopStudent.fromMap(json.decode(str));

String topStudentToMap(TopStudent data) => json.encode(data.toMap());

class TopStudent {
  final int? id;
  final int? studentId;
  final String? studentName;
  final String? currentClass;
  final String? achievement;
  final String? image;
  final int? showOrder;
  final bool? isActive;

  TopStudent({
    this.id,
    this.studentId,
    this.studentName,
    this.currentClass,
    this.achievement,
    this.image,
    this.showOrder,
    this.isActive,
  });

  factory TopStudent.fromMap(Map<String, dynamic> json) => TopStudent(
        id: json["id"],
        studentId: json["student_id"],
        studentName: json["student_name"],
        currentClass: json["current_class"],
        achievement: json["achievement"],
        image: json["image"],
        showOrder: json["show_order"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "student_id": studentId,
        "student_name": studentName,
        "current_class": currentClass,
        "achievement": achievement,
        "image": image,
        "show_order": showOrder,
        "is_active": isActive,
      };
}

// ─────────────────────────────────────────────
// PaginationMeta — أضفه في نفس ملف top_student.dart
// ─────────────────────────────────────────────
class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMorePages;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMorePages,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginationMeta.fromMap(Map<String, dynamic> json) => PaginationMeta(
        currentPage: json["current_page"] ?? 1,
        lastPage: json["last_page"] ?? 1,
        perPage: json["per_page"] ?? 15,
        total: json["total"] ?? 0,
        hasMorePages: json["has_more_pages"] ?? false,
        nextPageUrl: json["next_page_url"],
        prevPageUrl: json["prev_page_url"],
      );

  // للحالات الاستثنائية (خطأ في الشبكة)
  factory PaginationMeta.empty() => PaginationMeta(
        currentPage: 1,
        lastPage: 1,
        perPage: 15,
        total: 0,
        hasMorePages: false,
      );
}
class TopStudentsResponse {
  final List<TopStudent> data;
  final PaginationMeta pagination;
  final String message;
  final int status;

  TopStudentsResponse({
    required this.data,
    required this.pagination,
    required this.message,
    required this.status,
  });

  factory TopStudentsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return TopStudentsResponse(
      data: dataList.map((e) => TopStudent.fromMap(e)).toList(),
      pagination: PaginationMeta.fromMap(json['pagination'] ?? {}),
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
class TopStudentResponse {
  final TopStudent? data;
  final String message;
  final int status;

  TopStudentResponse({
    this.data,
    required this.message,
    required this.status,
  });

  factory TopStudentResponse.fromJson(Map<String, dynamic> json) {
    return TopStudentResponse(
      data: json['data'] != null ? TopStudent.fromMap(json['data']) : null,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}