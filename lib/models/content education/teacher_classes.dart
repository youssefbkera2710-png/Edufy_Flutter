class TeacherClassesResponse {
  String? message;
  int? status;
  List<ClassModel>? data;

  TeacherClassesResponse({this.message, this.status, this.data});

  TeacherClassesResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <ClassModel>[];
      json['data'].forEach((v) {
        data!.add(ClassModel.fromJson(v));
      });
    }
  }
}

class ClassModel {
  int? id;
  String? stage;
  String? gradeLevel;
  int? divisionNumber;
  String? specialization;
  int? subjectId;
  String? subjectName;
  String? teacherName;
  int? teacherId;

  ClassModel({
    this.id,
    this.stage,
    this.gradeLevel,
    this.divisionNumber,
    this.specialization,
    this.subjectId,
    this.subjectName,
    this.teacherName,
    this.teacherId,
  });

  ClassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stage = json['stage'];
    gradeLevel = json['grade_level'];
    divisionNumber = json['division_number'];
    specialization = json['specialization'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    teacherName = json['teacher_name'];
    teacherId = json['teacher_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['stage'] = stage;
    data['grade_level'] = gradeLevel;
    data['division_number'] = divisionNumber;
    data['specialization'] = specialization;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['teacher_name'] = teacherName;
    data['teacher_id'] = teacherId;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
