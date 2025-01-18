import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalInfoPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PersonalInfoPage({super.key, required this.formKey});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController activityController = TextEditingController();

  String selectedGender = "Male";

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
      } else if (activityMinutes > 30) {
        // For users with 30-60 minutes of activity, add extra 300 ml
        waterIntake += 300;
      }

      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'Age': int.parse(ageController.text),
        'Gender': selectedGender,
        'Height': double.parse(heightController.text),
        'Weight': double.parse(weightController.text),
        'Recommended Water Intake': waterIntake,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
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
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 0),
                  Column(
                    children: [
                      SizedBox(height: 25),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          labelText: "Name",
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(height: 0),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 25),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Gender",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(height: 0),
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
                          labelText: "Age",
                          hintText: "Age",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(height: 0),
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
                          labelText: "Weight(in kgs)",
                          hintText: "Weight(in kgs)",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(height: 0),
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
                          labelText: "Height(in cms)",
                          hintText: "Height(in cms)",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(height: 0),
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
                          labelText: "Daily Activity (in minutes)",
                          hintText: "Daily Activity (in minutes)",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(height: 0),
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
