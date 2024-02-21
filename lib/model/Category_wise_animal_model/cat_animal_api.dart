import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_model.dart';

class AnimalByCat {
  Future<CatIdAnimal> fetchCatAnimalData(int CatId) async {
    final animalUrl =
        "https://atharvainfinity.com/did-you-know/public/api/v1/animal/catbyid/$CatId";
    final headers = {
      'X-API-KEY':
          'dsfasdgadfgadfgsfdghfdshdfhdgfhjgdfjdghjdhgjgdhfjgdhjdghjsgfhjgsf',
    };

    final response = await http.get(
      Uri.parse(animalUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      return catIdAnimalFromJson(responseBody);
    } else {
      throw Exception(
          "Failed to load animal data. Status Code: ${response.statusCode}");
    }
  }

  String decodeBase64(String base64Data) {
    final decodeBytes = base64.decode(base64Data);
    final decodeString = utf8.decode(decodeBytes);
    return decodeString;
  }
}
