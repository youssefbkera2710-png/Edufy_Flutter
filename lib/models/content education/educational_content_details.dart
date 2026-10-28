import 'package:edufy/models/content%20education/education.dart';

class EducationalContentDetails {
  String? message;
  int? status;
  Education? data;

  EducationalContentDetails({this.message, this.status, this.data});

  EducationalContentDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Education.fromJson(json['data']) : null;
  }
}