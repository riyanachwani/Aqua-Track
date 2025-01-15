import 'package:flutter/material.dart';
import 'package:aquatrack/utils/routes.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  int _currentStep = 0; // Keeps track of current step

  List<Step> _steps() => [
        Step(
          title: Text('Personal Info'),
          content: Container(
            // Content for Personal Info Page (just calling the route)
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.personalInfoRoute);
              },
              child: Text('Tap to go to Personal Info'),
            ),
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: Text('Sleep Schedule'),
          content: Container(
            // Content for Sleep Schedule Page (just calling the route)
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.sleepScheduleRoute);
              },
              child: Text('Tap to go to Sleep Schedule'),
            ),
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Text('Water Intake'),
          content: Container(
            // Content for Water Intake Page (just calling the route)
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.waterIntakeInfoRoute);
              },
              child: Text('Tap to go to Water Intake'),
            ),
          ),
          isActive: _currentStep >= 2,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _steps().length - 1) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            // You can navigate to another page if all steps are completed
            Navigator.pushNamed(
                context, MyRoutes.dashboardRoute); // Use finalStepRoute
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: _steps(),
      ),
    );
  }
}
