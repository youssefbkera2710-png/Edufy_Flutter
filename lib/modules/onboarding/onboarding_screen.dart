import 'package:edufy/modules/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.pages.length,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              var page = controller.pages[index];

              return Stack(
                children: [
                  // 🔹 الصورة
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(page['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // 🔹 طبقة غامقة
                  Container(color: Colors.black.withOpacity(0.4)),

                  // 🔹 النصوص
                  Positioned(
                    bottom: 150,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        Text(
                          page['title']!,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          page['desc']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // 🔹 أزرار + مؤشر
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Obx(() {
              return Column(
                children: [
                  // 🔸 المؤشر (dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.pages.length,
                      (index) => Container(
                        margin: EdgeInsets.all(4),
                        width: controller.currentPage.value == index ? 12 : 8,
                        height: controller.currentPage.value == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index
                              ? Colors.white
                              : Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.currentPage.value == 0
                          ? SizedBox(width: 80)
                          : ElevatedButton(
                              onPressed: controller.previousPage,
                              child: Text("السابق"),
                            ),

                      ElevatedButton(
                        onPressed: controller.nextPage,
                        child: Text(
                          controller.currentPage.value ==
                                  controller.pages.length - 1
                              ? "ابدأ"
                              : "التالي",
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
