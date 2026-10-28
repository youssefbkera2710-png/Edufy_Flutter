import 'package:edufy/models/content%20education/education.dart';
import 'package:edufy/models/content%20education/pagination.dart';

class EducationalContentModel {
  String? message;
  int? status;
  List<Education>? data;
  PaginationModel? pagination;

  EducationalContentModel({this.message, this.status, this.data, this.pagination});

  EducationalContentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];

    if (json['data'] != null) {
      data = <Education>[];
      json['data'].forEach((v) {
        data!.add(Education.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? PaginationModel.fromJson(json['pagination'])
        : null;
  }
}