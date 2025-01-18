import 'package:flutter/material.dart';

class SleepSchedulePage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const SleepSchedulePage({super.key, required this.formKey});

  @override
  State<SleepSchedulePage> createState() => _SleepSchedulePageState();
}

class _SleepSchedulePageState extends State<SleepSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50)),
    );
  }
}
