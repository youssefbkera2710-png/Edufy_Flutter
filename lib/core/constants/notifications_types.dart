class NotificationTypes {
  static const newExams = 'new_exam'; // اختبار جديد للطلاب واولياء الامور
  static const holiday = 'holiday'; //عطلة رسمية
  static const absenceRequest =
      'absence_request'; // عندي التقديم من الاب او الرفض او القبول بيوصل
  static const alterationTeacher =
      'substitute'; // بيوصل اشعار للمعلم الاصلي والمعلم البديل
  static const contentFromTeacher =
      'new_content'; // اضافة محنوى تعليمي للطلاب والاباء بظهر
  static const newHomework =
      'new_homework'; // عند اضافة واجب منزلي يظهر للاباء والطلاب
  static const studentPromoted = 'student_promoted'; // ترقية طالب
  static const feeReminder =
      'fee_reminder'; // تسديد فاتورة بقسم المصاريف الكلية للاب وفانورة بدا دفع بقسم الابناء لكل ابن لحال
  static const gradeForSubject =
      'grade_entered'; // لما تنزل درجة لمادة ما بيوصل للاب والطالب
  static const newCommentOrReply =
      'content_comment'; // حدا ضاف كومنت ع محتوى الاستاذ بيوصل للاستاذ او قام حدا بالرد ع نعليقي
  static const popGeneral = 'general_announcement';
  static const feePaymentConfirmation = 'fee_payment_confirmation';
}
