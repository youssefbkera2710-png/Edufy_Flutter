import 'dart:convert';

AttendanceAndAbsence attendanceAndAbsenceFromMap(String str) =>
    AttendanceAndAbsence.fromMap(json.decode(str));

String attendanceAndAbsenceToMap(AttendanceAndAbsence data) =>
    json.encode(data.toMap());

class AttendanceAndAbsence {
  final List<Datum>? data;
  final Pagination? pagination;

  AttendanceAndAbsence({this.data, this.pagination});

  AttendanceAndAbsence copyWith({List<Datum>? data, Pagination? pagination}) =>
      AttendanceAndAbsence(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory AttendanceAndAbsence.fromMap(Map<String, dynamic> json) =>
      AttendanceAndAbsence(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromMap(json["pagination"]),
      );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "pagination": pagination?.toMap(),
  };
}

class Datum {
  final DateTime? date;
  final String? status;
  final int? presentCount;
  final int? absentCount;
  final int? lateCount;
  final int? totalSessions;

  Datum({
    this.date,
    this.status,
    this.presentCount,
    this.absentCount,
    this.lateCount,
    this.totalSessions,
  });

  Datum copyWith({
    DateTime? date,
    String? status,
    int? presentCount,
    int? absentCount,
    int? lateCount,
    int? totalSessions,
  }) => Datum(
    date: date ?? this.date,
    status: status ?? this.status,
    presentCount: presentCount ?? this.presentCount,
    absentCount: absentCount ?? this.absentCount,
    lateCount: lateCount ?? this.lateCount,
    totalSessions: totalSessions ?? this.totalSessions,
  );

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
    presentCount: json["present_count"],
    absentCount: json["absent_count"],
    lateCount: json["late_count"],
    totalSessions: json["total_sessions"],
  );

  Map<String, dynamic> toMap() => {
    "date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "status": status,
    "present_count": presentCount,
    "absent_count": absentCount,
    "late_count": lateCount,
    "total_sessions": totalSessions,
  };
}

class Pagination {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;
  final bool? hasMorePages;
  final dynamic nextPageUrl;
  final dynamic prevPageUrl;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
    this.hasMorePages,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  Pagination copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    int? from,
    int? to,
    bool? hasMorePages,
    dynamic nextPageUrl,
    dynamic prevPageUrl,
  }) => Pagination(
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    total: total ?? this.total,
    from: from ?? this.from,
    to: to ?? this.to,
    hasMorePages: hasMorePages ?? this.hasMorePages,
    nextPageUrl: nextPageUrl ?? this.nextPageUrl,
    prevPageUrl: prevPageUrl ?? this.prevPageUrl,
  );

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
    from: json["from"],
    to: json["to"],
    hasMorePages: json["has_more_pages"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
  );

  Map<String, dynamic> toMap() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
    "from": from,
    "to": to,
    "has_more_pages": hasMorePages,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
  };
}
