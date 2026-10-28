// To parse this JSON data, do
//
//     final children = childrenFromMap(jsonString);

import 'dart:convert';

import 'package:edufy/models/user.dart';

Children childrenFromMap(String str) => Children.fromMap(json.decode(str));

String childrenToMap(Children data) => json.encode(data.toMap());

class Children {
    final int? id;
    final String? studentCode;
    final DateTime? birthDate;
    final DateTime? enrollmentDate;
    final User? user;
    final CurrentClass? currentClass;

    Children({
        this.id,
        this.studentCode,
        this.birthDate,
        this.enrollmentDate,
        this.user,
        this.currentClass,
    });

    Children copyWith({
        int? id,
        String? studentCode,
        DateTime? birthDate,
        DateTime? enrollmentDate,
        User? user,
        CurrentClass? currentClass,
    }) => 
        Children(
            id: id ?? this.id,
            studentCode: studentCode ?? this.studentCode,
            birthDate: birthDate ?? this.birthDate,
            enrollmentDate: enrollmentDate ?? this.enrollmentDate,
            user: user ?? this.user,
            currentClass: currentClass ?? this.currentClass,
        );

    factory Children.fromMap(Map<String, dynamic> json) => Children(
        id: json["id"],
        studentCode: json["student_code"],
        birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
        enrollmentDate: json["enrollment_date"] == null ? null : DateTime.parse(json["enrollment_date"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        currentClass: json["current_class"] == null ? null : CurrentClass.fromMap(json["current_class"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "student_code": studentCode,
        "birth_date": birthDate?.toIso8601String(),
        "enrollment_date": enrollmentDate?.toIso8601String(),
        "user": user?.toMap(),
        "current_class": currentClass?.toMap(),
    };
}

class CurrentClass {
    final int? id;
    final String? stage;
    final String? gradeLevel;
    final int? divisionNumber;
    final String? specialization;
    final String? academicYear;
    final String? semester;
    final int? capacity;

    CurrentClass({
        this.id,
        this.stage,
        this.gradeLevel,
        this.divisionNumber,
        this.specialization,
        this.academicYear,
        this.semester,
        this.capacity,
    });

    CurrentClass copyWith({
        int? id,
        String? stage,
        String? gradeLevel,
        int? divisionNumber,
        String? specialization,
        String? academicYear,
        String? semester,
        int? capacity,
    }) => 
        CurrentClass(
            id: id ?? this.id,
            stage: stage ?? this.stage,
            gradeLevel: gradeLevel ?? this.gradeLevel,
            divisionNumber: divisionNumber ?? this.divisionNumber,
            specialization: specialization ?? this.specialization,
            academicYear: academicYear ?? this.academicYear,
            semester: semester ?? this.semester,
            capacity: capacity ?? this.capacity,
        );

    factory CurrentClass.fromMap(Map<String, dynamic> json) => CurrentClass(
        id: json["id"],
        stage: json["stage"],
        gradeLevel: json["grade_level"],
        divisionNumber: json["division_number"],
        specialization: json["specialization"],
        academicYear: json["academic_year"],
        semester: json["semester"],
        capacity: json["capacity"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "stage": stage,
        "grade_level": gradeLevel,
        "division_number": divisionNumber,
        "specialization": specialization,
        "academic_year": academicYear,
        "semester": semester,
        "capacity": capacity,
    };
}

