// To parse this JSON data, do
//
//     final catIdAnimal = catIdAnimalFromJson(jsonString);

import 'dart:convert';

CatIdAnimal catIdAnimalFromJson(String str) => CatIdAnimal.fromJson(json.decode(str));

String catIdAnimalToJson(CatIdAnimal data) => json.encode(data.toJson());

class CatIdAnimal {
  bool? success;
  String? message;
  String? data;

  CatIdAnimal({
    this.success,
    this.message,
    this.data,
  });

  factory CatIdAnimal.fromJson(Map<String, dynamic> json) => CatIdAnimal(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data,
  };
}
