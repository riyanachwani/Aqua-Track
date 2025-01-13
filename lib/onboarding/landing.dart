import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/images/bg.jpg", // Replace with your image path
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
          // Foreground Content
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Discover the Power of Hydration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors
                          .white, // Ensure the text is visible over the background
                      fontWeight: FontWeight.w600,
                      fontFamily: 'YourFont',
                    ),
                  ),
                ),
                SizedBox(height: 40), // Space between text and button
                // Button Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutes.signupRoute);
                    },
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.lightBlueAccent,
                    child: Container(
                      width: 300, // Button width
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF87CEEB),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 140),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
