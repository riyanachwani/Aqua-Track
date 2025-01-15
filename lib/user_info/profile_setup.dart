import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';

import 'package:aquatrack/user_info/personal_info.dart';
import 'package:aquatrack/user_info/sleep_schedule.dart';
import 'package:aquatrack/user_info/water_intake_info.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  int _currentStep = 0;
  final GlobalKey<FormState> _personalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _sleepScheduleFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _waterIntakeFormKey = GlobalKey<FormState>();

  late List<Widget> _stepPages;

  @override
  void initState() {
    super.initState();
    _stepPages = [
      PersonalInfoPage(formKey: _personalInfoFormKey),
      SleepSchedulePage(formKey: _sleepScheduleFormKey),
      WaterIntakeInfoPage(formKey: _waterIntakeFormKey),
    ];
  }

  final List<String> _stepTitles = [
    "Personal Info",
    "Sleep Schedule",
    "Water Intake",
  ];

  void _nextStep() {
    bool isValid = false;
    switch (_currentStep) {
      case 0:
        isValid = _personalInfoFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = _sleepScheduleFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = _waterIntakeFormKey.currentState?.validate() ?? false;
        break;
    }

    if (isValid) {
      if (_currentStep < _stepPages.length - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        Navigator.pushNamed(context, MyRoutes.dashboardRoute);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _styledButton(String label, VoidCallback onTap,
      {bool isDisabled = false}) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.black,
      highlightColor: Colors.black,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDisabled ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_stepTitles.length, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentStep
                              ? Color(0xFF87CEEB)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _stepTitles.map((title) {
                    int index = _stepTitles.indexOf(title);
                    return Expanded(
                      child: Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: index == _currentStep
                                ? Color(0xFF87CEEB)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _stepPages[_currentStep], // Displays the current page
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _styledButton(
                    "Back",
                    _previousStep,
                    isDisabled: _currentStep == 0,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _styledButton(
                    _currentStep == _stepPages.length - 1 ? "Finish" : "Next",
                    _nextStep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
