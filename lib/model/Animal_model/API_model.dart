// To parse this JSON data, do
//
//     final animal = animalFromJson(jsonString);

import 'dart:convert';

Animal animalFromJson(String str) => Animal.fromJson(json.decode(str));

String animalToJson(Animal data) => json.encode(data.toJson());

class Animal {
  bool? success;
  String? message;
  String? data;

  Animal({
    this.success,
    this.message,
    this.data,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
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
