import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_pro/database/db_helper.dart';
import 'package:new_pro/view/Animal_Pages/Forest_Page.dart';

import '../view/Ads/admob.dart';

class AnimalSelectController extends GetxController {
  final RxList<Map<String, dynamic>> catImage = <Map<String, dynamic>>[].obs;
  final AdManager _adManager = AdManager();

  @override
  void onInit() {
    super.onInit();
    // _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();
    CatData();
  }

  void CatData() async {
    catImage.assignAll(await DbHelper.dbHelper.getCatImageData());
  }

  void onTap(int index) async {
    final Uint8List image = catImage[index]['image4'];
    final int id = catImage[index]['catId'];
    final String date = catImage[index]['Date'];

    if (date != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      _adManager.showRewardedAd();
      DbHelper.dbHelper.updateCateDate(id, DateFormat('yyyy-MM-dd').format(DateTime.now()));
      CatData(); // Refresh the data
    } else {
      int modifiedId = catImage[index]['catId'] + 1;
      Get.to(() => Forest(catId: modifiedId, imageBytes: image));
    }
  }
}
