import 'package:flutter/material.dart';
import 'package:aquatrack/dashboard/home.dart';
import 'package:aquatrack/dashboard/settings.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0;
  Color _homeIconColor = Colors.grey;
  Color _historyIconColor = Colors.grey;
  Color _settingsIconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: const [
          HomePage(),
          SettingsPage(),
        ],
      ),
      extendBody: true,
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
                    _homeIconColor = Colors.blue[800]!;
                    _historyIconColor = Colors.grey;
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
                    _page = 0;
                    _homeIconColor = Colors.grey;
                    _historyIconColor = Colors.blue[800]!;
                    _settingsIconColor = Colors.grey;
                  });
                },
                icon: Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _historyIconColor == Colors.blue[800]
                        ? Colors.blue[800]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.history,
                      size: 30,
                      color: _historyIconColor == Colors.blue[800]
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _page = 1;
                    _homeIconColor = Colors.grey;
                    _historyIconColor = Colors.grey;
                    _settingsIconColor = Colors.blue[800]!;
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
