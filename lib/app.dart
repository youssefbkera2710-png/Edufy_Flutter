import 'package:edufy/bindings/app_binding.dart';
import 'package:edufy/modules/auth/forget%20password/forgot_password_screen.dart';
import 'package:edufy/modules/auth/login/login_screen.dart';
import 'package:edufy/modules/auth/otp%20password/otp_password_screen.dart';
import 'package:edufy/modules/auth/reset%20password/reset_password_screen.dart';
import 'package:edufy/modules/class/class_screen.dart';
import 'package:edufy/modules/dashbord/dashbord_screen.dart';
import 'package:edufy/modules/education%20content/educational_details_screen.dart';
import 'package:edufy/modules/exams/exam_details_screen.dart';
import 'package:edufy/modules/exams/exam_teacher_screen.dart';
import 'package:edufy/modules/grade/grade_guardian/guardian_grades_screen.dart';
import 'package:edufy/modules/grade/grade_student/grade_screen.dart';
import 'package:edufy/modules/home/guardian/absence_request_screen.dart';
import 'package:edufy/modules/home/guardian/daily_attendance_screen.dart';
import 'package:edufy/modules/exams/exam_guardian_student_screen.dart';
import 'package:edufy/modules/home/guardian/invoices_screen.dart';
import 'package:edufy/modules/home/guardian/payments_history_screen.dart';
import 'package:edufy/modules/homework/homework_detail_screen.dart';
import 'package:edufy/modules/homework/homework_teacher_screen.dart';
import 'package:edufy/modules/my%20profile/change%20password/change_password_screen.dart';
import 'package:edufy/modules/my%20profile/edit%20profile/edit_profile_screen.dart';
import 'package:edufy/modules/onboarding/onboarding_screen.dart';
import 'package:edufy/modules/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:responsive_s/responsive_s.dart';
import 'core/constants/app_frame_constants.dart';
import 'core/shared/managers/themes_manager/text_theme_manager/custom_text_theme.dart';
import 'core/shared/managers/themes_manager/themes_manager.dart';
import 'modules/News/news_details_screen.dart';
import 'modules/News/news_list_screen.dart';
import 'modules/gallery/galleries_list_screen.dart';
import 'modules/gallery/gallery_details_screen.dart';

class App extends StatelessWidget {
  App._internal();

  static final App instance = App._internal();
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return ColorManager(
      child: ResponsiveWrapper(
        frame: Frame(
          desktopFrame: AppFrameConstants.desktop,
          tabletPortraitFrame: AppFrameConstants.tablet,
          mobilePortraitFrame: AppFrameConstants.mobile,
        ),
        child: ResponsiveWidget(
          builder: (sizer) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Edufy',
            locale: Locale("ar"),
            initialBinding: AppBinding(),
            theme: ThemesManager.lightTheme(CustomTextTheme(sizer: sizer)),
            darkTheme: ThemesManager.darkTheme(CustomTextTheme(sizer: sizer)),
            themeMode: themeController.isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/splash',
            getPages: [
              GetPage(name: '/splash', page: () => SplashScreen()),
              GetPage(name: '/onboarding', page: () => OnboardingScreen()),
              GetPage(name: '/dashboard', page: () => DashboardScreen()),
              GetPage(name: '/login', page: () => LoginScreen()),
              GetPage(
                name: '/forgotPasswordScreen',
                page: () => ForgotPasswordScreen(),
              ),
              GetPage(
                name: '/OtpPasswordScreen',
                page: () => OtpPasswordScreen(),
              ),
              GetPage(
                name: '/reset-password',
                page: () => ResetPasswordScreen(),
              ),
              GetPage(name: '/editProfile', page: () => EditProfileScreen()),
              GetPage(
                name: '/changePassword',
                page: () => ChangePasswordScreen(),
              ),
              GetPage(name: '/classHistoryScreen', page: () => ClassScreen()),
              GetPage(name: '/gradeScreen', page: () => GradesScreen()),
              GetPage(
                name: '/gradeGuardianScreen',
                page: () => GuardianGradesScreen(),
              ),

              GetPage(
                name: '/galleriesListScreen',
                page: () => const GalleriesListScreen(),
              ),
              GetPage(
                name: '/galleryDetailsScreen',
                page: () => const GalleryDetailsScreen(),
              ),

              GetPage(
                name: '/newsListScreen',
                page: () => const NewsListScreen(),
              ),
              GetPage(
                name: '/newsDetailsScreen',
                page: () => const NewsDetailsScreen(),
              ),
              GetPage(
                name: '/AbsenceRequestsPage',
                page: () => AbsenceRequestsPage(),
              ),
              GetPage(
                name: '/DailyAttendanceScreen',
                page: () => DailyAttendanceScreen(),
              ),
              GetPage(
                name: '/EducationalDetailsScreen',
                page: () => EducationalDetailsScreen(),
              ),
              GetPage(
                name: '/ExamGuardianStudent',
                page: () => ExamGuardianStudent(),
              ),
              GetPage(
                name: '/paymentsHistoryScreen',
                page: () => PaymentsHistoryScreen(),
              ),
              GetPage(
                name: '/TeacherExamsScreen',
                page: () => TeacherExamsScreen(),
              ),
              GetPage(
                name: '/ExamDetailScreen',
                page: () => ExamDetailScreen(),
              ),
              GetPage(
                name: '/HomeworkDetailScreen',
                page: () => HomeworkDetailScreen(),
              ),
              GetPage(
                name: '/TeacherHomeworkScreen',
                page: () => TeacherHomeworkScreen(),
              ),
              GetPage(name: '/InvoicesScreen', page: () => InvoicesScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
