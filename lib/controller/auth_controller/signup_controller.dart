import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_project/view/dashbord/dashboard_screens.dart';

class SignupController extends ChangeNotifier {
  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Toggle Password
  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  // Custom Snackbar (top)
  void showTopSnackbar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: 20,
        right: 20,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2)).then((_) => entry.remove());
  }

  // -----------------------------------------------------
  // SAVE USER TO FIRESTORE (COMMON FUNCTION)
  // -----------------------------------------------------
  Future<void> saveUserToFirestore(User user, {bool google = false}) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "name": google
          ? (user.displayName ?? "User")
          : nameController.text.trim(),
      "email": user.email,
      "photo": user.photoURL ?? "",
      "loginType": google ? "google" : "email",
      "updatedAt": DateTime.now(),
      "createdAt": DateTime.now(),
    }, SetOptions(merge: true));
  }

  // -----------------------------------------------------
  // EMAIL SIGNUP
  // -----------------------------------------------------
  Future<void> signupUser(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential userCred =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User user = userCred.user!;

      await saveUserToFirestore(user);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      prefs.setString("uid", user.uid);

      showTopSnackbar(context, "Account Created Successfully!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreens()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------
  // GOOGLE SIGN-IN (Popup ALWAYS shows)
  // -----------------------------------------------------
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      // ⭐ VERY IMPORTANT — forces email popup every time
      await googleSignIn.signOut();
      await _auth.signOut();

      // 1️⃣ Show Google account popup
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();
      if (googleUser == null) return;

      // 2️⃣ Authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3️⃣ Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Sign in Firebase
      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User user = userCred.user!;

      // 5️⃣ Save / Update Firestore
      await saveUserToFirestore(user, google: true);

      // 6️⃣ Save session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      prefs.setString("uid", user.uid);

      showTopSnackbar(context, "Logged in with Google!");

      // 7️⃣ Navigate
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreens()),
      );
    } catch (e) {
      print("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In failed")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
