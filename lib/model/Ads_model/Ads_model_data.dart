import 'dart:convert';

AdsConfig adsConfigFromJson(String str) => AdsConfig.fromJson(json.decode(str));

String adsConfigToJson(AdsConfig data) => json.encode(data.toJson());

class AdsConfig {
  int id;
  String admobInter;
  String admobNative;
  String admobBanner;
  String admobReward;
  String admobAppOpen;
  String admobInterIos;
  String admobNativeIos;
  String admobBannerIos;
  String admobRewardIos;
  String admobAppOpenIos;
  String applovinInter;
  String applovinNative;
  String applovinBanner;
  String applovinReward;
  String applovinApp;
  String applovinInterIos;
  String applovinNativeIos;
  String applovinBannerIos;
  String applovinRewardIos;
  String applovinAppIos;
  String unityInter;
  String unityBanner;
  String unityReward;
  String unityGameid;
  String unityInterIos;
  String unityBannerIos;
  String unityRewardIos;
  String unityGameidIos;
  int industrialInterval;
  DateTime updatedAt;
  int androidStatus;
  int iosStatus;
  int androidGoogleAdStatus;
  int iosGoogleAdStatus;

  AdsConfig({
    required this.id,
    required this.admobInter,
    required this.admobNative,
    required this.admobBanner,
    required this.admobReward,
    required this.admobAppOpen,
    required this.admobInterIos,
    required this.admobNativeIos,
    required this.admobBannerIos,
    required this.admobRewardIos,
    required this.admobAppOpenIos,
    required this.applovinInter,
    required this.applovinNative,
    required this.applovinBanner,
    required this.applovinReward,
    required this.applovinApp,
    required this.applovinInterIos,
    required this.applovinNativeIos,
    required this.applovinBannerIos,
    required this.applovinRewardIos,
    required this.applovinAppIos,
    required this.unityInter,
    required this.unityBanner,
    required this.unityReward,
    required this.unityGameid,
    required this.unityInterIos,
    required this.unityBannerIos,
    required this.unityRewardIos,
    required this.unityGameidIos,
    required this.industrialInterval,
    required this.updatedAt,
    required this.androidStatus,
    required this.iosStatus,
    required this.androidGoogleAdStatus,
    required this.iosGoogleAdStatus,
  });

  factory AdsConfig.fromJson(Map<String, dynamic> json) => AdsConfig(
    id: json["id"],
    admobInter: json["admob_inter"],
    admobNative: json["admob_native"],
    admobBanner: json["admob_banner"],
    admobReward: json["admob_reward"],
    admobAppOpen: json["admob_app_open"],
    admobInterIos: json["admob_inter_ios"],
    admobNativeIos: json["admob_native_ios"],
    admobBannerIos: json["admob_banner_ios"],
    admobRewardIos: json["admob_reward_ios"],
    admobAppOpenIos: json["admob_app_open_ios"],
    applovinInter: json["applovin_inter"],
    applovinNative: json["applovin_native"],
    applovinBanner: json["applovin_banner"],
    applovinReward: json["applovin_reward"],
    applovinApp: json["applovin_app"],
    applovinInterIos: json["applovin_inter_ios"],
    applovinNativeIos: json["applovin_native_ios"],
    applovinBannerIos: json["applovin_banner_ios"],
    applovinRewardIos: json["applovin_reward_ios"],
    applovinAppIos: json["applovin_app_ios"],
    unityInter: json["unity_inter"],
    unityBanner: json["unity_banner"],
    unityReward: json["unity_reward"],
    unityGameid: json["unity_gameid"],
    unityInterIos: json["unity_inter_ios"],
    unityBannerIos: json["unity_banner_ios"],
    unityRewardIos: json["unity_reward_ios"],
    unityGameidIos: json["unity_gameid_ios"],
    industrialInterval: json["industrial_interval"],
    updatedAt: DateTime.parse(json["updated_at"]),
    androidStatus: json["android_status"],
    iosStatus: json["ios_status"],
    androidGoogleAdStatus: json["android_google_ad_status"],
    iosGoogleAdStatus: json["ios_google_ad_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "admob_inter": admobInter,
    "admob_native": admobNative,
    "admob_banner": admobBanner,
    "admob_reward": admobReward,
    "admob_app_open": admobAppOpen,
    "admob_inter_ios": admobInterIos,
    "admob_native_ios": admobNativeIos,
    "admob_banner_ios": admobBannerIos,
    "admob_reward_ios": admobRewardIos,
    "admob_app_open_ios": admobAppOpenIos,
    "applovin_inter": applovinInter,
    "applovin_native": applovinNative,
    "applovin_banner": applovinBanner,
    "applovin_reward": applovinReward,
    "applovin_app": applovinApp,
    "applovin_inter_ios": applovinInterIos,
    "applovin_native_ios": applovinNativeIos,
    "applovin_banner_ios": applovinBannerIos,
    "applovin_reward_ios": applovinRewardIos,
    "applovin_app_ios": applovinAppIos,
    "unity_inter": unityInter,
    "unity_banner": unityBanner,
    "unity_reward": unityReward,
    "unity_gameid": unityGameid,
    "unity_inter_ios": unityInterIos,
    "unity_banner_ios": unityBannerIos,
    "unity_reward_ios": unityRewardIos,
    "unity_gameid_ios": unityGameidIos,
    "industrial_interval": industrialInterval,
    "updated_at": updatedAt.toIso8601String(),
    "android_status": androidStatus,
    "ios_status": iosStatus,
    "android_google_ad_status": androidGoogleAdStatus,
    "ios_google_ad_status": iosGoogleAdStatus,
  };
}
