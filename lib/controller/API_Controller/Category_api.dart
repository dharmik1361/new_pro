import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/Animal_model/API_model.dart';
import '../../model/Category_model/API_model_cat.dart';

class CategoryController {
  Future<Category> fetchCategoryData(int catId) async {
    const categoryUrl = "https://atharvainfinity.com/did-you-know/public/api/v1/category";
    final headers = {
      'X-API-KEY': 'dsfasdgadfgadfgsfdghfdshdfhdgfhjgdfjdghjdhgjgdhfjgdhjdghjsgfhjgsf',
    };

    final response = await http.get(
      Uri.parse(categoryUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      return categoriesFromJson(responseBody);
    } else {
      throw Exception("Failed to load category data. Status Code: ${response.statusCode}");
    }
  }

  Future<Animal> fetchAnimalData(int animalId) async {
    final animalUrl = "https://atharvainfinity.com/did-you-know/public/api/v1/animal/$animalId";
    final headers = {
      'X-API-KEY': 'dsfasdgadfgadfgsfdghfdshdfhdgfhjgdfjdghjdhgjgdhfjgdhjdghjsgfhjgsf',
    };

    final response = await http.get(
      Uri.parse(animalUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      return animalFromJson(responseBody);
    } else {
      throw Exception("Failed to load animal data. Status Code: ${response.statusCode}");
    }
  }

  String decodeBase64(String base64Data) {
    final decodeBytes = base64.decode(base64Data);
    final decodeString = utf8.decode(decodeBytes);
    return decodeString;
  }
}
