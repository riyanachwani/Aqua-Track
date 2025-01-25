import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from top-left
    path.lineTo(0, size.height * 0.1);

    // Create the wave
    path.quadraticBezierTo(
      size.width * 0.25, size.height * -0.1, // First control point
      size.width * 0.5, size.height * 0.1, // End of first wave
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.3, // Second control point
      size.width, size.height * 0.1, // End of second wave
    );

    // Draw down the right side
    path.lineTo(size.width, size.height);

    // Draw bottom edge
    path.lineTo(0, size.height);

    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _HomePageState extends State<HomePage> {
  double recommendedIntake = 2000; // Default recommended intake
  int currentIntake = 0; // Current water intake
  int currentIntakePercentage = 0;

  @override
  void initState() {
    super.initState();
    _fetchWaterIntake();
  }

  // Fetch water intake data from Firestore and check for lastResetTime
  Future<void> _fetchWaterIntake() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (mounted) {
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            recommendedIntake = data['targetIntake'] ?? 2000;
            currentIntake = data['currentIntake'] ?? 0;
            currentIntakePercentage = data['currentIntakePercentage'] ?? 0;

            // Check if the 'lastResetTime' field exists
            if (data.containsKey('lastResetTime')) {
              Timestamp lastResetTime = data['lastResetTime'];
              print('Last reset time: $lastResetTime');
            } else {
              // Set the current timestamp if 'lastResetTime' does not exist
              FirebaseFirestore.instance.collection('users').doc(user.uid).set(
                {
                  'lastResetTime': FieldValue.serverTimestamp(),
                },
                SetOptions(merge: true),
              );
              print('No last reset time found, initializing it.');
            }
          });
        }
      }
    }
  }

  // Update water intake data in Firestore and set 'lastResetTime' if missing
  Future<void> _updateWaterIntake() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // If the document doesn't exist, create it with necessary fields
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'targetIntake': recommendedIntake,
          'currentIntake': currentIntake,
          'currentIntakePercentage': currentIntakePercentage,
          'lastResetTime':
              FieldValue.serverTimestamp(), // Set the current timestamp
        });
      } else {
        // If document exists, update it
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {
            'targetIntake': recommendedIntake,
            'currentIntake': currentIntake,
            'currentIntakePercentage': currentIntakePercentage,
            'lastResetTime': FieldValue.serverTimestamp(), // Update timestamp
          },
          SetOptions(merge: true),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int remainingIntake = (recommendedIntake - currentIntake)
        .toInt(); // Calculate remaining intake

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Circular Progress Bar with Flowing Water Animation
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.3), // Shadow color
                              spreadRadius: 5, // How much the shadow spreads
                              blurRadius: 15, // How blurred the shadow is
                              offset:
                                  const Offset(0, 4), // Position of the shadow
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: WaveWidget(
                            config: CustomConfig(
                              gradients: [
                                [Colors.blue.shade300, Colors.blue.shade500],
                                [Colors.blue.shade500, Colors.blue.shade700],
                              ],
                              durations: [3000, 4000],
                              heightPercentages: [
                                0.9 - (currentIntakePercentage / 100),
                                0.9 - (currentIntakePercentage / 100),
                              ],
                              blur: const MaskFilter.blur(BlurStyle.solid, 10),
                            ),
                            waveAmplitude: 20,
                            size: const Size(double.infinity, double.infinity),
                          ),
                        ),
                      ),
                      // Circular Progress Border with Text in the Center
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${currentIntakePercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10), // Space between percentage and remaining target
                          Text(
                            'Remaining Target: ${remainingIntake.toStringAsFixed(0)} ml',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "Today\'s Records",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Open the modal with the water intake buttons
                          _openWaterIntakeModal();
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Image.asset(
                              "assets/images/plus.png",
                              height: 50,
                              width: 50,
                              //color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openWaterIntakeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Ensures no unwanted background color
      builder: (context) {
        return Container(
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Modal background color
                //borderRadius: BorderRadius.circular(20), // For rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 12.0), // Padding inside modal
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    // Row 1: Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWaterButton(
                            iconPath: 'assets/images/water-drop.png', ml: 100),
                        _buildWaterButton(
                            iconPath: 'assets/images/glass1.png', ml: 250),
                        _buildWaterButton(
                            iconPath: 'assets/images/bottle.png', ml: 500),
                      ],
                    ),
                    const SizedBox(height: 20), // Spacing between rows

                    // Row 2: Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWaterButton(
                            iconPath: 'assets/images/jar.png', ml: 750),
                        _buildWaterButton(
                            iconPath: 'assets/images/water-bottle.png',
                            ml: 1000),
                        _buildWaterButton(
                            iconPath: 'assets/images/large.png', ml: 2000),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterButton({
    //required Color color,
    required String iconPath,
    required int ml,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIntake += ml;
          currentIntakePercentage =
              ((currentIntake / recommendedIntake) * 100).toInt();
          if (currentIntakePercentage > 100) {
            currentIntakePercentage = 100;
          }
        });

        // Update Firestore with the new intake data
        _updateWaterIntake();

        Navigator.pop(context); // Close the modal after the update
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use Image.asset for custom icons
          Image.asset(
            //color: color,
            iconPath,
            width: 40, // Set width for the image
            height: 40, // Set height for the image
          ),
          const SizedBox(height: 5), // Space between image and ml text
          Text(
            '$ml ml',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
