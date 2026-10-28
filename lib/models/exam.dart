// To parse this JSON data, do
//
//     final exam = examFromMap(jsonString);

import 'dart:convert';

Exam examFromMap(String str) => Exam.fromMap(json.decode(str));

String examToMap(Exam data) => json.encode(data.toMap());

class Exam {
    final int? id;
    final String? title;
    final DateTime? examDate;
    final String? maxScore;
    final String? description;
    final String? subjectName;
    final String? source;
    final bool? isPast;
    final String? score;

    Exam({
        this.id,
        this.title,
        this.examDate,
        this.maxScore,
        this.description,
        this.subjectName,
        this.source,
        this.isPast,
        this.score,
    });

    Exam copyWith({
        int? id,
        String? title,
        DateTime? examDate,
        String? maxScore,
        String? description,
        String? subjectName,
        String? source,
        bool? isPast,
        String? score,
    }) => 
        Exam(
            id: id ?? this.id,
            title: title ?? this.title,
            examDate: examDate ?? this.examDate,
            maxScore: maxScore ?? this.maxScore,
            description: description ?? this.description,
            subjectName: subjectName ?? this.subjectName,
            source: source ?? this.source,
            isPast: isPast ?? this.isPast,
            score: score ?? this.score,
        );

    factory Exam.fromMap(Map<String, dynamic> json) => Exam(
        id: json["id"],
        title: json["title"],
        examDate: json["exam_date"] == null ? null : DateTime.parse(json["exam_date"]),
        maxScore: json["max_score"],
        description: json["description"],
        subjectName: json["subject_name"],
        source: json["source"],
        isPast: json["is_past"],
        score: json["score"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "exam_date": examDate?.toIso8601String(),
        "max_score": maxScore,
        "description": description,
        "subject_name": subjectName,
        "source": source,
        "is_past": isPast,
        "score": score,
    };
}
