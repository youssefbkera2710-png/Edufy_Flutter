import 'gallery.dart';

class GalleryPaginationModel {
  final String? message;
  final int? status;
  final List<GalleryModel>? data;
  final PaginationInfo? pagination;

  GalleryPaginationModel({
    this.message,
    this.status,
    this.data,
    this.pagination,
  });

  factory GalleryPaginationModel.fromJson(Map<String, dynamic> json) {
    return GalleryPaginationModel(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => GalleryModel.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class PaginationInfo {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;
  final bool? hasMorePages;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginationInfo({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
    this.hasMorePages,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      hasMorePages: json['has_more_pages'] as bool?,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}