// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_pro/database/db_helper.dart';
import 'package:new_pro/model/Animal_model/API_model.dart';
import 'package:new_pro/view/theme_select_page.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../controller/API_Controller/Category_api.dart';
import '../model/Category_model/API_model_cat.dart';
import '../model/Category_model/Category_model_data.dart';

class Home extends StatefulWidget {
  final CategoryController controller = CategoryController();

  Category? categories;

  String decodedCategories = "";

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryData> categoryDataList = [];
  int progressBarValue = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDataAndNavigate();
    statusbar();
    cateImage();
  }

  void statusbar() async {
    await StatusBarControl.setHidden(true, animation: StatusBarAnimation.SLIDE);
  }

  void cateImage() async {
    for (int catId = 0; catId <= 5; catId++) {
      CategoryData? categoryToDisplay =
          categoryDataList.firstWhereOrNull((category) => category.id == catId);

      if (categoryToDisplay != null) {
        String bigImage = categoryToDisplay.bigImage;
        String smallImage = categoryToDisplay.smallImage;
        print("CategoryData with catId $catId: $bigImage");
        print("cate $catId: $smallImage");
      } else {
        print("CategoryData with catId $catId not found");
      }
    }
  }

  Future<bool> fetchDataAndNavigate() async {
    String table = "category";

    try {
      for (int catId = 0; catId <= 5; catId++) {
        bool isDataExists =
            await DbHelper.dbHelper.doesCategoryDataExist(catId, table);
        if (!isDataExists) {
          // Fetch and process data only if it doesn't exist in the database
          final Category category =
              await widget.controller.fetchCategoryData(catId);

          if (category.success == true) {
            final String decodedData =
                widget.controller.decodeBase64(category.data?.categories ?? "");
            final List<dynamic> jsondata = json.decode(decodedData);

            final List<CategoryData> categoryDataList =
                jsondata.map((json) => CategoryData.fromJson(json)).toList();

            Uint8List CatImg = (await NetworkAssetBundle(
                        Uri.parse(categoryDataList[catId].smallImage))
                    .load(categoryDataList[catId].smallImage))
                .buffer
                .asUint8List();
            String title = categoryDataList[catId].categoryName;

            DateTime now = DateTime.now().add(const Duration(days: -1));
            String formattedDate = DateFormat('yyyy-MM-dd').format(now);

            print('Current Date: $formattedDate');

            DbHelper.dbHelper
                .insertCategoryData(catId, title, CatImg, formattedDate);

            setState(() {
              progressBarValue = (catId / 5 * 100).toInt();
            });

            print(
                "Category $catId decoded big image: ${categoryDataList[catId].smallImage}");
          } else {
            print(
                "Failed to fetch category data for ID $catId. Message: ${category.data}");
            return false; // Data loading failed
          }
        }
      }
      setState(() {
        isLoading = true;
      });
      return true; // Data loaded successfully
    } catch (e) {
      print("Error fetching category data: $e");
      return false;
    }
  }

  void exitApp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffF1DEBE),
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                exit(0); // Exit the app
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        exitApp();
      },
      child: Scaffold(
        body: Stack(
          children: [
            const Image(
              image: AssetImage("assets/Home/BG.png"),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 350,
                width: 700,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Informative Game",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                      SizedBox(
                        height: 20,
                      ),
                    if (isLoading)
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnimalSelect(),));
                      },
                      child: Container(
                        height: 120,
                        width: 260,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Home/Play.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "PLAY",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if(!isLoading)
                    Visibility(
                      visible: !isLoading,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,
                          width: 320,
                          child: Column(
                            children: [
                              const Text(
                                "Assets Download",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              LinearProgressIndicator(
                                value: progressBarValue / 100,
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
