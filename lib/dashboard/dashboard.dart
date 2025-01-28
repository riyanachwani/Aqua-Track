import 'package:aquatrack/utils/user_services.dart';
import 'package:flutter/material.dart';
import 'package:aquatrack/dashboard/home.dart';
import 'package:aquatrack/dashboard/settings/settings.dart';
import 'package:aquatrack/dashboard/history.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0; // Default to 0 for HomePage
  Color _homeIconColor = Colors.blue[800]!; // Default home icon color
  Color _settingsIconColor = Colors.grey;

  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.lightBlueAccent, Colors.white]
                : [Colors.black, Colors.grey[800]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: IndexedStack(
          index: _page, // Dynamically update the page view
          children: const [
            HomePage(),
            HistoryPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: BottomAppBar(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _page = 0;
                    _homeIconColor = Colors.blue[800]!; // Highlight home icon
                    _settingsIconColor = Colors.grey;
                  });
                },
                icon: Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _homeIconColor == Colors.blue[800]
                        ? Colors.blue[800]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.water_drop,
                      size: 30,
                      color: _homeIconColor == Colors.blue[800]
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _page = 2;
                    _homeIconColor = Colors.grey;
                    _settingsIconColor =
                        Colors.blue[800]!; // Highlight settings icon
                  });
                },
                icon: Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _settingsIconColor == Colors.blue[800]
                        ? Colors.blue[800]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.settings,
                      size: 30,
                      color: _settingsIconColor == Colors.blue[800]
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
