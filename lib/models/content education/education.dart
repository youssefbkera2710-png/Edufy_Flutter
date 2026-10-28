import 'package:edufy/models/media.dart';

class Education {
  int? id;
  String? title;
  String? body;
  String? publishDate;
  bool? allowComments;
  String? teacherName;
  String? subjectName;
  int? subjectId;
  List<int>? classesIds;
  String? topic;
  List<Media>? files;

  Education({
    this.id,
    this.title,
    this.body,
    this.publishDate,
    this.allowComments,
    this.teacherName,
    this.subjectName,
    this.subjectId,
    this.classesIds,
    this.topic,
    this.files,
  });

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    publishDate = json['publish_date'];
    allowComments = json['allow_comments'] == 1 || json['allow_comments'] == true;
    teacherName = json['teacher_name'];
    subjectName = json['subject_name'];
    subjectId = json['subject_id'];
    topic = json['topic'];

    if (json['classes'] != null) {
      classesIds = [];
      json['classes'].forEach((v) {
        if (v['id'] != null) classesIds!.add(v['id']);
      });
    } else {
      classesIds = [];
    }

    if (json['files'] != null) {
      files = (json['files'] as List).map((i) => Media.fromJson(i)).toList();
    } else {
      files = [];
    }
  }
}