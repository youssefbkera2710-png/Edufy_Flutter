import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/schedule/schedule.dart';
import 'package:edufy/modules/my%20schedule/my_schedule_controller.dart';
import 'package:edufy/modules/my%20schedule/widgets/details_session_card.dart';
import 'package:edufy/modules/my%20schedule/widgets/empty_schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleDayDetailsScreen extends StatelessWidget {
  final String day;
  final bool isToday;
  final List<Schedule> items;
  final ScheduleController controller;
  final int? divisionNumber ;

  const ScheduleDayDetailsScreen({
    super.key,
    required this.day,
    required this.isToday,
    required this.items,
    required this.controller,
    this.divisionNumber
  });

  @override
  Widget build(BuildContext context) {
    final sortedItems = [...items]
      ..sort((a, b) => (a.sessionNumber ?? 0).compareTo(b.sessionNumber ?? 0));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppString.myScheduleTitle,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: sortedItems.isEmpty
            ? const EmptyScheduleState()
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sortedItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12.0),
          itemBuilder: (context, index) {
            return DetailsSessionCard(
              item: sortedItems[index],
              index: index,
              controller: controller,
              divisionNumber: divisionNumber,
            );
          },
        ),
      ),
    );
  }
}