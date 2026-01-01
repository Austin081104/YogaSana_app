import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yoga_project/view/auth/login_screen.dart';
import 'package:yoga_project/view/onboarding/onboarding_screen1.dart';
import 'package:yoga_project/view/onboarding/onboarding_screen2.dart';
import 'package:yoga_project/view/onboarding/onboarding_screen3.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastpage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingSeen', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastpage = index == 2);
          },
          children: const [
            OnboardingScreen1(),
            OnboardingScreen2(),
            OnboardingScreen3(),
          ],
        ),
      ),

      bottomSheet: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SKIP BUTTON
            TextButton(
              onPressed: () => controller.jumpToPage(2),
              child: const Text(
                'SKIP',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.purple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // INDICATOR
            SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.purple,
                dotColor: Colors.grey.shade400,
                dotHeight: 10,
                dotWidth: 10,
                expansionFactor: 4,
                spacing: 8,
              ),
              onDotClicked: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),

            // NEXT / START BUTTON
            TextButton(
              onPressed: () {
                if (isLastpage) {
                  finishOnboarding();
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                isLastpage ? 'Start' : 'Next',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.purple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
