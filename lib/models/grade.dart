/// grade.dart

import 'dart:convert';

Grade gradeFromMap(String str) => Grade.fromMap(json.decode(str));

String gradeToMap(Grade data) => json.encode(data.toMap());

class Grade {
  final int? totalExams;

  final List<Subject>? subjects;

  final double? overallAverage;

  final double? overallPercentage;

  final String? highestScore;

  final String? lowestScore;

  final String? performanceMessage;

  Grade({
    this.totalExams,
    this.subjects,
    this.overallAverage,
    this.overallPercentage,
    this.highestScore,
    this.lowestScore,
    this.performanceMessage,
  });

  factory Grade.fromMap(Map<String, dynamic> json) => Grade(
    totalExams: json["total_exams"],

    subjects: json["subjects"] == null
        ? []
        : List<Subject>.from(json["subjects"].map((x) => Subject.fromMap(x))),

    overallAverage: json["overall_average"]?.toDouble(),

    overallPercentage: json["overall_percentage"]?.toDouble(),

    highestScore: json["highest_score"],

    lowestScore: json["lowest_score"],

    performanceMessage: json["performance_message"],
  );

  Map<String, dynamic> toMap() => {
    "total_exams": totalExams,

    "subjects": subjects == null
        ? []
        : List<dynamic>.from(subjects!.map((x) => x.toMap())),

    "overall_average": overallAverage,

    "overall_percentage": overallPercentage,

    "highest_score": highestScore,

    "lowest_score": lowestScore,

    "performance_message": performanceMessage,
  };
}

class Subject {
  final int? id;

  final String? subjectName;

  final int? averageScore;

  final int? averageMax;

  final int? percentage;

  final int? examsCount;

  Subject({
    this.id,
    this.subjectName,
    this.averageScore,
    this.averageMax,
    this.percentage,
    this.examsCount,
  });

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
    id: json["subject_id"],

    subjectName: json["subject_name"],

    averageScore: json["average_score"],

    averageMax: json["average_max"],

    percentage: json["percentage"],

    examsCount: json["exams_count"],
  );

  Map<String, dynamic> toMap() => {
    "subject_id": id,

    "subject_name": subjectName,

    "average_score": averageScore,

    "average_max": averageMax,

    "percentage": percentage,

    "exams_count": examsCount,
  };
}

class SubjectExam {
  final String? examTitle;

  final String? examDate;

  final String? subjectName;

  final String? score;

  final String? maxScore;

  final int? percentage;

  SubjectExam({
    this.examTitle,
    this.examDate,
    this.subjectName,
    this.score,
    this.maxScore,
    this.percentage,
  });

  factory SubjectExam.fromMap(Map<String, dynamic> json) => SubjectExam(
    examTitle: json["exam_title"],

    examDate: json["exam_date"],

    subjectName: json["subject_name"],

    score: json["score"],

    maxScore: json["max_score"],

    percentage: json["percentage"],
  );

  Map<String, dynamic> toMap() => {
    "exam_title": examTitle,

    "exam_date": examDate,

    "subject_name": subjectName,

    "score": score,

    "max_score": maxScore,

    "percentage": percentage,
  };
}
