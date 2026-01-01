import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/dashboard_controller/diet_controller.dart';

class AppbarDiet extends StatelessWidget {
  const AppbarDiet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 83, 176, 165),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DIET',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 52, 138, 129),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Consumer<DietController>(
                builder: (context, provider, child) {
                  return TextFormField(
                    controller: provider.searchController,
                    onChanged: (value) => provider.searchDiet(value),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
