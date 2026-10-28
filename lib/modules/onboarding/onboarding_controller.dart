import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/local_storage.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  PageController pageController = PageController();

  List<Map<String, String>> pages = [
    {
      "image": "assets/images/edufyPic1.jpg",
      "title": "! Edufy اهلا بك في",
      "desc": "تطبيقك الشامل لإدارة العملية التعليمية بكل سهولة ويسر",
    },
    {
      "image": "assets/images/edufyPic2.png",
      "title": "تابع أخبار مدرستك من أي مكان ",
      "desc": "تابع دروسك في أي وقت ومكان وراقب الاخبار التعليمية ",
    },
    {
      "image": "assets/images/edufyPic3.png",
      "title": "تتبع تقدمك",
      "desc":
          "ابقَ على اطلاع دائم على فيديوهات معلميك الدراسية ونشرها في حال كنت معلم",
    },
    {
      "image": "assets/images/edufyPic4.png",
      "title": "ادارة دروسك ودرجاتك والمواعيد الامتحانية",
      "desc": "كن على اطلاع دائم بجدولك الدراسي ودرجاتك ومواعيد الامتحانات ",
    },
    {
      "image": "assets/images/edufyPic5.png",
      "title": "سجل دخولك للتطبيق بمهمتك الدراسية",
      "desc":
          "اذا كنت معلم , طالب او والد طالب سجل بحسابك المدرسي لمراقبة مهامك ",
    },
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      finishOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void finishOnboarding() async {
    LocalStorage storage = LocalStorage();
    await storage.save('onboarding_done', true);
    Get.offAllNamed('/login');
  }
}
