class CategoryData {
  final int id;
  final int categoryOrder;
  final String categoryName;
  final String categoryImage;
  final String createdAt;
  final String updatedAt;
  final String bigImage;
  final String smallImage;

  CategoryData({
    required this.id,
    required this.categoryOrder,
    required this.categoryName,
    required this.categoryImage,
    required this.createdAt,
    required this.updatedAt,
    required this.bigImage,
    required this.smallImage,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'],
      categoryOrder: json['category_order'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      bigImage: json['big_image'],
      smallImage: json['small_image'],
    );
  }
}
