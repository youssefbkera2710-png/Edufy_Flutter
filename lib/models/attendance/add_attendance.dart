class AddAttendanceResponse {
  final String? message;
  final int? status;
  final List<AttendanceData>? data;

  AddAttendanceResponse({this.message, this.status, this.data});

  factory AddAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AddAttendanceResponse(
      message: json['message'],
      status: json['status'],
      data: json['data'] != null
          ? List<AttendanceData>.from(
              json['data'].map((x) => AttendanceData.fromJson(x)),
            )
          : null,
    );
  }
}

class AttendanceData {
  final int? id;
  final int? studentId;
  final String? studentName;
  final String? studentCode;
  final String? subject;
  final int? subjectId;
  final String? className;
  final int? classId;
  final String? teacherName;
  final String? date;
  final int? sessionNumber;
  final String? status;
  final String? excuseStatus;

  AttendanceData({
    this.id,
    this.studentId,
    this.studentName,
    this.studentCode,
    this.subject,
    this.subjectId,
    this.className,
    this.classId,
    this.teacherName,
    this.date,
    this.sessionNumber,
    this.status,
    this.excuseStatus,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      id: json['id'],
      studentId: json['student_id'],
      studentName: json['student_name'],
      studentCode: json['student_code'],
      subject: json['subject'],
      subjectId: json['subject_id'],
      className: json['class'],
      classId: json['class_id'],
      teacherName: json['teacher_name'],
      date: json['date'],
      sessionNumber: json['session_number'],
      status: json['status'],
      excuseStatus: json['excuse_status'],
    );
  }
}
