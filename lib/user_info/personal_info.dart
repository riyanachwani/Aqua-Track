import 'package:aquatrack/utils/routes.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedGender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
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
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF87CEEB),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        )
                                      ]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your Name";
                                      }
                                      ;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red[100],
                                      ),
                                      labelText: "Name",
                                      hintText: "Name",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF87CEEB),
                                            blurRadius: 20,
                                            offset: Offset(2, 10),
                                          )
                                        ]),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        labelText: "Gender",
                                        hintText: selectedGender,
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      value:
                                          selectedGender, // Set the initial selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedGender = newValue!;
                                        });
                                      },
                                      items: <String>['Male', 'Female', 'Other']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF87CEEB),
                                    blurRadius: 20,
                                    offset: Offset(2, 10),
                                  )
                                ]),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your age";
                                }
                                ;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[100],
                                ),
                                labelText: "Age",
                                hintText: "Age",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          //Weight
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF87CEEB),
                                    blurRadius: 20,
                                    offset: Offset(2, 10),
                                  )
                                ]),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: weightController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your weight";
                                } else if (!RegExp(r'^\d+(\.\d+)?$')
                                    .hasMatch(value)) {
                                  return "Enter valid weight(in kgs)";
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[100],
                                ),
                                labelText: "Weight(in kgs)",
                                hintText: "Weight(in kgs)",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          //Height
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF87CEEB),
                                    blurRadius: 20,
                                    offset: Offset(2, 10),
                                  )
                                ]),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: heightController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your height";
                                }
                                ;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[100],
                                ),
                                labelText: "Height(in cms)",
                                hintText: "Height(in cms)",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyRoutes.sleepScheduleRoute);
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
                                  "Next",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    ));
  }
}
