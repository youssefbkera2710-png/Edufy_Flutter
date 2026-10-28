class AttendanceListResponse {
  final String? message;
  final int? status;
  final List<StudentAttendance>? data;

  AttendanceListResponse({this.message, this.status, this.data});

  factory AttendanceListResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceListResponse(
      message: json['message'],
      status: json['status'],
      data: json['data'] != null
          ? List<StudentAttendance>.from(
              json['data'].map((x) => StudentAttendance.fromJson(x)),
            )
          : null,
    );
  }
}

class StudentAttendance {
  final int? studentId;
  final String? studentName;
  final String? studentCode;
  final String? status;
  final int? attendanceId;

  StudentAttendance({
    this.studentId,
    this.studentName,
    this.studentCode,
    this.status,
    this.attendanceId,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      studentId: json['student_id'],
      studentName: json['student_name'],
      studentCode: json['student_code'],
      status: json['status'],
      attendanceId: json['attendance_id'],
    );
  }
}
