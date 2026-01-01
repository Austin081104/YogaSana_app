import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/auth_controller/forgot_controller.dart';
import 'package:yoga_project/controller/auth_controller/login_controller.dart';
import 'package:yoga_project/controller/auth_controller/signup_controller.dart';
import 'package:yoga_project/controller/dashboard_controller/diet_controller.dart';
import 'package:yoga_project/controller/dashboard_controller/meditation_controller.dart';
import 'package:yoga_project/controller/dashboard_controller/profile_controller.dart';
import 'package:yoga_project/controller/dashboard_controller/yoga_controller.dart';
import 'package:yoga_project/splash_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => SignupController()),
        ChangeNotifierProvider(create: (_) => ForgotController()),
        ChangeNotifierProvider(create: (_) => YogaController()),
        ChangeNotifierProvider(create: (_) => MeditationController()),
        ChangeNotifierProvider(create: (_) => DietController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yoga App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  SplashScreen(),
      ),
    );
  }
}
