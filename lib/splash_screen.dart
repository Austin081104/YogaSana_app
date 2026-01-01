import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_project/view/auth/login_screen.dart';
import 'package:yoga_project/view/dashbord/dashboard_screens.dart';
import 'package:yoga_project/view/onboarding/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   
    super.initState();
    checkFlow();
  }

  void checkFlow() async {
    final prefs = await SharedPreferences.getInstance();

    bool onboardingSeen = prefs.getBool('onboardingSeen') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (!onboardingSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPage()),
      );
    } else {
      if (isLoggedIn) {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreens()),
      );
      } else {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/splash/logo.png')),
    );
  }
}
