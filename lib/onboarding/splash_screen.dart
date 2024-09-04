import 'package:aquatrack/utils/color_codes.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 5000), () async {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MyRoutes.landingRoute,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCodes.mainColor,
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/applogo.png',
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
