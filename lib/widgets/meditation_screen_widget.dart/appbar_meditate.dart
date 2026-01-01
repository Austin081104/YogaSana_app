import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/dashboard_controller/meditation_controller.dart';

class AppbarMeditate extends StatelessWidget {
  const AppbarMeditate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MEDITATION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 133, 96, 235),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                onChanged: (value) {
                  Provider.of<MeditationController>(
                    context,
                    listen: false,
                  ).searchMeditation(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
