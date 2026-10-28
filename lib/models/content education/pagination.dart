class PaginationModel {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;
  bool? hasMorePages;
  String? nextPageUrl;
  String? prevPageUrl;

  PaginationModel({
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

  // التحويل من JSON إلى Object
  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
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