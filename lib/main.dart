import 'package:aquatrack/onboarding/landing.dart';
import 'package:aquatrack/onboarding/splash_screen.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MyRoutes.splashRoute,
      routes: {
        '/': (context) => SplashScreen(),
        MyRoutes.splashRoute: (context) => const SplashScreen(),
        MyRoutes.landingRoute: (context) => const LandingPage(),

      },
    );
  }
}
