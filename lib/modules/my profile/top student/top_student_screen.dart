import 'package:edufy/components/wave_header.dart';
import 'package:edufy/modules/my%20profile/top%20student/top_student_controller.dart';
import 'package:edufy/modules/my%20profile/top%20student/widgets/banner_student.dart';
import 'package:edufy/modules/my%20profile/top%20student/widgets/build_body_top_student.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopStudentsScreen extends StatelessWidget {
  const TopStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopStudentsController());

    return Scaffold(
      appBar: WaveHeader(context, ' الطلاب المتميزين', showButtonTheme: false),
      body: Column(
        children: [
          BannerStudent(),
          Expanded(child: BuildBodyTopStudent()),
        ],
      ),
    );
  }
}
