import 'package:edufy/models/schedule/schedule.dart';

class ScheduleModel {
  final String message;
  final int status;
  final List<Schedule> data;

  ScheduleModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      message: json["message"]?.toString() ?? "",
      status: json["status"] is int
          ? json["status"]
          : int.tryParse(json["status"].toString()) ?? 0,
      data: json["data"] is List
          ? (json["data"] as List)
                .map((item) => Schedule.fromJson(item))
                .toList()
          : [],
    );
  }
}
