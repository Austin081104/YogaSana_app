import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_project/view/dashbord/dashboard_screens.dart';

class LoginController extends ChangeNotifier {
  // Text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // -------------------------------------------------------
  // CUSTOM TOP SNACKBAR
  // -------------------------------------------------------
  void showTopSnackbar(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: 20,
        right: 20,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2)).then((_) {
      overlayEntry.remove();
    });
  }

  // -------------------------------------------------------
  // FIRESTORE SAVE (common for email + google)
  // -------------------------------------------------------
  Future<void> saveUserToFirestore(User user, {bool isGoogle = false}) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "name": isGoogle
          ? (user.displayName ?? "User")
          : user.email!.split("@")[0], // Default name for email-login
      "email": user.email,
      "photo": user.photoURL ?? "",
      "loginType": isGoogle ? "google" : "email",
      "updatedAt": DateTime.now(),
      "createdAt": DateTime.now(),
    }, SetOptions(merge: true)); // No duplicates → update existing
  }

  // -------------------------------------------------------
  // EMAIL LOGIN
  // -------------------------------------------------------
  Future<void> loginUser(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User user = userCred.user!;

      await saveUserToFirestore(user, isGoogle: false);

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("uid", user.uid);

      showTopSnackbar(context, "Login Successful!", Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreens()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";

      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else {
        message = e.message ?? 'Something went wrong.';
      }

      showTopSnackbar(context, message, Colors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------
  // GOOGLE SIGN-IN
  // -------------------------------------------------------
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      // 👇 THIS IS THE IMPORTANT PART
      await googleSignIn.signOut(); // Clears previous Google session
      await _auth.signOut(); // Also clear Firebase cached session

      // Now popup will show every time
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      User user = userCred.user!;

      await saveUserToFirestore(user, isGoogle: true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      prefs.setString("uid", user.uid);

      showTopSnackbar(context, "Logged in with Google!", Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreens()),
      );
    } catch (e) {
      print("Google Sign-In Error: $e");
      showTopSnackbar(context, "Google Sign-In failed", Colors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
