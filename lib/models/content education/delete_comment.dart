class DeleteCommentModel {
  String? message;
  int? status;

  DeleteCommentModel({this.message, this.status});

  DeleteCommentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['message'] = message;
    jsonMap['status'] = status;
    return jsonMap;
  }
}