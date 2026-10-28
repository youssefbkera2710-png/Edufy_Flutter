// To parse this JSON data, do
//
//     final attendanceStatistics = attendanceStatisticsFromMap(jsonString);

import 'dart:convert';

AttendanceStatistics attendanceStatisticsFromMap(String str) => AttendanceStatistics.fromMap(json.decode(str));

String attendanceStatisticsToMap(AttendanceStatistics data) => json.encode(data.toMap());

class AttendanceStatistics {
    final int? totalSessions;
    final int? present;
    final int? absent;
    final int? late;
    final int? excused;
    final double? attendancePercentage;
    final String? performanceMessage;

    AttendanceStatistics({
        this.totalSessions,
        this.present,
        this.absent,
        this.late,
        this.excused,
        this.attendancePercentage,
        this.performanceMessage
    });

    AttendanceStatistics copyWith({
        int? totalSessions,
        int? present,
        int? absent,
        int? late,
        int? excused,
        double? attendancePercentage,
        String? performanceMessage
    }) => 
        AttendanceStatistics(
            totalSessions: totalSessions ?? this.totalSessions,
            present: present ?? this.present,
            absent: absent ?? this.absent,
            late: late ?? this.late,
            excused: excused ?? this.excused,
            attendancePercentage: attendancePercentage ?? this.attendancePercentage,
            performanceMessage: performanceMessage ?? this.performanceMessage
        );

    factory AttendanceStatistics.fromMap(Map<String, dynamic> json) => AttendanceStatistics(
        totalSessions: json["total_sessions"],
        present: json["present"],
        absent: json["absent"],
        late: json["late"],
        excused: json["excused"],
        attendancePercentage: json["attendance_percentage"]?.toDouble(),
        performanceMessage: json["performance_message"],
    );

    Map<String, dynamic> toMap() => {
        "total_sessions": totalSessions,
        "present": present,
        "absent": absent,
        "late": late,
        "excused": excused,
        "attendance_percentage": attendancePercentage,
        "performance_message": performanceMessage,
    };
}
