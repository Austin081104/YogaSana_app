import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:yoga_project/view/dashbord/diet_screen.dart';
import 'package:yoga_project/view/dashbord/meditation_screen.dart';
import 'package:yoga_project/view/dashbord/profile_screen.dart';
import 'package:yoga_project/view/dashbord/yoga_screen.dart';


class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreensState();
}

class _DashboardScreensState extends State<DashboardScreens> {
  int currentIndex = 0;

  final List<Widget> pages = [
    YogaScreen(),
    MeditationScreen(),
    DietScreen(),
    ProfileScreen(),
  ];

  final List<IconData> _iconList = [
    Icons.spa,
    Icons.self_improvement_outlined,
    Icons.local_dining,
    Icons.person,
  ];

  final List<Color> barColors = [
    Colors.pink,
    Colors.deepPurple,
    const Color.fromARGB(255, 83, 176, 165),
    Colors.amber.shade700,
  ];

  void _onIconTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: pages[currentIndex],

        bottomNavigationBar: SafeArea(
          top: false,
          child: CurvedNavigationBar(
            index: currentIndex,
            height: 65,

            items: List.generate(_iconList.length, (index) {
              return Icon(_iconList[index], size: 30, color: Colors.white);
            }),

            color: barColors[currentIndex],
            buttonBackgroundColor: barColors[currentIndex],
            backgroundColor: Colors.white,

            animationDuration: Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,

            onTap: _onIconTap,
          ),
        ),
      ),
    );
  }
}
