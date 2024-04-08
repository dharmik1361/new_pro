import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../database/db_helper.dart';
import '../../model/Category_wise_animal_model/api_model.dart';
import '../../model/Category_wise_animal_model/cat_animal_api.dart';
import '../../model/Category_wise_animal_model/cat_model.dart';

class ForestController extends GetxController {
  final AnimalByCat contro = AnimalByCat();
  CatIdAnimal? catIdAnimal;
  String decodedcat = "";
  final int catId;
  final Uint8List Image;

  ForestController({required this.catId, required this.Image});

  @override
  void onInit() {
    _refreshData();
    super.onInit();
  }

  Future<void> fetchData(int catId) async {
    try {
      final categories = await contro.fetchCatAnimalData(catId);
      catIdAnimal = categories;
      decode();
    } catch (e) {
      print("Error $e");
    }
  }

  void decode() async {
    if (catIdAnimal != null) {
      final Categories = catIdAnimal!.data;
      if (Categories != null) {
        final decodedCategory = contro.decodeBase64(Categories);
        if (decodedCategory.isNotEmpty) {
          try {
            final List<dynamic> decodecatList = json.decode(decodedCategory);
            categories.value =
                decodecatList.map((json) => CatId.fromJson(json)).toList();
          } catch (e) {
            print("Error decoding JSON: $e");
          }
        }
      } else {
        print("Categories is null");
      }
    } else {
      print("widget.catIdAnimal is null");
    }
  }

  Future<void> fetchcatDataList(int catId) async {
    try {
      String table = 'forest';
      List<CatId> allAnimals = categories;
      int animalCount = allAnimals.length;
      int loadedCount = 0;

      for (int i = 0; i < animalCount; i++) {
        if (!await DbHelper.dbHelper
            .doesAnimalDataExist(allAnimals[i].id ?? 0, table)) {
          final CatIdAnimal catIdAnimal =
              await contro.fetchCatAnimalData(catId);

          if (catIdAnimal.success == true) {
            final String decodedData = contro.decodeBase64(catIdAnimal.data!);

            final List<dynamic> jsonData = json.decode(decodedData);

            final List<CatId> catDataList =
                jsonData.map((json) => CatId.fromJson(json)).toList();

            print("animal $catId decoded data ${jsonEncode(catDataList)}");
            print(animalCount);

            Uint8List imageBytes = (await NetworkAssetBundle(
                        Uri.parse(allAnimals[i].storyImage ?? ""))
                    .load(allAnimals[i].storyImage ?? ""))
                .buffer
                .asUint8List();

            print(imageBytes);
            ID.value = allAnimals[i].id ?? 1;
            String title = allAnimals[i].title ?? "";
            print(title);
            print(ID);
            String description = allAnimals[i].description?.isNotEmpty == true
                ? allAnimals[i].description![0].description ?? ""
                : "";
            print(description);

            DateTime now = DateTime.now().add(const Duration(days: -1));
            String formattedDate = DateFormat('yyyy-MM-dd').format(now);

            print('Current Date: $formattedDate');

            int descCount = allAnimals[i].description?.length ?? 1;

            for (int j = 0; j < descCount; j++) {
              int Id = allAnimals[i].id ?? 1;

              String des = allAnimals[i].description?.isNotEmpty == true
                  ? allAnimals[i].description![j].description ?? ""
                  : "";
              String lanname =
                  allAnimals[i].description![j].language?.title ?? "";
              int lanId = allAnimals[i].description![j].languageId ?? 1;
              print(des);
              print(lanId);
              print(lanname);

              await DbHelper.dbHelper
                  .insertDescriptionData(Id, lanId, lanname, des);
            }

            DbHelper.dbHelper.insertForestData(
                catId, ID.value, imageBytes, title, formattedDate);
            progressBarValue.value = ((i + 1) / animalCount * 100).toInt();
            update();
            loadedCount++;
          } else {
            print("error");
          }
        } else {
          print(
              "Animal data for ID ${allAnimals[i].id} or CatId $catId already exists in the database. Skipping fetch.");
          loadedCount++;
        }
      }
      isDataLoaded(true); // Mark data as loaded
      print(isDataLoaded);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _refreshData() async {
    isDataLoaded.value = false;
    progressBarValue.value = 0;
    await fetchData(catId);
    await fetchcatDataList(catId);
    isDataLoaded.value = true;
    update();
  }



  void Datbaseimage() async {
    forestImage = await DbHelper.dbHelper.getForestImageData(catId);
    update();
  }

  Future<void> updateForestDate(int ID, Function? onAdComplete) async {
    await DbHelper.dbHelper.updateForestDate(
      ID,
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    // Check if the ad completion callback is provided
    if (onAdComplete != null) {
      // Call the ad completion callback
      onAdComplete();
    }

    // Refresh the screen
    update();
  }

  void changeLanguage(int newLanId) {
    DLanId.value = newLanId;
    update();
  }

  void Dragimage(Uint8List? imageBytes, String title, String description,
      int DesId) async {
    droppedImage.value = imageBytes;
    droppedTitle.value = title;
    droppedDescription.value = description;
    desc.value = await DbHelper.dbHelper.getDescriptionData(DesId);
    update();
  }


  final categories = List<CatId>.empty().obs;
  final droppedImage = Rx<Uint8List?>(null);
  final droppedTitle = Rx<String>("");
  List<Map<String, dynamic>> forestImage = [];
  final desc = Rx<List<Map<String, dynamic>>>([]);
  final droppedDescription = Rx<String>("");
  final date = Rx<String>("");
  final Descrip = Rx<String>("");
  final isDataLoaded = false.obs;
  final progressBarValue = 0.obs;
  final LanId = 0.obs;
  final DLanId = 0.obs;
  final descri = Rx<String>("").obs;
  final ID = 0.obs;
  final selectedDescription = "".obs;
  final isAlgContainerVisible = false.obs;
  final isIconVisible = false.obs;
}
