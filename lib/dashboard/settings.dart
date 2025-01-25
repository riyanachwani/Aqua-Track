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

  ImageProvider backgroundImage(String data) {
    if (data == 'Male') {
      return AssetImage('assets/images/man.png');
    } else if (data == 'Female') {
      return AssetImage('assets/images/woman.png');
    } else {
      return AssetImage('assets/images/user.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
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
              var userData =
                  _userService.getUserDataFromSnapshot(snapshot.data!);
              String Name = userData['Name'] ?? 'No Name';
              String Gender = userData['Gender'] ?? 'No Gender';
              int Age = userData['Age'] ?? 'No Age';



              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: backgroundImage(userData[
                                  'Gender']), // Replace with actual asset
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      // Options Section
                      _buildSectionHeader('General'),
                      _buildListTile(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.water_drop,
                        title: 'Daily Goal',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.palette,
                        title: 'Theme',
                        onTap: () {},
                      ),
                      const Divider(),

                      _buildSectionHeader('Account'),
                      _buildListTile(
                        icon: Icons.lock,
                        title: 'Privacy',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.security,
                        title: 'Security',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () {},
                      ),
                      const Divider(),

                      _buildSectionHeader('Support'),
                      _buildListTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.info_outline,
                        title: 'About Us',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
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

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
