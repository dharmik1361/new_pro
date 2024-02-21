import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();

  factory AdManager() {
    return _instance;
  }

  AdManager._internal();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;


  final String _rewardedAdUnitId = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/5224354917"
      : "ca-app-pub-3940256099942544/1712485313";


  bool _isInterstitialAdReady = false;

  BannerAd? get bannerAd => _bannerAd;
  InterstitialAd? get interstitialAd => _interstitialAd;


  Future<void> loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: _rewardedAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (error) {
          print("Interstitial ad failed to load: $error");
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Future<void> showRewardedAd() async {
    if (!_isInterstitialAdReady) {
      print("Interstitial ad is null or not ready.");
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd(); // Reload the interstitial ad for the next time
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd(); // Reload the interstitial ad for the next time
      },
    );

    _interstitialAd!.show();
    _isInterstitialAdReady = false;
  }
}
