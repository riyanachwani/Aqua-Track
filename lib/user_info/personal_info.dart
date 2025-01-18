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

      //Height => if > 175 cms for men or > 165 cms for women => add 250-500 ml
      if ((selectedGender == 'Male' &&
              double.parse(heightController.text) > 175) ||
          (selectedGender == 'Female' &&
              double.parse(heightController.text) > 165)) {
        waterIntake += 300;
      }

      //If Gender = > male => multiply by 1.2 (20% added)
      if (selectedGender == 'Male') {
        waterIntake = waterIntake * 1.2;
      }

      // Activity level: Adjust water intake based on physical activity minutes
      int activityMinutes = int.parse(activityController.text);
      if (activityMinutes > 60) {
        // For users with more than 60 minutes of activity, add extra 500 ml
        waterIntake += 500;
        log("Activity adjustment (more than 60 minutes, 500 ml added): $waterIntake");
      } else if (activityMinutes > 30) {
        // For users with 30-60 minutes of activity, add extra 300 ml
        waterIntake += 300;
        log("Activity adjustment (30-60 minutes, 300 ml added): $waterIntake");
      }
      log("Activity level: ${activityController.text}");

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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
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
