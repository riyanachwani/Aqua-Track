import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int selectedWakeUpHour = 6; // Default wake-up hour
int selectedWakeUpMinute = 30; // Default wake-up minute
int selectedBedTimeHour = 22; // Default bedtime hour
int selectedBedTimeMinute = 0; // Default bedtime minute

class SleepSchedulePage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const SleepSchedulePage({super.key, required this.formKey});
  Future<void> saveTimeSelected() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // Save wake-up and bedtime time to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'Wake-up Time':
            '${selectedWakeUpHour.toString().padLeft(2, '0')}:${selectedWakeUpMinute.toString().padLeft(2, '0')}',
        'Bed Time':
            '${selectedBedTimeHour.toString().padLeft(2, '0')}:${selectedBedTimeMinute.toString().padLeft(2, '0')}',
      });
      print('User sleep schedule saved');
    }
  }

  @override
  State<SleepSchedulePage> createState() => _SleepSchedulePageState();
}

class _SleepSchedulePageState extends State<SleepSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wake-Up Time Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wb_sunny_outlined,
                    size: 28,
                    color: Colors.yellow[700],
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Wake-up Time",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour Picker for Wake-up Time
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedWakeUpHour,
                        ),
                        itemExtent: 50,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            selectedWakeUpHour = value;
                          });
                        },
                        children: List<Widget>.generate(24, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  // Minute Picker for Wake-up Time
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedWakeUpMinute,
                        ),
                        itemExtent: 50,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            selectedWakeUpMinute = value;
                          });
                        },
                        children: List<Widget>.generate(60, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 70),

              // Bedtime Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.moon_stars,
                    size: 28,
                    color: Colors.white,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Bedtime",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour Picker for Bedtime
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedBedTimeHour,
                        ),
                        itemExtent: 50,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            selectedBedTimeHour = value;
                          });
                        },
                        children: List<Widget>.generate(24, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  // Minute Picker for Bedtime
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedBedTimeMinute,
                        ),
                        itemExtent: 50,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            selectedBedTimeMinute = value;
                          });
                        },
                        children: List<Widget>.generate(60, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
