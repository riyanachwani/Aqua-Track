import 'package:flutter/material.dart';
import 'package:aquatrack/dashboard/home.dart';
import 'package:aquatrack/dashboard/settings.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page, // Dynamically update the page view
        children: const [
          HomePage(),
          HistoryPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: BottomAppBar(
          color: Colors.transparent,
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
