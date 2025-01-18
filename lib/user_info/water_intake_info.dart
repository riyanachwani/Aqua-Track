import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaterIntakeInfoPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const WaterIntakeInfoPage({super.key, required this.formKey});

  @override
  State<WaterIntakeInfoPage> createState() => _WaterIntakeInfoPageState();
}

class _WaterIntakeInfoPageState extends State<WaterIntakeInfoPage> {
  double waterIntake = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchWaterIntake();
  }

  Future<void> _fetchWaterIntake() async {
    // Get the current user ID
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // Fetch the document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Check if the document exists and get the Recommended Water Intake
      if (userDoc.exists) {
        setState(() {
          waterIntake = userDoc['Recommended Water Intake'] ?? 0;
        });
      } else {
        // Handle case if the document doesn't exist
        print("User document not found!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          Text(
            "Ideal Water Intake",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Image.asset(
            'assets/images/water.png',
            height: 140,
            width: 100,
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: Center(
                child: Text(
                  waterIntake > 0 ? "$waterIntake ml" : "Loading...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
