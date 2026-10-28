import 'dart:convert';

NotificationsResponse notificationsResponseFromJson(String str) =>
    NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) =>
    json.encode(data.toJson());

class NotificationsResponse {
  final String message;
  final List<NotificationItem> data;
  final Pagination? pagination;
  final int status;

  NotificationsResponse({
    required this.message,
    required this.data,
    this.pagination,
    required this.status,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    List<NotificationItem> notificationList = [];

    if (json['data'] is List) {
      notificationList = (json['data'] as List)
          .map((item) => NotificationItem.fromJson(item))
          .toList();
    } else if (json['data'] is Map && json['data']['data'] is List) {
      // للتوافق مع الشكل القديم
      notificationList = (json['data']['data'] as List)
          .map((item) => NotificationItem.fromJson(item))
          .toList();
    }

    return NotificationsResponse(
      message: json['message'] ?? '',
      data: notificationList,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      status: json['status'] ?? 200,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination?.toJson(),
    'status': status,
  };
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String notificationType;
  final bool isRead;
  final String? readAt;
  final DateTime createdAt;
  final String? navigateTo;
  final Map<String, dynamic>? meta;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.notificationType,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.navigateTo,
    this.meta,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      notificationType: json['notification_type'] ?? 'general',
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      navigateTo: json['navigate_to'],
      meta: json['meta'] is Map
          ? Map<String, dynamic>.from(json['meta'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'notification_type': notificationType,
    'is_read': isRead,
    'read_at': readAt,
    'created_at': createdAt.toIso8601String(),
    'navigate_to': navigateTo,
    'meta': meta,
  };
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;
  final bool hasMorePages;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    required this.hasMorePages,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      hasMorePages: json['has_more_pages'] ?? false,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
    'from': from,
    'to': to,
    'has_more_pages': hasMorePages,
    'next_page_url': nextPageUrl,
    'prev_page_url': prevPageUrl,
  };
}
