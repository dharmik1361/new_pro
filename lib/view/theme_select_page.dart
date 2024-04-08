import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:new_pro/database/db_helper.dart';
import 'package:new_pro/view/Ads/admob.dart';
import 'package:new_pro/view/Animal_Pages/Forest_Page.dart';

import '../utils/Ads_page/ads.dart';
import 'Widget/card.dart';
import 'Widget/container_setting.dart';

class AnimalSelect extends StatefulWidget {
  const AnimalSelect({super.key});

  @override
  State<AnimalSelect> createState() => _AnimalSelectState();
}

class _AnimalSelectState extends State<AnimalSelect> {
  CarouselController buttonController = CarouselController();
  bool isSettingsVisible = false;
  String settingImageAsset = "assets/Setting/Setting .png";
  final RxBool isSoundOn = true.obs;
  final RxBool isNotificationOn = true.obs;
  bool isPlaying = false;
  late AssetsAudioPlayer assetsAudioPlayer;
  late ADSHelp adsInstance;
  List<Map<String, dynamic>> catImage = [];
  final AdManager _adManager = AdManager();
  final RxBool isAdViewed = false.obs;
  String currentDate = "";
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/6300978111"
      : "ca-app-pub-3940256099942544/2934735716";
  @override
  void didChangeDependencies() {
    _loadAd();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    adsInstance = ADSHelp.AdsHelp;
    _adManager.loadInterstitialAd();
    CatData();
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    assetsAudioPlayer.open(
      Audio("assets/m2/gameappsound.mp3"),
      autoStart: true,
    );
  }

  Future<void> _loadAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());
    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }
    _anchoredAdaptiveAd = BannerAd(
      adUnitId: _adUnitId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  Future<void> fetchData() async {
    await adsInstance.fetchData();
    setState(() {});
  }

  void CatData() async {
    catImage = (await DbHelper.dbHelper.getCatImageData());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackground(),
          if (_anchoredAdaptiveAd != null && _isLoaded)
            Container(
              color: Colors.green,
              width: _anchoredAdaptiveAd!.size.width.toDouble(),
              height: _anchoredAdaptiveAd!.size.height.toDouble(),
              child: AdWidget(ad: _anchoredAdaptiveAd!),
            ),
          buildCarousel(),
          buildNextButton(),
          buildPreviousButton(),
          buildSettingsPopup(),
          buildSettingButton(context),
          buildAdsBlockButton(),
        ],
      ),
    );
  }

  void toggleSound() {
    isSoundOn.toggle();
  }

  void toggleNotification() {
    isNotificationOn.toggle();
  }

  Widget buildBackground() {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Home/BG.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
          ),
        ),
      ),
    );
  }

  Widget buildSettingsPopup() {

    return Visibility(
      visible: isSettingsVisible,
      child: Positioned(
        bottom: 8,
        left: 57,
        child: Container(
          height: 82,
          width: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Setting/Outer Popup.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 0.7),
              CustomeCon(
                imageAsset: isPlaying
                    ? "assets/Setting/Sound Off.png"
                    : "assets/Setting/Sound_On .png",
                onTap: () {
                assetsAudioPlayer.playOrPause();
                setState(() {
                  isPlaying = !isPlaying;
                });
                },
              ),
              CustomeCon(
                imageAsset: "assets/Setting/Notification_off.png",
                onTap: () {},
              ),
              CustomeCon(
                imageAsset: "assets/Setting/Privacy Policy.png",
                onTap: () {},
              ),
              CustomeCon(
                imageAsset: "assets/Setting/Exit.png",
                onTap: () {
                  exit(0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingButton(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 18,
      child: InkWell(
        radius: 40,
        onTap: () => toggleSettingsVisibility(context),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(settingImageAsset),
        ),
      ),
    );
  }

  void toggleSettingsVisibility(BuildContext context) {
    setState(() {
      isSettingsVisible = !isSettingsVisible;
      settingImageAsset = isSettingsVisible
          ? "assets/Setting/Setting Off.png"
          : "assets/Setting/Setting .png";
    });
  }


  Widget buildAdsBlockButton() {
    return Positioned(
      bottom: 8,
      right: 18,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetAnimationCurve: Curves.bounceIn,
                backgroundColor: Colors.transparent,
                insetAnimationDuration: const Duration(seconds: 3),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffE8B57E),
                      borderRadius: BorderRadius.circular(20)),
                  height: 250,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SubscriptionDialog(
                        "assets/Setting/ADs Block .png",
                        "Monthly\nSubscription",
                      ),
                      SubscriptionDialog(
                        "assets/Setting/ADs Block .png",
                        "Quarterly\nSubscription",
                      ),
                      SubscriptionDialog(
                        "assets/Setting/ADs Block .png",
                        "Year\nSubscription",
                      ),
                      SubscriptionDialog(
                        "assets/Setting/ADs Block .png",
                        "Life\ntime",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage("assets/Setting/ADs Block .png"),
          radius: 40,
        ),
      ),
    );
  }

  Widget buildCarousel() {
    final Size screenSize = MediaQuery.of(context).size;
    return Positioned(
      top: 60,
      left: 19,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.75,
            width: MediaQuery.sizeOf(context).width * 0.95,
            decoration: const BoxDecoration(),
            child: catImage.isNotEmpty
                ? CarouselSlider.builder(
              itemCount: catImage.length,
              itemBuilder: (context, index, realIndex) {
                final Uint8List image = catImage[index]['image4'];
                final int id = catImage[index]['catId'];
                final String date = catImage[index]['Date'];
                return GestureDetector(
                  onTap: () async {
                    int modifiedId = catImage[index]['catId'] + 1;
                    if (id != 0) {
                      if (date != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                        _adManager.showRewardedAd();
                        DbHelper.dbHelper.updateCateDate(id, DateFormat('yyyy-MM-dd').format(DateTime.now()));
                        CatData();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Intro(
                              padding: EdgeInsets.zero,
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              maskColor: const Color.fromRGBO(0, 0, 0, .6),
                              child: Forest(
                                catId: modifiedId,
                                imageBytes: catImage[index]['image4'],
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      // Handle the case when catId is 1 (skipping lock and ads)
                      int modifiedId = catImage[index]['catId'] + 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Intro(
                            padding: EdgeInsets.zero,
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            maskColor: const Color.fromRGBO(0, 0, 0, .6),
                            child: Forest(
                              catId: modifiedId,
                              imageBytes: catImage[index]['image4'],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 210,
                    width: 210,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Game/BG.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.055,),
                          Text(
                            catImage[index]['Title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.03,
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 210,
                                width: 175,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              if (id != 0)
                                if (date !=
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()))
                                  Positioned(
                                    top: MediaQuery.sizeOf(context).height * 0.15,
                                    left: screenSize.width * 0.07,
                                    child: const Icon(
                                      Icons.lock,
                                      size: 70,
                                      color: Colors.white,
                                    ),
                                  )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              carouselController: buttonController,
              options: CarouselOptions(
                height: 390,
                enlargeCenterPage: true,
                viewportFraction: 0.32,
                enlargeFactor: 0.40,
                initialPage: 0,
                aspectRatio: 16 / 4,
                autoPlayCurve: Curves.linear,
              ),
            )
                : const Center(
              child: Text(''),
            ),
          ),
        ],
      ),
    );
  }

  Widget SubscriptionDialog(
    String imagePath,
    String subscriptionText,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 16.0),
          Text(
            subscriptionText,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff65BEF6),
                fixedSize: const Size(50, 25)),
            onPressed: () {
              Get.toNamed("/payment");
            },
            child: const Text("Buy"),
          ),
        ],
      ),
    );
  }

  Widget buildReusableCard(String backgroundAsset, String label,
      double textLeft, VoidCallback onTap) {
    return ReusableCard(
      backgroundAsset: backgroundAsset,
      label: label,
      textLeft: textLeft,
      onTap: onTap,
    );
  }

  Widget buildNextButton() {
    return Positioned(
      bottom: 11,
      right: 150,
      child: InkWell(
        onTap: () {
          buttonController.nextPage(
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
          },
        child: Container(
          height: 70,
          width: 50,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Setting/Arrow.png"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPreviousButton() {
    return Positioned(
      bottom: 11,
      left: 150,
      child: InkWell(
        onTap: () => buttonController.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        ),
        child: Container(
          height: 70,
          width: 50,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Setting/Arrowback.png"),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _anchoredAdaptiveAd?.dispose();
    assetsAudioPlayer.dispose();
    super.dispose();
  }
}
