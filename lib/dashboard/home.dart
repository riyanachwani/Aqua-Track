import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 127, 176, 220), // Set background color here
      body: Stack(
        children: [
          Positioned(
            bottom: 60,
            left: 0,
            right:
                0, // This ensures the image takes the full width of the screen
            child: Image.asset(
              'assets/images/vc44.png',
              fit: BoxFit
                  .fitWidth, // Ensures the image is resized proportionally to fit the width
            ),
          ),
        ],
      ),
    );
  }
}
