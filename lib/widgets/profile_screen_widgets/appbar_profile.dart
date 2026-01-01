import 'package:flutter/material.dart';

class AppbarProfile extends StatelessWidget {
  const AppbarProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber.shade700,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
