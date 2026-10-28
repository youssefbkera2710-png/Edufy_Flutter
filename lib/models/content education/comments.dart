import 'package:edufy/models/content%20education/comment.dart';

import 'package:edufy/models/content%20education/pagination.dart';

class CommentsModel {
  String? message;
  List<Comment>? data;
  PaginationModel? pagination;
  int? status;

  CommentsModel({this.message, this.data, this.pagination, this.status});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Comment>[];
      json['data'].forEach((v) {
        data!.add(Comment.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? PaginationModel.fromJson(json['pagination'])
        : null;
    status = json['status'];
  }
}