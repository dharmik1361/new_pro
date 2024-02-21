import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/Ads_model/Ads_Api_model.dart';


class AdsController {
  Future<Ads> AdsfetchData() async {
    const url =
        "https://atharvainfinity.com/did-you-know/public/api/v1/advertisement";

    final headers = {
      'X-API-KEY':
      'dsfasdgadfgadfgsfdghfdshdfhdgfhjgdfjdghjdhgjgdhfjgdhjdghjsgfhjgsf',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if(response.statusCode == 200){
      final responsebody = response.body;
      return AdsFromJson(responsebody);
    }else{
      throw Exception("Failed to load data Status Code: ${response.statusCode}");
    }
  }

  String decodeBase64(String base64Data) {
    final decodeBytes = base64.decode(base64Data);
    final decodeString = utf8.decode(decodeBytes);
    return decodeString;
  }
}
