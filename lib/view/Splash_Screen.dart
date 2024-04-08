import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_pro/view/Home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkFirstTime().then((firstTime) {
      if (firstTime) {
        Timer(const Duration(seconds: 6), () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => Home(),));
          setFirstTimeFlag();
        });
      } else {
        Navigator.push(context,MaterialPageRoute(builder: (context) => Home(),));
      }
    });
  }

  Future<bool> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_time') ?? true;
  }

  Future<void> setFirstTimeFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/Home/BG.png",
          width: double.infinity, fit: BoxFit.cover),
    );
  }
}
