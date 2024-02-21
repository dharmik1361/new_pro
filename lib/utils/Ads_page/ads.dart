import 'dart:convert';
import '../../controller/API_Controller/Ads_API.dart';
import '../../model/Ads_model/Ads_Api_model.dart';
import '../../model/Ads_model/Ads_model_data.dart';

class AdsHelper {
  final AdsController controller;

  AdsHelper(this.controller);

  Future<Ads?> fetchAdsData() async {
    try {
      return await controller.AdsfetchData();
    } catch (e) {
      print("Error $e");
      return null;
    }
  }

  String decodeAdsData(String? adsData) {
    if (adsData != null && adsData.isNotEmpty) {
      try {
        final decodeAds = controller.decodeBase64(adsData);
        return decodeAds;
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    }
    return "";
  }

  List<AdsConfig> parseAdsConfigList(String decodedData) {
    final List<AdsConfig> adsConfigList = [];
    try {
      dynamic decodedDataJson = json.decode(decodedData);

      if (decodedDataJson is List) {
        adsConfigList.addAll(
          decodedDataJson.map((json) => AdsConfig.fromJson(json)),
        );
      } else if (decodedDataJson is Map<String, dynamic>) {
        // Handle the case where the JSON is an object, not a list
        adsConfigList.add(AdsConfig.fromJson(decodedDataJson));
      } else {
        print("Unexpected JSON format");
      }
    } catch (e) {
      print("Error parsing JSON: $e");
    }
    return adsConfigList;
  }
}

class ADSHelp {
  ADSHelp._();

  static final ADSHelp AdsHelp = ADSHelp._();
  final AdsController controller = AdsController();
  final AdsHelper adsHelper = AdsHelper(AdsController());

  Ads? ads;
  String adsData = "";
  List<AdsConfig> adsList = [];

  Future<void> fetchData() async {
    ads = await adsHelper.fetchAdsData();
    if (ads != null) {
      adsData = adsHelper.decodeAdsData(ads?.data);
      adsList = adsHelper.parseAdsConfigList(adsData);
    }
  }
}
