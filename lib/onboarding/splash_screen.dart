import 'package:aquatrack/utils/color_codes.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () async {
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
          child: SvgPicture.asset(
              'assets/images/completelogo.svg',
          width: 100,
          height: 100,
          alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
