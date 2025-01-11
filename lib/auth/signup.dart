import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Image.asset(
                "Assets/images/bg4.jpg",
                width: 428,
                height: 457,
              ),
            ),
          ],
        ));
  }
}
