import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF87CEEB)),
      fontFamily: GoogleFonts.arOneSans().fontFamily,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        color: Color(0xFF87CEEB),
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.arOneSans().fontFamily,
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white,),
    elevation: 0.0,
    color: Colors.black,
  ));
}
