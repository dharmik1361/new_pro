import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_pro/utils/Helper/api_hepler.dart';
import 'package:new_pro/utils/Notification/notifcation_helper.dart';
import 'package:new_pro/utils/Payment/upi_payment.dart';
import 'package:new_pro/view/Home_Screen.dart';
import 'package:new_pro/view/Splash_Screen.dart';
import 'package:new_pro/view/theme_select_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  APIHelper.init();
  MobileAds.instance.initialize();
  await NotificationHelper.initializeNotifications();
  SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.top]);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Slicing",
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => Splash()),
        GetPage(name: "/home", page: () => Home()),
        GetPage(name: "/animal", page: () => AnimalSelect()),
        GetPage(name: "/payment", page: () => Payment(),
        ),
      ],
    );
  }
}
