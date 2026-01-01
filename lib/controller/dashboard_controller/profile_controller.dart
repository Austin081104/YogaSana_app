import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends ChangeNotifier {
  String userName = "User";
  String userPhoto = "";
  bool isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileController() {
    loadUserData();
  }

  // -------------------------------
  // LOAD USER DATA
  // -------------------------------
  Future<void> loadUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        userName = doc["name"] ?? "User";
        userPhoto = doc["photo"] ?? "";
      }
    } catch (e) {
      print("PROFILE LOAD ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // -------------------------------
  // LOGOUT
  // -------------------------------
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('uid');
  }

  // -------------------------------
  // PRIVACY POLICY
  // -------------------------------
  Future<void> openPrivacyPolicy() async {
    final Uri url = Uri.parse(
        'https://austin081104.github.io/yogsana-app-privacy-policy/');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch URL');
    }
  }
}
