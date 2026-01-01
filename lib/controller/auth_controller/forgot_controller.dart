import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  // 🔔 Reusable TOP Snackbar
  void showTopSnackbar(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: 20,
        right: 20,
        child: Material(
          color: color,
          elevation: 10,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2)).then((_) => entry.remove());
  }

  // 🔐 Send Password Reset Email
  Future<void> sendResetEmail(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showTopSnackbar(context, "Please enter your email", Colors.red);
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      showTopSnackbar(
        context,
        "Reset link sent! Check your inbox.",
        Colors.green,
      );

      // Optionally close screen after 1 sec
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });

    } on FirebaseAuthException catch (e) {
      String message = "";

      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else {
        message = e.message ?? "Something went wrong.";
      }

      showTopSnackbar(context, message, Colors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
