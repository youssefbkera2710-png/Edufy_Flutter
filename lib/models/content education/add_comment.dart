import 'package:edufy/models/content%20education/comment.dart';

class AddCommentModel {
  String? message;
  int? status;
   Comment? data;

  AddCommentModel({this.message, this.status, this.data});

  AddCommentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ?  Comment.fromJson(json['data']) : null;
  }
}

