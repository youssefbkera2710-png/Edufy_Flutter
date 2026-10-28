import 'dart:convert';

TeacherExam teacherExamFromMap(String str) =>
    TeacherExam.fromMap(json.decode(str));
String teacherExamToMap(TeacherExam data) => json.encode(data.toMap());

class TeacherExam {
  final List<Datums>? data;
  final Pagination? pagination;

  TeacherExam({this.data, this.pagination});

  TeacherExam copyWith({List<Datums>? data, Pagination? pagination}) =>
      TeacherExam(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory TeacherExam.fromMap(Map<String, dynamic> json) => TeacherExam(
    data: json["data"] == null
        ? []
        : List<Datums>.from(json["data"]!.map((x) => Datums.fromMap(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "pagination": pagination?.toMap(),
  };
}

class Datums {
  final int? id;
  final String? title;
  final DateTime? examDate;
  final String? maxScore;
  final String? description;
  final String? source;
  final String? createdBy;
  final int? createdById;
  final int? assignmentsCount;
  final List<ClassesSummary>? classesSummary;
  final List<Assignment>? assignments;
  final String? selectionType;
  final dynamic classSelection;
  final int? subjectId;
  final dynamic topic;
  final bool? isPast;

  Datums({
    this.id,
    this.title,
    this.examDate,
    this.maxScore,
    this.description,
    this.source,
    this.createdBy,
    this.createdById,
    this.assignmentsCount,
    this.classesSummary,
    this.assignments,
    this.selectionType,
    this.classSelection,
    this.subjectId,
    this.topic,
    this.isPast,
  });

  factory Datums.fromMap(Map<String, dynamic> json) => Datums(
    id: json["id"],
    title: json["title"],
    examDate: json["exam_date"] == null
        ? null
        : DateTime.parse(json["exam_date"]),
    maxScore: json["max_score"]?.toString(),
    description: json["description"],
    source: json["source"],
    createdBy: json["created_by"],
    createdById: json["created_by_id"],
    assignmentsCount: json["assignments_count"],
    classesSummary: json["classes_summary"] == null
        ? []
        : List<ClassesSummary>.from(
            json["classes_summary"]!.map((x) => ClassesSummary.fromMap(x)),
          ),
    assignments: json["assignments"] == null
        ? []
        : List<Assignment>.from(
            json["assignments"]!.map((x) => Assignment.fromMap(x)),
          ),
    selectionType: json["selection_type"],
    classSelection: json["class_selection"],
    subjectId: json["subject_id"],
    topic: json["topic"],
    isPast: json["is_past"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "exam_date": examDate?.toIso8601String(),
    "max_score": maxScore,
    "description": description,
    "source": source,
    "created_by": createdBy,
    "created_by_id": createdById,
    "assignments_count": assignmentsCount,
    "classes_summary": classesSummary == null
        ? []
        : List<dynamic>.from(classesSummary!.map((x) => x.toMap())),
    "assignments": assignments == null
        ? []
        : List<dynamic>.from(assignments!.map((x) => x.toMap())),
    "selection_type": selectionType,
    "class_selection": classSelection,
    "subject_id": subjectId,
    "topic": topic,
    "is_past": isPast,
  };
}

class ClassesSummary {
  final String? stage;
  final String? gradeLevel;
  final int? classesCount;
  final List<String>? specializations;
  final int? classId;

  ClassesSummary({
    this.stage,
    this.gradeLevel,
    this.classesCount,
    this.specializations,
    this.classId,
  });

  factory ClassesSummary.fromMap(Map<String, dynamic> json) => ClassesSummary(
    stage: json["stage"],
    gradeLevel: json["grade_level"],
    classesCount: json["classes_count"],
    specializations: json["specializations"] == null
        ? []
        : List<String>.from(json["specializations"]!.map((x) => x)),
    classId: json["class_id"],
  );

  Map<String, dynamic> toMap() => {
    "stage": stage,
    "grade_level": gradeLevel,
    "classes_count": classesCount,
    "specializations": specializations == null
        ? []
        : List<dynamic>.from(specializations!.map((x) => x)),
    "class_id": classId,
  };
}

class Assignment {
  final int? id;
  final int? classId;
  final String? className;
  final String? classStage;
  final String? classGrade;
  final int? classDivision;
  final String? classSpecialization;
  final int? subjectId;
  final String? subjectName;
  final dynamic topic;
  final bool? canEnterGrades;

  Assignment({
    this.id,
    this.classId,
    this.className,
    this.classStage,
    this.classGrade,
    this.classDivision,
    this.classSpecialization,
    this.subjectId,
    this.subjectName,
    this.topic,
    this.canEnterGrades,
  });

  factory Assignment.fromMap(Map<String, dynamic> json) => Assignment(
    id: json["id"],
    classId: json["class_id"],
    className: json["class_name"],
    classStage: json["class_stage"],
    classGrade: json["class_grade"],
    classDivision: json["class_division"],
    classSpecialization: json["class_specialization"],
    subjectId: json["subject_id"],
    subjectName: json["subject_name"],
    topic: json["topic"],
    canEnterGrades: json["can_enter_grades"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "class_id": classId,
    "class_name": className,
    "class_stage": classStage,
    "class_grade": classGrade,
    "class_division": classDivision,
    "class_specialization": classSpecialization,
    "subject_id": subjectId,
    "subject_name": subjectName,
    "topic": topic,
    "can_enter_grades": canEnterGrades,
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
  final String? nextPageUrl;
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
