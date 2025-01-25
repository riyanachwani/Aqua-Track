import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
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
                    backgroundImage: AssetImage('assets/images/profile.jpg'), // Replace with actual asset
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
