import 'dart:developer';

import 'package:aquatrack/utils/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserService _userService = UserService();

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
            String Name = userData['Name'] ?? 'No Name';
            String Gender = userData['Gender'] ?? 'No Gender';
            int Age = userData['Age'] ?? 'No Age';
            double targetIntake = userData['targetIntake'] ?? 0.0;

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
                        'assets/images/notification.png', 'Notifications', ''),
                    _buildListTile('assets/images/theme.png', 'Theme', ''),
                    _buildListTile('assets/images/ribbon.png', 'Daily Goal',
                        '$targetIntake ml'),
                    _buildListTile(
                        'assets/images/gender.png', 'Gender', '$Gender'),
                    _buildListTile('assets/images/weight.png', 'Weight', ''),
                    _buildListTile('assets/images/sun.png', 'Wake-up Time', ''),
                    _buildListTile(
                        'assets/images/moon-settings.png', 'Bedtime', ''),
                    const Divider(),
                    _buildSectionHeader('Support'),
                    _buildListTile('assets/images/share.png', 'Share', ''),
                    _buildListTile('assets/images/review.png', 'Feedback', ''),
                    _buildListTile(
                        'assets/images/insurance.png', 'Privacy Policy', ''),
                    const Divider(),
                    _buildListTile('assets/images/logout.png', 'Logout', ''),
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

  Widget _buildListTile(String imagePath, String title, String value) {
    return ListTile(
      leading: Image.asset(imagePath, width: 30),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: (title == 'Notifications' ||
              title == 'Share' ||
              title == 'Feedback' ||
              title == 'Privacy Policy')
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}
