import 'package:fantaschedina/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/standings_screen.dart';
import 'screens/settings_screen.dart'; // Import the correct SettingsScreen

void main() {
  runApp(FantaSchedinaApp());
}

class FantaSchedinaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FantaSchedina',
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
        hintColor: Colors.yellowAccent,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black26,
                offset: Offset(2, 2),
              ),
            ],
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ),
      home: MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    HomeScreen(),
    CalendarScreen(),
    StandingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FantaSchedina'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Profile Icon
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          // Settings Icon
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to Settings Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen()), // Corrected import
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).hintColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Standings',
          ),
        ],
      ),
    );
  }
}
