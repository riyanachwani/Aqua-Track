import 'dart:developer';

import 'package:aquatrack/main.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:aquatrack/utils/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserService _userService = UserService();

  void _showUpdateDialog(
      String fieldName, String userId, Function(String) onSave) {
    String? selectedValue;

    // Add variables for hours and minutes selection
    int selectedHour = 6; // Default hour (6 AM)
    int selectedMinute = 30; // Default minute (30)

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update $fieldName'),
        content: Container(
          constraints: BoxConstraints(maxHeight: 300), // Limit max height
          child: fieldName == 'Gender'
              ? DropdownButtonFormField<String>(
                  value: selectedValue, // Initial value
                  hint: Text('Select Gender'),
                  items: ['Male', 'Female', 'Other'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedValue = newValue!;
                  },
                )
              : fieldName == 'Wake-up Time' || fieldName == 'Bedtime'
                  // If it's Wake-up or Bedtime, show time pickers
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 150, // Limit the height
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: selectedHour,
                                  ),
                                  itemExtent: 50,
                                  onSelectedItemChanged: (int value) {
                                    selectedHour = value;
                                  },
                                  children:
                                      List<Widget>.generate(24, (int index) {
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
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 150, // Limit the height
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: selectedMinute,
                                  ),
                                  itemExtent: 50,
                                  onSelectedItemChanged: (int value) {
                                    selectedMinute = value;
                                  },
                                  children:
                                      List<Widget>.generate(60, (int index) {
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
                    )
                  : TextField(
                      decoration:
                          InputDecoration(hintText: 'Enter new $fieldName'),
                      onChanged: (value) {
                        selectedValue = value;
                      },
                    ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String updatedValue;

              if (fieldName == 'Wake-up Time' || fieldName == 'Bedtime') {
                updatedValue =
                    '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
              } else {
                updatedValue = selectedValue ?? '';
              }

              if (updatedValue.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please select a value"),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              try {
                await onSave(updatedValue);
                Navigator.pop(context);
                setState(() {}); // Refresh UI
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$fieldName updated successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                log('Error updating $fieldName: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to update $fieldName"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Fetch the user ID first
      future: _userService.getUserId(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userIdSnapshot.hasError) {
          return Center(child: Text('Error: ${userIdSnapshot.error}'));
        }

        if (!userIdSnapshot.hasData) {
          return const Center(child: Text('No user logged in'));
        }

        String userId = userIdSnapshot.data!;

        // Use the user ID to fetch the user settings
        return FutureBuilder<DocumentSnapshot>(
          future: _userService.getUserSettings(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No user data found'));
            }

            // Extract the data using the updated function
            var userData = _userService.getUserDataFromSnapshot(snapshot.data!);
            int Age = userData['Age'] ?? 0;
            double targetIntake = userData['targetIntake'] ?? 0.0;

            String Gender = userData['Gender'];

            double dailyGoal = userData['targetIntake'];
            String wakeupTime = userData['Wake-up Time'] ?? 'Not Set';
            String Bedtime = userData['Bedtime'] ?? 'Not Set';
            double Weight = userData['Weight'] ?? 0.0;
            double Height = userData['Height'] ?? 0;
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Options Section
                    _buildSectionHeader('Settings'),
                    _buildListTile(
                        'assets/images/notification.png', 'Notifications', '',
                        () {
                      Navigator.pushNamed(context, MyRoutes.notificationRoute);
                    }, context),
                    _buildListTile(
                        'assets/images/theme.png', 'Theme', '', null, context,
                        trailing: Switch(
                          value: Provider.of<ThemeModel>(context).mode ==
                              ThemeMode.dark,
                          onChanged: (_) =>
                              Provider.of<ThemeModel>(context, listen: false)
                                  .toggleTheme(),
                        )),
                    _buildListTile(
                      'assets/images/ribbon.png',
                      'Daily Goal',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '$targetIntake ml',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _showUpdateDialog('Daily Goal', userId,
                                  (newValue) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({
                                    'targetIntake': double.parse(newValue)
                                  });
                                  setState(() {}); // Refresh UI
                                } catch (e) {
                                  log('Error updating daily goal: $e');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    _buildListTile(
                      'assets/images/gender.png',
                      'Gender',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$Gender',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _showUpdateDialog('Gender', userId,
                                  (newValue) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({'Gender': newValue});
                                  setState(() {}); // Refresh UI
                                } catch (e) {
                                  log('Error updating gender: $e');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    _buildListTile(
                      'assets/images/age-group.png',
                      'Age',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$Age',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _showUpdateDialog('Age', userId,
                                  (newValue) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({'Age': newValue});
                                  setState(() {}); // Refresh UI
                                } catch (e) {
                                  log('Error updating age: $e');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    _buildListTile(
                      'assets/images/weight.png',
                      'Weight',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$Weight',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _showUpdateDialog('Weight', userId,
                                  (newValue) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({'Weight': newValue});
                                  setState(() {}); // Refresh UI
                                } catch (e) {
                                  log('Error updating weight: $e');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    _buildListTile(
                      'assets/images/sun.png',
                      'Wake-up Time',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$wakeupTime',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _showUpdateDialog('Wake-up Time', userId,
                                  (newValue) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({'Wake-up Time': newValue});
                                  setState(() {}); // Refresh UI
                                } catch (e) {
                                  log('Error updating wake-up time: $e');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    _buildListTile(
                      'assets/images/moon-settings.png',
                      'Bedtime',
                      '',
                      null,
                      context,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$Bedtime',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png',
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _showUpdateDialog('Bedtime', userId,
                                  (newValue) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({'Bedtime': newValue});
                                  setState(() {}); // Refresh UI
                                } catch (e) {
                                  log('Error updating bedtime: $e');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const Divider(),
                    _buildSectionHeader('Support'),
                    _buildListTile('assets/images/share.png', 'Share', '', () {
                      // Add share functionality here
                    }, context),
                    _buildListTile('assets/images/review.png', 'Feedback', '',
                        () {
                      // Add feedback functionality here
                    }, context),
                    _buildListTile(
                        'assets/images/insurance.png', 'Privacy Policy', '',
                        () {
                      // Add privacy policy functionality here
                    }, context),
                    const Divider(),
                    _buildListTile('assets/images/logout.png', 'Logout', '',
                        () {
                      // Add logout functionality here
                    }, context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile(String imagePath, String title, String value,
      VoidCallback? onTap, BuildContext context,
      {Widget? trailing}) {
    // Assign a default trailing widget if none is provided
    Widget defaultTrailing;

    if (trailing != null) {
      defaultTrailing = trailing; // Use the trailing passed as a parameter
    } else if (['Notifications', 'Share', 'Feedback', 'Privacy Policy']
        .contains(title)) {
      defaultTrailing =
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);
    } else if (title == 'Theme') {
      defaultTrailing = Switch(
        value: Provider.of<ThemeModel>(context).mode == ThemeMode.dark,
        onChanged: (_) =>
            Provider.of<ThemeModel>(context, listen: false).toggleTheme(),
        activeColor: Colors.blue[800],
      );
    } else {
      defaultTrailing = Text(value,
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white));
    }

    return ListTile(
      leading: Image.asset(imagePath,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          width: 30),
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white)),
      trailing: Padding(
        padding:
            const EdgeInsets.only(left: 8.0), // Adjust padding if necessary
        child: defaultTrailing,
      ),
      onTap: onTap,
    );
  }
}
