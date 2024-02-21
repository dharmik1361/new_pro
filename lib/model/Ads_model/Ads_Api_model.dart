// To parse this JSON data, do
//
//     final Ads = AdsFromJson(jsonString);

import 'dart:convert';

Ads AdsFromJson(String str) => Ads.fromJson(json.decode(str));

String AdsToJson(Ads data) => json.encode(data.toJson());

class Ads {
  bool? success;
  String? data;

  Ads({
    this.success,
    this.data,
  });

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
        success: json["success"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
      };
}
