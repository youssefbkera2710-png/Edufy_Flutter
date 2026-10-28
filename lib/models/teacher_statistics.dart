class TeacherStatistics {
  final UserData? user;
  final TeacherInfo? teacher;
  final Summary? summary;
  final List<ClassSubjectAssignment>? classSubjectAssignments;
  final List<TodayTimetable>? todayTimetable;

  TeacherStatistics({
    this.user,
    this.teacher,
    this.summary,
    this.classSubjectAssignments,
    this.todayTimetable,
  });

  factory TeacherStatistics.fromMap(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return TeacherStatistics(
      user: data['user'] != null ? UserData.fromMap(data['user']) : null,
      teacher:
          data['teacher'] != null ? TeacherInfo.fromMap(data['teacher']) : null,
      summary:
          data['summary'] != null ? Summary.fromMap(data['summary']) : null,
      classSubjectAssignments:
          data['class_subject_assignments'] != null
              ? List<ClassSubjectAssignment>.from(
                  data['class_subject_assignments']
                      .map((x) => ClassSubjectAssignment.fromMap(x)),
                )
              : [],
      todayTimetable:
          data['today_timetable'] != null
              ? List<TodayTimetable>.from(
                  data['today_timetable'].map((x) => TodayTimetable.fromMap(x)),
                )
              : [],
    );
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;

  UserData({this.id, this.name, this.email, this.phone, this.avatar});

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    avatar: json['avatar'],
  );
}

class TeacherInfo {
  final int? id;
  final String? specialization;
  final String? qualification;
  final DateTime? hireDate;
  final int? salary;
  final bool? showPhoneNumber;

  TeacherInfo({
    this.id,
    this.specialization,
    this.qualification,
    this.hireDate,
    this.salary,
    this.showPhoneNumber,
  });

  factory TeacherInfo.fromMap(Map<String, dynamic> json) => TeacherInfo(
    id: json['id'],
    specialization: json['specialization'],
    qualification: json['qualification'],
    hireDate:
        json['hire_date'] != null ? DateTime.tryParse(json['hire_date']) : null,
    salary: json['salary'],
    showPhoneNumber: json['show_phone_number'],
  );
}

class Summary {
  final int? assignedSubjectsCount;
  final int? assignedClassesCount;
  final int? studentsCount;
  final int? todaySessionsCount;
  final int? upcomingExamsCount;

  Summary({
    this.assignedSubjectsCount,
    this.assignedClassesCount,
    this.studentsCount,
    this.todaySessionsCount,
    this.upcomingExamsCount,
  });

  factory Summary.fromMap(Map<String, dynamic> json) => Summary(
    assignedSubjectsCount: json['assigned_subjects_count'],
    assignedClassesCount: json['assigned_classes_count'],
    studentsCount: json['students_count'],
    todaySessionsCount: json['today_sessions_count'],
    upcomingExamsCount: json['upcoming_exams_count'],
  );
}

class ClassSubjectAssignment {
  final int? id;
  final int? classId;
  final String? className;
  final String? subjectName;
  final int? weeklyHours;

  ClassSubjectAssignment({
    this.id,
    this.classId,
    this.className,
    this.subjectName,
    this.weeklyHours,
  });

  factory ClassSubjectAssignment.fromMap(Map<String, dynamic> json) =>
      ClassSubjectAssignment(
        id: json['id'],
        classId: json['class_id'],
        className: json['class_name'],
        subjectName: json['subject_name'],
        weeklyHours: json['weekly_hours'],
      );
}

class TodayTimetable {
  final int? id;
  final String? dayOfWeek;
  final int? sessionNumber;
  final String? startTime;
  final String? endTime;
  final String? room;
  final int? divisionNumber;
  final String? subjectName;
  final String? teacherName;

  TodayTimetable({
    this.id,
    this.dayOfWeek,
    this.sessionNumber,
    this.startTime,
    this.endTime,
    this.room,
    this.divisionNumber,
    this.subjectName,
    this.teacherName,
  });

  factory TodayTimetable.fromMap(Map<String, dynamic> json) => TodayTimetable(
    id: json['id'],
    dayOfWeek: json['day_of_week'],
    sessionNumber: json['session_number'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    room: json['room'],
    divisionNumber: json['division_number'],
    subjectName: json['subject_name'],
    teacherName: json['teacher_name'],
  );
}