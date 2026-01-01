import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yoga_project/controller/dashboard_controller/yoga_controller.dart';

class YogaTabbarWidget extends StatelessWidget {
  const YogaTabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<YogaController>(
                builder: (context, yoga, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _genderTab(
                        label: "Women",
                        active: yoga.selectedGender == "women",
                        onTap: () => yoga.changeGender("women"),
                      ),
                      SizedBox(width: 10),

                      _genderTab(
                        label: "Men",
                        active: yoga.selectedGender == "men",
                        onTap: () => yoga.changeGender("men"),
                      ),
                    ],
                  );
                },
              );
  }
   // 🔹 Gender tab button
  Widget _genderTab({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? Colors.pink : Colors.grey,
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 3,
            width: 50,
            color: active ? Colors.pink : Colors.transparent,
          ),
        ],
      ),
    );
  }
}