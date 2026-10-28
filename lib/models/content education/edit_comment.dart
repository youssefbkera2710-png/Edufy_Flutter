import 'package:edufy/models/content%20education/comment.dart';

class EditCommentModel {
  String? message;
  int? status;
   Comment? data;

  EditCommentModel({this.message, this.status, this.data});

  EditCommentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ?  Comment.fromJson(json['data']) : null;
  }
}

