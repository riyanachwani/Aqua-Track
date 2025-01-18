import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

TextEditingController heightController = TextEditingController();
TextEditingController weightController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController activityController = TextEditingController();

String selectedGender = "Male";

class PersonalInfoPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PersonalInfoPage({super.key, required this.formKey});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();

  Future<void> saveUserInfo() async {
    FirebaseAuth auth = await FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      //Weight * 30
      double waterIntake = double.parse(weightController.text) * 30;
      log("Initial water intake: $waterIntake");

      // Height adjustment: if height > 175 cm for males or > 165 cm for females, add 250-500 ml
      if ((selectedGender == 'Male' &&
              double.parse(heightController.text) > 175) ||
          (selectedGender == 'Female' &&
              double.parse(heightController.text) > 165)) {
        waterIntake += 300; // Adding 300 ml for users with the specified height
        log("Height adjustment: ${selectedGender} with height ${heightController.text} cm added 300 ml");
      } else {
        log("Height adjustment: No height-related addition applied for ${selectedGender} with height ${heightController.text} cm");
      }

// Gender adjustment: if Male, multiply water intake by 1.2 (20% added)
      if (selectedGender == 'Male') {
        waterIntake = waterIntake * 1.2;
        log("Selected gender = Male, so water intake is multiplied by 1.2. New water intake: $waterIntake");
      } else {
        log("Gender adjustment: No gender-related multiplication applied as selected gender is ${selectedGender}");
      }

      // Activity level: Adjust water intake based on physical activity minutes
      int activityMinutes = int.parse(activityController.text);
      log("Parsed activity level: $activityMinutes"); // Log to confirm the value

      if (activityMinutes > 60) {
        // For users with more than 60 minutes of activity, add extra 500 ml
        waterIntake += 500;
        log("Activity adjustment (more than 60 minutes, 500 ml added): $waterIntake");
      } else if (activityMinutes >= 30) {
        // Changed condition here
        // For users with 30-60 minutes of activity, add extra 300 ml
        waterIntake += 300;
        log("Activity adjustment (30-60 minutes, 300 ml added): $waterIntake");
      } else {
        log("No activity adjustment applied");
      }

      log("Final water intake: $waterIntake"); // Final check for water intake value

      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'Age': int.parse(ageController.text),
        'Gender': selectedGender,
        'Height': double.parse(heightController.text),
        'Weight': double.parse(weightController.text),
        'Activity': activityMinutes,
        'Recommended Water Intake': waterIntake,
        'profileSetupComplete': true
      });
      log('User info saved');
    }
  }
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            SafeArea(
                child: Form(
              key: widget.formKey,
              child: Column(
                children: [
                  Text(
                    "To create the best hydration plan, let's get to know more about you.",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.red[100],
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: ageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your age";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Age",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.red[100],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: weightController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your weight";
                          } else if (!RegExp(r'^\d+(\.\d+)?$')
                              .hasMatch(value)) {
                            return "Enter valid weight(in kgs)";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Weight(in kgs)",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.red[100],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: heightController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your height";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Height(in cms)",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.red[100],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: activityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your daily activity time in minutes";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Daily Activity (in minutes)",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.red[100],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
