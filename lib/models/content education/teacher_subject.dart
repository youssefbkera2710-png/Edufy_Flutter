class TeacherSubjectsResponse {
  String? message;
  int? status;
  List<SubjectModel>? data;

  TeacherSubjectsResponse({this.message, this.status, this.data});

  TeacherSubjectsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <SubjectModel>[];
      json['data'].forEach((v) {
        data!.add(SubjectModel.fromJson(v));
      });
    }
  }
}

class SubjectModel {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  SubjectModel({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  SubjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubjectModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
