// To parse this JSON data, do
//
//     final CatId = CatIdFromJson(jsonString);

import 'dart:convert';

List<CatId> CatIdFromJson(String str) => List<CatId>.from(json.decode(str).map((x) => CatId.fromJson(x)));

String CatIdToJson(List<CatId> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CatId {
  int? id;
  int? order;
  int? catId;
  String? title;
  String? storyImage;
  CategoryName? categoryName;
  List<Description>? description;

  CatId({
    this.id,
    this.order,
    this.catId,
    this.title,
    this.storyImage,
    this.categoryName,
    this.description,
  });

  factory CatId.fromJson(Map<String, dynamic> json) => CatId(
    id: json["id"],
    order: json["order"],
    catId: json["cat_id"],
    title: json["title"],
    storyImage: json["story_image"],
    categoryName: categoryNameValues.map[json["category_name"]],
    description: List<Description>.from(json["description"].map((x) => Description.fromJson(x))),  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order": order,
    "cat_id": catId,
    "title": title,
    "story_image": storyImage,
    "category_name": categoryNameValues.reverse[categoryName],
    "description": description == null ? [] : List<dynamic>.from(description!.map((x) => x.toJson())),
  };
}

enum CategoryName {
  FORESTS
}

final categoryNameValues = EnumValues({
  "Forests": CategoryName.FORESTS
});

class Description {
  int? id;
  int? newsId;
  int? languageId;
  String? description;
  Language? language;

  Description({
    this.id,
    this.newsId,
    this.languageId,
    this.description,
    this.language,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
    id: json["id"],
    newsId: json["news_id"],
    languageId: json["language_id"],
    description: json["description"],
    language: json["language"] == null ? null : Language.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "news_id": newsId,
    "language_id": languageId,
    "description": description,
    "language": language?.toJson(),
  };
}

class Language {
  int? id;
  String? title;

  Language({
    this.id,
    this.title,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
