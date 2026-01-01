import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/dashboard_controller/profile_controller.dart';
import 'package:yoga_project/view/auth/login_screen.dart';
import 'package:yoga_project/view/save_pages/save_diet_page.dart';
import 'package:yoga_project/view/save_pages/saved_meditation_page.dart';
import 'package:yoga_project/view/save_pages/saved_yoga_page.dart';
import 'package:yoga_project/view/settings/terms_conditions_page.dart';
import 'package:yoga_project/widgets/profile_screen_widgets/appbar_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    Color primary = Colors.amber.shade700;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: AppbarProfile()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ---------------- PROFILE HEADER ----------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.20),
                        primary.withOpacity(0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: primary.withOpacity(0.15),

                        child: ClipOval(
                          child: controller.userPhoto.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: controller.userPhoto,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,

                                  placeholder: (context, url) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade300,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: primary,
                                      ),
                                    ),
                                  ),

                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person,
                                    size: 40,
                                    color: primary,
                                  ),
                                )
                              : Icon(Icons.person, size: 40, color: primary),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.isLoading
                                ? "Loading..."
                                : "Hello, ${controller.userName}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Welcome back!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 25)),
            SliverToBoxAdapter(child: _sectionTitle("Saved Activities")),

            SliverToBoxAdapter(
              child: _settingsCard(
                items: [
                  _tile(
                    Icons.spa,
                    "Saved Yoga",
                    Colors.pink,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SavedYogaPage()),
                    ),
                  ),
                  _tile(
                    Icons.self_improvement,
                    "Saved Meditation",
                    Colors.deepPurple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SavedMeditationPage(),
                      ),
                    ),
                  ),
                  _tile(
                    Icons.local_dining,
                    "Saved Diets",
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SavedDietsPage()),
                    ),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 25)),
            SliverToBoxAdapter(child: _sectionTitle("App Settings")),

            SliverToBoxAdapter(
              child: _settingsCard(
                items: [
                  _tile(
                    Icons.book,
                    "Terms & Conditions",
                    primary,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TermsConditionsPage()),
                    ),
                  ),
                  _tile(
                    Icons.lock,
                    "Privacy Policy",
                    primary,
                    () => controller.openPrivacyPolicy(),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 25)),

            // LOGOUT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => _logout(context, controller),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.red.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        Icon(Icons.logout, color: Colors.red, size: 26),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  // ------------------ REUSABLE COMPONENTS ------------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.shade100,
        ),
        child: Column(children: items),
      ),
    );
  }

  Widget _tile(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // LOGOUT DIALOG
  void _logout(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.logout(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
