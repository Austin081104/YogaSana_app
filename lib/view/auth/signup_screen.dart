import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/auth_controller/signup_controller.dart';
import 'package:yoga_project/view/auth/login_screen.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signup = context.watch<SignupController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),

                Center(
                  child: Image.asset(
                    'assets/splash/logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 15),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.pink.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // NAME
                TextFormField(
                  controller: signup.nameController,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter your name" : null,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your Name",
                    prefixIcon: const Icon(Icons.person, color: Colors.pink),

                    // Unfocused border
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),

                    // Focused border → PINK
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.pink,
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // EMAIL
                TextFormField(
                  controller: signup.emailController,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter email" : null,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your Email",
                    prefixIcon: const Icon(Icons.email, color: Colors.pink),

                    // Unfocused border
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),

                    // Focused border → Pink
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.pink,
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PASSWORD
                TextFormField(
                  controller: signup.passwordController,
                  obscureText: !signup.isPasswordVisible,
                  validator: (v) =>
                      v != null && v.length < 6 ? "Min 6 characters" : null,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your Password",

                    prefixIcon: const Icon(Icons.lock, color: Colors.pink),

                    suffixIcon: IconButton(
                      icon: Icon(
                        signup.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.pink,
                      ),
                      onPressed: signup.togglePassword,
                    ),

                    // Unfocused Border
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),

                    // Focused Border → PINK
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.pink,
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CONFIRM PASSWORD
                TextFormField(
                  controller: signup.confirmPasswordController,
                  obscureText: !signup.isConfirmPasswordVisible,
                  validator: (v) => v != signup.passwordController.text
                      ? "Passwords do not match"
                      : null,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Re-enter Password",

                    prefixIcon: const Icon(Icons.lock, color: Colors.pink),

                    suffixIcon: IconButton(
                      icon: Icon(
                        signup.isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.pink,
                      ),
                      onPressed: signup.toggleConfirmPassword,
                    ),

                    // Unfocused border
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),

                    // Focused border → PINK
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.pink,
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      minimumSize: Size(double.infinity, 50),
                    ),

                    onPressed: signup.isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              signup.signupUser(context);
                            }
                          },

                    child: signup.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Text("Or continue with"),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    signup.signInWithGoogle(context);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/login/Google.png", height: 25),
                        const SizedBox(width: 10),
                        const Text("Continue with Google"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      ),
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
