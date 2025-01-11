import 'package:aquatrack/auth/signup.dart';
import 'package:aquatrack/onboarding/landing.dart';
import 'package:aquatrack/onboarding/splash_screen.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, themeModel, child) {
          return MaterialApp(
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: MyRoutes.splashRoute,
            routes: {
              '/': (context) => SplashScreen(),
              MyRoutes.splashRoute: (context) => const SplashScreen(),
              MyRoutes.landingRoute: (context) => const LandingPage(),
              MyRoutes.signupRoute: (context) => const SignupPage(),
            },
          );
        }));
  }
}
