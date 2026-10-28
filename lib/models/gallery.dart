class GalleryModel {
  final int? id;
  final String? title;
  final String? description;
  final String? coverImage;
  final String? createdAt;
  final List<GalleryImage>? images;

  GalleryModel({
    this.id,
    this.title,
    this.description,
    this.coverImage,
    this.createdAt,
    this.images,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      createdAt: json['created_at'] as String?,
      images: json['images'] != null
          ? (json['images'] as List)
          .map((i) => GalleryImage.fromJson(i as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover_image': coverImage,
      'created_at': createdAt,
      'images': images?.map((i) => i.toJson()).toList(),
    };
  }
}

class GalleryImage {
  final int? id;
  final String? imagePath;
  final String? caption;
  final int? sortOrder;
  final String? createdAt;

  GalleryImage({
    this.id,
    this.imagePath,
    this.caption,
    this.sortOrder,
    this.createdAt,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'] as int?,
      imagePath: json['image_path'] as String?,
      caption: json['caption'] as String?,
      sortOrder: json['sort_order'] as int?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'caption': caption,
      'sort_order': sortOrder,
      'created_at': createdAt,
    };
  }
}