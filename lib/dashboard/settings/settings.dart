import 'dart:developer';

import 'package:aquatrack/main.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:aquatrack/utils/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update $fieldName'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new $fieldName'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await onSave(controller.text);
              Navigator.pop(context);
              setState(() {}); // Refresh UI
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
            String wakeupTime = userData['WakeupTime'] ?? 'Not Set';
            String bedtime = userData['Bedtime'] ?? 'Not Set';

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
                    }),
                    _buildListTile('assets/images/theme.png', 'Theme', '', null,
                        trailing: Switch(
                          value: Provider.of<ThemeModel>(context).mode ==
                              ThemeMode.dark,
                          onChanged: (_) =>
                              Provider.of<ThemeModel>(context, listen: false)
                                  .toggleTheme(),
                        )),
                    _buildListTile('assets/images/ribbon.png', 'Daily Goal',
                        '$targetIntake ml', () {}),
                    _buildListTile(
                        'assets/images/gender.png', 'Gender', '$Gender', () {}),
                    _buildListTile(
                        'assets/images/age-group.png', 'Age', '$Age', () {}),
                    _buildListTile(
                        'assets/images/weight.png', 'Weight', '', () {}),
                    _buildListTile(
                        'assets/images/sun.png', 'Wake-up Time', '', () {}),
                    _buildListTile('assets/images/moon-settings.png', 'Bedtime',
                        '', () {}),
                    const Divider(),
                    _buildSectionHeader('Support'),
                    _buildListTile('assets/images/share.png', 'Share', '', () {
                      // Add share functionality here
                    }),
                    _buildListTile('assets/images/review.png', 'Feedback', '',
                        () {
                      // Add feedback functionality here
                    }),
                    _buildListTile(
                        'assets/images/insurance.png', 'Privacy Policy', '',
                        () {
                      // Add privacy policy functionality here
                    }),
                    const Divider(),
                    _buildListTile('assets/images/logout.png', 'Logout', '',
                        () {
                      // Add logout functionality here
                    }),
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

  Widget _buildListTile(
      String imagePath, String title, String value, VoidCallback? onTap,
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
      );
    } else {
      defaultTrailing = Text(value, style: const TextStyle(fontSize: 16));
    }

    return ListTile(
      leading: Image.asset(imagePath, width: 30),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: defaultTrailing,
      onTap: onTap,
    );
  }
}
