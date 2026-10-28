import '../../models/content education/education.dart';

class AddEducationalContentModel {
  String? message;
  int? status;
  Education? data;

  AddEducationalContentModel({this.message, this.status, this.data});

  AddEducationalContentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Education.fromJson(json['data']) : null;
  }
}