import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaterIntakeInfoPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const WaterIntakeInfoPage({super.key, required this.formKey});

  @override
  State<WaterIntakeInfoPage> createState() => _WaterIntakeInfoPageState();

  // Function to save the target intake to Firestore
  void saveTargetToFirestore(double newTarget) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'targetIntake': newTarget,
        'profileSetupComplete': true,
        'currentIntake': 0,
        'currentIntakePercentage': 0,
      });
    }
  }
}

class _WaterIntakeInfoPageState extends State<WaterIntakeInfoPage> {
  double recommendedIntake = 0.0; // Fetched from Firestore
  double targetIntake = 2000.0; // Default target intake, adjustable via slider

  @override
  void initState() {
    super.initState();
    _fetchWaterIntake();
  }

  Future<void> _fetchWaterIntake() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          recommendedIntake = userDoc['Recommended Water Intake'] ?? 0;
          targetIntake = recommendedIntake;
        });
      } else {
        print("User document not found!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Recommended Intake
            Row(
              children: [
                SizedBox(width: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Ideal Water Intake: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: recommendedIntake > 0
                            ? "$recommendedIntake ml"
                            : "Loading...",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Glass Image and Vertical Slider
            SizedBox(height: 20),
            Row(
              children: [
                // Glass Image (Left)
                Image.asset(
                  'assets/images/glass.png',
                  height: 550,
                  width: 300,
                ),

                // Vertical Slider and Target Display
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Set Target Text
                      Text(
                        "Set Target",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Fancy Vertical Slider
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom Background with Tick Marks
                          Container(
                            width: 20,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.lightBlue.shade100,
                                  Colors.blue.shade300,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: CustomPaint(
                              painter: TickMarkPainter(),
                            ),
                          ),

                          // Vertical Slider
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 0, // Hide default track
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                    elevation: 3,
                                    pressedElevation: 6,
                                  ),
                                  thumbColor: Colors.white, // White dragger
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  value: targetIntake,
                                  min: 0, // Lowest position of slider
                                  max: 10000, // Highest position of slider
                                  divisions:
                                      100, // Optional, for discrete movement
                                  onChanged: (value) {
                                    setState(() {
                                      targetIntake = value;
                                    });
                                    widget.saveTargetToFirestore(
                                        value); // Save updated target to Firestore
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // Target Display
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Form(
                          key: widget.formKey,
                          child: TextFormField(
                            controller: TextEditingController(
                                text: targetIntake > 0
                                    ? targetIntake.toStringAsFixed(0)
                                    : "Loading..."),
                            enabled: false,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TickMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade600
      ..strokeWidth = 2;

    const tickInterval = 40.0; // Adjusted for better alignment
    for (double y = 0; y < size.height; y += tickInterval) {
      canvas.drawLine(
        Offset(size.width * 0.7, y), // Start of tick
        Offset(size.width, y), // End of tick
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
