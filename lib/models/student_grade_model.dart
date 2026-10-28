// models/student_grade_model.dart

class StudentGrade {
  final int? studentId;
  final String? studentName;
  final String? studentCode;
  final double? score;
  final int? gradeId;
  final bool? hasGrade;

  StudentGrade({
    this.studentId,
    this.studentName,
    this.studentCode,
    this.score,
    this.gradeId,
    this.hasGrade,
  });

  factory StudentGrade.fromMap(Map<String, dynamic> json) {
    return StudentGrade(
      studentId: json['student_id'],
      studentName: json['student_name'],
      studentCode: json['student_code'],
      score: json['score'] != null
          ? (json['score'] is int
                ? (json['score'] as int).toDouble()
                : json['score']?.toDouble())
          : null,
      gradeId: json['grade_id'],
      hasGrade: json['has_grade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'student_code': studentCode,
      'score': score,
      'grade_id': gradeId,
      'has_grade': hasGrade,
    };
  }
}

class GradeSubmission {
  final int studentId;
  final double score;

  GradeSubmission({required this.studentId, required this.score});

  Map<String, dynamic> toMap() {
    return {'student_id': studentId, 'score': score};
  }
}
