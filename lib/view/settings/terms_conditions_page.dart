import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(18),
          ),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _title("1. Acceptance of Terms"),
                _text(
                  "By using this application, you agree to be bound by these Terms & Conditions. "
                  "If you do not agree, please discontinue using the app immediately.",
                ),

                _title("2. User Responsibilities"),
                _text(
                  "You agree to use the app responsibly and avoid any activities that may harm, "
                  "interrupt, or misuse the platform and its content.",
                ),

                _title("3. Health Disclaimer"),
                _text(
                  "All yoga, meditation, and diet content provided in this app is for informational "
                  "purposes only. Always consult a healthcare professional before beginning any fitness program.",
                ),

                _title("4. Account & Security"),
                _text(
                  "You are responsible for maintaining the confidentiality of your account credentials. "
                  "The app is not liable for any unauthorized access resulting from your negligence.",
                ),

                _title("5. Content Ownership"),
                _text(
                  "All images, videos, text, and resources available in the app are owned or licensed "
                  "by the developers. You may not copy, share, or reproduce them without permission.",
                ),

                _title("6. Data Privacy"),
                _text(
                  "We do not sell or misuse your personal data. Your information is securely stored "
                  "and used only to enhance your experience within the app.",
                ),

                _title("7. Changes to Terms"),
                _text(
                  "The app reserves the right to modify or update these terms at any time. "
                  "Continued use of the app implies your acceptance of the updated terms.",
                ),

                _title("8. Contact Information"),
                _text(
                  "If you have any questions about these Terms & Conditions, feel free to contact our support team.",
                ),

                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "© 2025 Yoga App. All Rights Reserved.",
                    style: TextStyle(
                      color: Colors.deepPurple.shade300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---- Title Widget ----
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  /// ---- Text Widget ----
  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}
