class NewsModel {
  final int? status;
  final String? message;
  final List<NewsData>? data;
  final PaginationModel? pagination;

  NewsModel({this.status, this.message, this.data, this.pagination});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] != null
          ? List<NewsData>.from(json["data"].map((x) => NewsData.fromJson(x)))
          : null,
      pagination: json["pagination"] != null
          ? PaginationModel.fromJson(json["pagination"])
          : null,
    );
  }
}

class NewsDetailsModel {
  final int? status;
  final String? message;
  final NewsData? data;

  NewsDetailsModel({this.status, this.message, this.data});

  factory NewsDetailsModel.fromJson(Map<String, dynamic> json) {
    return NewsDetailsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] != null ? NewsData.fromJson(json["data"]) : null,
    );
  }
}

class NewsData {
  final int? id;
  final String? title;
  final String? slug;
  final String? summary;
  final String? content;
  final String? image;
  final String? category;
  final String? eventDate;
  final String? publishDate;
  final int? views;
  final bool? isActive;

  NewsData({
    this.id,
    this.title,
    this.slug,
    this.summary,
    this.content,
    this.image,
    this.category,
    this.eventDate,
    this.publishDate,
    this.views,
    this.isActive,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      id: json["id"],
      title: json["title"],
      slug: json["slug"],
      summary: json["summary"],
      content: json["content"],
      image: json["image"],
      category: json["category"],
      eventDate: json["event_date"],
      publishDate: json["publish_date"],
      views: json["views"],
      isActive: json["is_active"],
    );
  }
}

class PaginationModel {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final bool? hasMorePages;

  PaginationModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.hasMorePages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      total: json["total"],
      hasMorePages: json["has_more_pages"],
    );
  }
}