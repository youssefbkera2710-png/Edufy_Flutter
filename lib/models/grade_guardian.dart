// GradeGuardian.dart
import 'dart:convert';

GradeGuardian gradeguardianFromMap(String str) =>
    GradeGuardian.fromMap(json.decode(str));
String gradeguardianToMap(GradeGuardian data) => json.encode(data.toMap());

class GradeGuardian {
  final int? totalExams;
  final List<Subject>? subjects;
  final double? overallAverage;
  final double? overallPercentage;
  final String? highestScore;
  final String? lowestScore;
  final String? performanceMessage;

  GradeGuardian({
    this.totalExams,
    this.subjects,
    this.overallAverage,
    this.overallPercentage,
    this.highestScore,
    this.lowestScore,
    this.performanceMessage,
  });

  factory GradeGuardian.fromMap(Map<String, dynamic> json) => GradeGuardian(
    totalExams: json["total_exams"],
    subjects: json["subjects"] == null
        ? []
        : List<Subject>.from(json["subjects"].map((x) => Subject.fromMap(x))),
    overallAverage: _toDouble(json["overall_average"]),
    overallPercentage: _toDouble(json["overall_percentage"]),
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

// ============================================================
// Subject (المادة) - النسخة القديمة مع تعديلات جديدة
// ============================================================
class Subject {
  final int? id;
  final String? subjectName;
  final double? averageScore;
  final double? averageMax;
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
    id: json["subject_id"] ?? json["id"],
    subjectName: json["subject_name"] ?? json["name"],
    averageScore: _toDouble(json["average_score"] ?? json["avg_score"]),
    averageMax: _toDouble(json["average_max"] ?? json["max_score"]),
    percentage: json["percentage"]?.toInt(),
    examsCount: json["exams_count"] ?? json["total_exams"],
  );

  Map<String, dynamic> toMap() => {
    "subject_id": id,
    "subject_name": subjectName,
    "average_score": averageScore,
    "average_max": averageMax,
    "percentage": percentage,
    "exams_count": examsCount,
  };

  Subject copyWith({
    int? id,
    String? subjectName,
    double? averageScore,
    double? averageMax,
    int? percentage,
    int? examsCount,
  }) {
    return Subject(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      averageScore: averageScore ?? this.averageScore,
      averageMax: averageMax ?? this.averageMax,
      percentage: percentage ?? this.percentage,
      examsCount: examsCount ?? this.examsCount,
    );
  }
}

// ============================================================
// SubjectExam (امتحان مادة) - للطالب
// ============================================================
class SubjectExam {
  final int? examId;
  final int? subjectId;
  final String? examTitle;
  final String? examDate;
  final String? subjectName;
  final double? score;
  final double? maxScore;
  final int? percentage;

  SubjectExam({
    this.examId,
    this.subjectId,
    this.examTitle,
    this.examDate,
    this.subjectName,
    this.score,
    this.maxScore,
    this.percentage,
  });

  factory SubjectExam.fromMap(Map<String, dynamic> json) {
    return SubjectExam(
      examId: json["exam_id"],
      subjectId: json["subject_id"],
      examTitle: json["exam_title"],
      examDate: json["exam_date"],
      subjectName: json["subject_name"],
      score: _toDouble(json["score"]),
      maxScore: _toDouble(json["max_score"]),
      percentage: json["percentage"]?.toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
    "exam_id": examId,
    "subject_id": subjectId,
    "exam_title": examTitle,
    "exam_date": examDate,
    "subject_name": subjectName,
    "score": score,
    "max_score": maxScore,
    "percentage": percentage,
  };
}

// ============================================================
// SubjectWithExams (مادة مع تفاصيل امتحاناتها) - جديد
// ============================================================
class SubjectWithExams {
  final int? subjectId;
  final String? subjectName;
  final int? examsCount;
  final double? averageScore;
  final double? averageMax;
  final int? percentage;
  final List<SubjectExam>? exams;

  SubjectWithExams({
    this.subjectId,
    this.subjectName,
    this.examsCount,
    this.averageScore,
    this.averageMax,
    this.percentage,
    this.exams,
  });

  factory SubjectWithExams.fromMap(Map<String, dynamic> json) {
    return SubjectWithExams(
      subjectId: json["subject_id"],
      subjectName: json["subject_name"],
      examsCount: json["exams_count"],
      averageScore: _toDouble(json["average_score"]),
      averageMax: _toDouble(json["average_max"]),
      percentage: json["percentage"]?.toInt(),
      exams: json["exams"] == null
          ? []
          : List<SubjectExam>.from(
              json["exams"].map((x) => SubjectExam.fromMap(x)),
            ),
    );
  }

  Map<String, dynamic> toMap() => {
    "subject_id": subjectId,
    "subject_name": subjectName,
    "exams_count": examsCount,
    "average_score": averageScore,
    "average_max": averageMax,
    "percentage": percentage,
    "exams": exams == null
        ? []
        : List<dynamic>.from(exams!.map((x) => x.toMap())),
  };
}

// ============================================================
// دالة مساعدة للتحويل إلى double (محسّنة)
// ============================================================
double? _toDouble(dynamic value) {
  if (value == null) return null;

  // إذا كان بالفعل double
  if (value is double) return value;

  // إذا كان int
  if (value is int) return value.toDouble();

  // إذا كان num (int أو double)
  if (value is num) return value.toDouble();

  // إذا كان String
  if (value is String) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  return null;
}
