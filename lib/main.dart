import 'dart:developer';

import 'package:aquatrack/auth/login.dart';
import 'package:aquatrack/auth/signup.dart';
import 'package:aquatrack/dashboard/dashboard.dart';
import 'package:aquatrack/firebase_options.dart';
import 'package:aquatrack/onboarding/landing.dart';
import 'package:aquatrack/onboarding/splash_screen.dart';
import 'package:aquatrack/user_info/personal_info.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:aquatrack/widgets/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class ThemeModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      log("Login status: ${_isLoggedIn}");

      if (_isLoggedIn) {
        Navigator.pushReplacementNamed(context, MyRoutes.personalInfoRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, themeModel, child) {
          return MaterialApp(
            theme: MyTheme.lightTheme(context), // Use custom light theme
            darkTheme: MyTheme.darkTheme(context), // Use custom dark theme
            themeMode: themeModel.mode,
            debugShowCheckedModeBanner: false,
            initialRoute: MyRoutes.splashRoute,
            routes: {
              '/': (context) => SplashScreen(),
              MyRoutes.splashRoute: (context) => const SplashScreen(),
              MyRoutes.landingRoute: (context) => const LandingPage(),
              MyRoutes.signupRoute: (context) => const SignupPage(),
              MyRoutes.loginRoute: (context) => const LoginPage(),
              MyRoutes.dashboardRoute: (context) => const DashboardPage(),
              MyRoutes.personalInfoRoute: (context) => const PersonalInfoPage(),
              MyRoutes.dashboardRoute: (context) => const DashboardPage(),
            },
          );
        }));
  }
}
