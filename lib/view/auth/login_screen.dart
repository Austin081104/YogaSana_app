import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/auth_controller/login_controller.dart';
import 'package:yoga_project/view/auth/forgot_screen.dart';
import 'package:yoga_project/view/auth/signup_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final login = context.watch<LoginController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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

                  // EMAIL
                  TextFormField(
                    controller: login.emailController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter your email" : null,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.pink),

                      // Normal border
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      // When CLICKED / FOCUSED → PINK BORDER
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2,
                        ),
                      ),

                      // Optional: border when enabled but not focused
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: login.passwordController,
                    obscureText: !login.isPasswordVisible,
                    validator: (v) => v != null && v.length < 6
                        ? "Minimum 6 characters"
                        : null,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.pink),

                      suffixIcon: IconButton(
                        icon: Icon(
                          login.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.pink,
                        ),
                        onPressed: login.togglePassword,
                      ),

                      // Normal border
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

                  const SizedBox(height: 10),

                  // FORGOT PASSWORD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordView(),
                          ),
                        ),
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login.isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                login.loginUser(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: login.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text("Or continue with"),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      login.signInWithGoogle(context);
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
                  const SizedBox(height: 20),
                  // SIGNUP LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpPage()),
                        ),
                        child: const Text(
                          "Sign up",
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
      ),
    );
  }
}
