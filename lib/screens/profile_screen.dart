import 'package:flutter/material.dart';
import 'settings_screen.dart'; // Import SettingsScreen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
        actions: [
          // Settings Icon (for navigation to settings)
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center everything vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center everything horizontally
            children: [
              // User Info Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center user info
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('https://www.example.com/user-avatar.jpg'),
                  ),
                  SizedBox(width: 16),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 95, 65, 65),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Competitions Joined: 5',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(179, 110, 82, 82),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Buttons for Actions (Edit Profile, Settings, FAQs)
              Column(
                children: [
                  _buildProfileButton(context, 'Edit Profile', Icons.edit, () {
                    // Implement navigation to Edit Profile screen
                  }),
                  _buildProfileButton(context, 'Settings', Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }),
                  _buildProfileButton(context, 'FAQ', Icons.help_outline, () {
                    // Implement navigation to FAQ screen
                  }),
                ],
              ),
              SizedBox(height: 20),

              // Logout Button at the bottom
              ElevatedButton(
                onPressed: () {
                  // Implement logout functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Logout button color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity,
                      50), // Ensure button stretches to full width
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create buttons for profile actions
  Widget _buildProfileButton(BuildContext context, String label, IconData icon,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        label: Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize:
              Size(double.infinity, 50), // Button stretches across the screen
        ),
      ),
    );
  }
}
