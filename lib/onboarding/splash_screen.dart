import 'dart:developer';

import 'package:aquatrack/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkLoginStatus() async {
    // Get the login status from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('_isLoggedIn') ?? false;
    log("Is Logged In: $isLoggedIn");

    if (isLoggedIn) {
      // If user is logged in, check the profile setup status in Firestore
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        bool profileSetupComplete = userData?['profileSetupComplete'] ?? false;
        log("Profile setup complete: $profileSetupComplete");

        if (profileSetupComplete) {
          Navigator.pushReplacementNamed(context, MyRoutes.dashboardRoute);
        } else {
          Navigator.pushReplacementNamed(context, MyRoutes.profileSetupRoute);
        }
      } else {
        // If the user document doesn't exist in Firestore, navigate to profile setup
        log("User document does not exist in Firestore, navigating to profile setup.");
        Navigator.pushReplacementNamed(context, MyRoutes.profileSetupRoute);
      }
    } else {
      // If user is not logged in, navigate to the landing page
      Navigator.pushReplacementNamed(context, MyRoutes.landingRoute);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
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
