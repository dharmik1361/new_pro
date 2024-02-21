// import 'dart:convert';
//
// List<Desc> descFromJson(String str) => List<Desc>.from(json.decode(str).map((x) => Desc.fromJson(x)));
//
// String descToJson(List<Desc> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class Desc {
//   int? id;
//   int? newsId;
//   int? languageId;
//   List<DescDescription>? description; // Use an alias for Description
//   Language? language;
//
//   Desc({
//     this.id,
//     this.newsId,
//     this.languageId,
//     this.description,
//     this.language,
//   });
//
//   factory Desc.fromJson(Map<String, dynamic> json) => Desc(
//     id: json["id"],
//     newsId: json["news_id"],
//     languageId: json["language_id"],
//     description: json["description"] != null ? List<DescDescription>.from(json["description"].map((x) => DescDescription.fromJson(x))) : null,
//     language: json["language"] == null ? null : Language.fromJson(json["language"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "news_id": newsId,
//     "language_id": languageId,
//     "description": description != null ? List<dynamic>.from(description!.map((x) => x.toJson())) : null,
//     "language": language?.toJson(),
//   };
// }
//
// class DescDescription {
//   int? id;
//   int? languageId;
//   String? description;
//
//   DescDescription({
//     this.id,
//     this.languageId,
//     this.description,
//   });
//
//   factory DescDescription.fromJson(Map<String, dynamic> json) => DescDescription(
//     id: json["id"],
//     languageId: json["language_id"],
//     description: json["description"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "language_id": languageId,
//     "description": description,
//   };
// }
//
// class Language {
//   int? id;
//   String? title;
//
//   Language({
//     this.id,
//     this.title,
//   });
//
//   factory Language.fromJson(Map<String, dynamic> json) => Language(
//     id: json["id"],
//     title: json["title"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "title": title,
//   };
// }
