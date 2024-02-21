import 'dart:convert';

import 'package:get/get.dart';
import 'package:new_pro/model/Category_wise_animal_model/cat_animal_api.dart';

import '../../model/Category_wise_animal_model/api_model.dart';
import '../../model/Category_wise_animal_model/cat_model.dart';

class APIHelper extends GetxController {
  final AnimalByCat AC = AnimalByCat();
  CatIdAnimal? catIdAnimal;
  String decodedCategories = "";
  RxList<CatId> categoryDataList = <CatId>[].obs;

  static APIHelper get to => Get.find<APIHelper>(); // Update this line

  APIHelper._();

  static void init() {
    Get.put<APIHelper>(APIHelper._());
  }

  Future<void> fetchData(int cId) async {
    try {
      final cat = await AC.fetchCatAnimalData(cId);
      catIdAnimal = cat;

      if (cat.data != null) {
        // Decode categories and update the list
        decodedCategories = AC.decodeBase64(cat.data!);
        updateCategoryList();
      } else {
        print("Error: cat.data is null");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void updateCategoryList() {
    if (decodedCategories != null && decodedCategories.isNotEmpty) {
      try {
        final List<dynamic> decodedCategoryList =
            json.decode(decodedCategories);
        categoryDataList.assignAll(
            decodedCategoryList.map((json) => CatId.fromJson(json)).toList());
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("JSON data is empty or malformed.");
    }
  }

  Future<List<CatId>> fetchCatData() async {
    try {
      final CatIdAnimal catIdAnimal = await AC.fetchCatAnimalData(1);

      if (catIdAnimal.success == true) {
        final String? decodedData = catIdAnimal.data;

        if (decodedData != null) {
          final List<dynamic> jsonData = jsonDecode(decodedData);

          final List<CatId> catIdList =
          jsonData.map((json) => CatId.fromJson(json)).toList();

          print("Cat Decoded data ${jsonEncode(catIdList)}");

          return catIdList;
        } else {
          print("Error: catIdAnimal.data is null");
          // You may want to throw an exception or return a default value here.
        }
      }

    } catch (e) {
      print("Error fetching cat data: $e");
    }

    // Return an empty list in case of an error or missing data
    return [];
  }

}
