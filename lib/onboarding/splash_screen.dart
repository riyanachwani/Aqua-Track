import 'dart:developer';

import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = false;

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('_isLoggedIn') ?? false;
      log("Login status: $_isLoggedIn");

      if (_isLoggedIn) {
        Navigator.pushReplacementNamed(context, MyRoutes.personalInfoRoute);
      } else {
        Navigator.pushReplacementNamed(context, MyRoutes.landingRoute);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      _checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/transparentapplogo.png',
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
