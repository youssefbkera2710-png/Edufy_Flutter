class Comment {
  int? id;
  String? comment;
  String? createdAt;
  bool? isEdited;
  String? studentName;
  String? userAvatar;
  bool? hasReplies;
  bool? isOwn;

  Comment({
    this.id,
    this.comment,
    this.createdAt,
    this.isEdited,
    this.studentName,
    this.userAvatar,
    this.hasReplies,
    this.isOwn
  });

  Comment.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    isEdited = json['is_edited'];
    studentName = json['user_name'];
    userAvatar = json['user_avatar'];
    hasReplies = json['has_replies'];
    isOwn = json['is_owner'];
  }
}