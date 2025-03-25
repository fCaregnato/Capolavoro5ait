import 'package:flutter/material.dart';
import 'package:test1/pages/navPages/navHome/nav_home.dart';
import 'package:test1/pages/navPages/nav_info.dart';
import 'package:test1/pages/navPages/nav_profile.dart';
import 'package:test1/pages/navPages/nav_settings.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String password;

  const HomePage({super.key, required this.username, required this.password});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Size mediaSize;
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePageWidget(username: widget.username, password: widget.password),
      InfoPageWidget(),
      SettingsPageWidget(),
      ProfilePageWidget(username: widget.username),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.orange,
            Colors.orangeAccent,
            Colors.purpleAccent,
            Colors.purple,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Locks&go'),
          leading: const Icon(Icons.lock),
          centerTitle: false,
          backgroundColor: Colors.white.withAlpha(80),
          elevation: 0,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white.withAlpha(150),
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.blueGrey[900],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'Info',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
