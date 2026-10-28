class AppEndpoints {
  static const subUrl = 'api/';
  static const String baseUrl = "https://project1.moayadismail.com/";

  //Auth
  static const login = '${subUrl}login';
  static const forgotPassword = '${subUrl}forgot-password';
  static const verifyOTP = '${subUrl}verify-otp';
  static const resendOTP = '${subUrl}resend-otp';
  static const resetPassword = '${subUrl}set-new-password';
  static const logout = '${subUrl}logout';
  static const profile = '${subUrl}profile';
  static const getUserData = '${subUrl}profile';
  static const changeRespons = '${subUrl}change-password';

  //Notification
  static const getNotifications = '${subUrl}notifications';
  static const read = '${subUrl}notifications';
  static const unreadCount = '${subUrl}notifications/unread-count';
  ///////////////////////////////
  static const getClass = '${subUrl}student/class-history';
  static const getGuardianClass = '${subUrl}guardian/children';
  static const getAttendanceStatistics = '${subUrl}student/attendance/summary';
  static const String getGrade = "/student/grades";
  static const getGradeChildren = '${subUrl}guardian/children';

  static const getFutureExams = '${subUrl}student/exams/upcoming';
  static const getAllChildren = '${subUrl}guardian/children';
  static const getExpenses = '${subUrl}guardian/fees';
  static const getPaymentHistory = '${subUrl}guardian/fees/payments';
  static const getInvoice = '${subUrl}guardian/fees/invoices';
  static const getAbsence = '${subUrl}guardian/absence-requests';
  static const submitAbsenceRequest = '${subUrl}guardian/absence-requests';
  static const getAllExam = '${subUrl}guardian/children/';
  static const getExamStudent = '${subUrl}student/exams';
  static const getDailyAttendance = '${subUrl}guardian/children/';
  static const getDailyAttendanceStudent = '${subUrl}student/attendance/daily';
  static const getTeacherExams = '${subUrl}teacher/exams';
  static const getTeacherHomework = '${subUrl}teacher/homeworks';
  static const createExam = '${subUrl}teacher/exams';
  static const deleteExam = '${subUrl}teacher/exams';
  static const deleteHomewrok = '${subUrl}teacher/homeworks';
  static const getTeacherStatistics = '${subUrl}teacher/dashboard';
  static const outstandingStudents = 'landing/outstanding-students';

  static const getAllEducationalContentForGuardian =
      '${subUrl}guardian/educational-contents';
  static String guardianEducationalContentDetails(int contentId) =>
      '${subUrl}guardian/educational-contents/$contentId';
  static const getAllEducationalContentForStudent =
      '${subUrl}student/educational-contents';
  static const getAllEducationalContentForTeacher =
      '${subUrl}educational-contents';
  static const educationalContentDetailsForStudent =
      '${subUrl}student/educational-contents';
  static const educationalContentDetailsForTeacher =
      '${subUrl}educational-contents';
  static String getComments(int id) =>
      '${subUrl}educational-contents/$id/comments';
  static String getReplies(int id) => '${subUrl}comments/$id/replies';
  static String addComment(int id) =>
      '${subUrl}educational-contents/$id/comments';
  static String editComment(int id) => '${subUrl}comments/$id';
  static String deleteComment(int id) => '${subUrl}comments/$id';
  static const getSchedule = '${subUrl}student/timetable';
  static const getTeacherSchedule = '${subUrl}teacher/timetable';

  static const getTeacherSubjects = '${subUrl}teacher/subjects';
  static const getTeacherClasses = '${subUrl}teacher/classes';
  static String getGuardianSchedule(int id) =>
      '${subUrl}guardian/children/$id/timetable';
  static const updateEducationalContent = '${subUrl}educational-contents';

  static const createHomework = '${subUrl}teacher/homeworks';

  static const String galleries = 'landing/galleries';
  static String galleryDetails(int id) => 'landing/galleries/$id';

  static const String news = 'landing/news';

  static const String teacherExams = '${subUrl}teacher/exams';
  static const String teacherExamsGrades = '${subUrl}teacher/exams/grades';

  static const addAttendance = '${subUrl}teacher/attendance';
  static const getAttendance = '${subUrl}teacher/attendance';

  static const String getStudentHomeworks = '${subUrl}student/homeworks';
  static const String getChildHomeworksBase = '${subUrl}guardian/children';
  static const getBehaviors = '${subUrl}guardian/behaviors';

  static String getChildSubjectGrades(int childId, int subjectId) =>
      "$getGradeChildren/grades/subject/$childId/$subjectId";

  static String getChildGrades(int childId) =>
      "$getGradeChildren/$childId/grades";
}
