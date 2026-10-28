class Schedule {
  final int? id;
  final String? dayOfWeek;
  final int? sessionNumber;
  final String? startTime;
  final String? endTime;
  final String? room;
  final String? subject;
  final String? topic;
  final String? teacherName;
  final int? divisionNumber;
  final int? classId;
  final int? subjectId;

  Schedule({
    this.id,
    this.dayOfWeek,
    this.sessionNumber,
    this.startTime,
    this.endTime,
    this.room,
    this.subject,
    this.topic,
    this.teacherName,
    this.divisionNumber,
    this.classId,
    this.subjectId,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      dayOfWeek: json['day_of_week']?.toString(),
      divisionNumber: json['division_number'] is int
          ? json['division_number']
          : int.tryParse(json['division_number'].toString()),
      sessionNumber: json['session_number'] is int
          ? json['session_number']
          : int.tryParse(json['session_number'].toString()),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      room: json['room']?.toString(),
      subject: json['subject_name']?.toString() ?? json['subject']?.toString(),
      topic: json['topic']?.toString(),
      teacherName: json['teacher_name']?.toString(),
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id'].toString()),
      subjectId: json['subject_id'] is int
          ? json['subject_id']
          : int.tryParse(json['subject_id'].toString()),
    );
  }
}
