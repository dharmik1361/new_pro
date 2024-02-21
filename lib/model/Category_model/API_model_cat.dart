// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Category categoriesFromJson(String str) => Category.fromJson(json.decode(str));

String categoriesToJson(Category data) => json.encode(data.toJson());

class Category {
  bool? success;
  Data? data;

  Category({
    this.success,
    this.data,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  String? categories;
  String? animalIds;

  Data({
    this.categories,
    this.animalIds,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: json["categories"],
    animalIds: json["animal_ids"],
  );

  Map<String, dynamic> toJson() => {
    "categories": categories,
    "animal_ids": animalIds,
  };
}
