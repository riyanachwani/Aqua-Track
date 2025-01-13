import 'package:aquatrack/main.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool isEmail = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoggedIn = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('AquaTrack', style: TextStyle(fontFamily: "RosebayRegular")),
      ),
      body: Stack(
        children: [
          Image.asset('assets/images/bg2.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 90.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Welcome to AquaTrack",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          height: 1.2,
                          color: Colors.white, // Ensure text is readable
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Your personal hydration assistant.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Color.fromARGB(255, 184, 179, 179),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      myTextField("Enter Email"),
                      myPasswordField("Enter Password"),
                      SizedBox(height: size.height * 0.04),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: size.height * 0.06,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF87CEEB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              //moveToDashboard(context);
                            },
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.black,
                            highlightColor: Colors.black,
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 2,
                            width: size.width * 0.2,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Or continue with",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 184, 179, 179),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 2,
                            width: size.width * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            //GoogleRegister();
                          },
                          child: Container(
                            height: size.height * 0.06,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/google.png",
                                  height: 30,
                                  width: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Sign In with Google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 184, 179, 179),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 124, 186, 236),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      MyRoutes.signupRoute,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container myTextField(String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          } else if (isEmail &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Container myPasswordField(String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          } else if (value.length < 6) {
            return 'Password should be at least 6 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
