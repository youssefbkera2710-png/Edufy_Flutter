import 'dart:convert';

HomeworkModel homeworkModelFromMap(String str) =>
    HomeworkModel.fromMap(json.decode(str));

String homeworkModelToMap(HomeworkModel data) => json.encode(data.toMap());

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  print('⚠️ Cannot convert ${value.runtimeType} to int: $value');
  return null;
}

class HomeworkModel {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? topic;
  final String? className;
  final String? subjectName;
  final String? teacherName;
  final int? classId;
  final int? subjectId;
  final List<HomeworkAttachment>? attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HomeworkModel({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.topic,
    this.className,
    this.subjectName,
    this.teacherName,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.classId,
    this.subjectId,
  });

  HomeworkModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? topic,
    String? className,
    String? subjectName,
    String? teacherName,
    int? classId,
    int? subjectId,
    List<HomeworkAttachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HomeworkModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    topic: topic ?? this.topic,
    className: className ?? this.className,
    subjectName: subjectName ?? this.subjectName,
    teacherName: teacherName ?? this.teacherName,
    attachments: attachments ?? this.attachments,
    subjectId: subjectId ?? this.subjectId,
    classId: classId ?? this.classId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory HomeworkModel.fromMap(Map<String, dynamic> json) => HomeworkModel(
    id: _toInt(json["id"]),
    title: json["title"]?.toString(),
    description: json["description"]?.toString(),
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    topic: json["topic"]?.toString(),
    className: json["class_name"]?.toString(),
    subjectName: json["subject_name"]?.toString(),
    classId: _toInt(json["class_id"]),
    subjectId: _toInt(json["subject_id"]),
    teacherName: json["teacher_name"]?.toString(),
    attachments: json["attachments"] == null
        ? []
        : List<HomeworkAttachment>.from(
            json["attachments"].map((x) => HomeworkAttachment.fromMap(x)),
          ),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "due_date": dueDate != null
        ? "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}"
        : null,
    "topic": topic,
    "class_name": className,
    "subject_name": subjectName,
    "teacher_name": teacherName,
    "class_id": classId,
    "subject_id": subjectId,
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x.toMap())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class HomeworkAttachment {
  final int? id;
  final String? url;
  final String? name;
  final String? type;
  final String? size;

  HomeworkAttachment({this.id, this.url, this.name, this.type, this.size});

  factory HomeworkAttachment.fromMap(Map<String, dynamic> json) {
    return HomeworkAttachment(
      id: _toInt(json['id']),
      url: json['url']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      size: json['size']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'url': url, 'name': name, 'type': type, 'size': size};
  }
}
