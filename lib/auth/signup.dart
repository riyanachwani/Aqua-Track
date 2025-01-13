import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aquatrack/main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("AquaTrack", style: TextStyle(fontFamily: "RosebayRegular")),
        actions: [
          IconButton(
              onPressed: () {
                themeModel.toggleTheme();
              },
              icon: Icon(themeModel.mode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode)),
        ],
      ),
    );
  }
}
