import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 70),
          child: Column(
            children: [
              SafeArea(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "To create the best hydration plan, let's get to know more about you.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Color.fromARGB(255, 184, 179, 179),
                              height: 1.5,
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red[100],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )))
            ],
          ),
        ),
      ),
    ));
  }
}
