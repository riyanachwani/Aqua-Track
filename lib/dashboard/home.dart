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
                InkWell(
                  onTap: () {
                    // Open the modal with the water intake buttons
                    _openWaterIntakeModal();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, size: 40)),
                ),

                const SizedBox(height: 20),
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
      isScrollControlled: true, // Allow the modal to take more space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: 2 buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWaterButton(
                      color: Colors.green,
                      iconPath: 'assets/images/water-drop.png',
                      ml: 100),
                  _buildWaterButton(
                      color: Colors.orange,
                      iconPath: 'assets/images/glass1.png',
                      ml: 250),
                  _buildWaterButton(
                      color: Colors.orange,
                      iconPath: 'assets/images/bottle.png',
                      ml: 250),
                ],
              ),
              const SizedBox(height: 20), // Spacing between rows

              // Row 2: 2 buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWaterButton(
                      color: Colors.orange,
                      iconPath: 'assets/images/water-bottle.png',
                      ml: 250),
                  _buildWaterButton(
                      color: Colors.blue,
                      iconPath: 'assets/images/jar.png',
                      ml: 500),
                  _buildWaterButton(
                      color: Colors.red,
                      iconPath: 'assets/images/large.png',
                      ml: 1000),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWaterButton({
    required Color color,
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
