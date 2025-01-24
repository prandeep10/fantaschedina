import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
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
              // Title Text for Settings Section
              Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 79, 52, 52),
                ),
              ),
              SizedBox(height: 30),

              // Buttons for Settings Actions
              Column(
                children: [
                  _buildSettingsButton(context, 'Change Password', Icons.lock,
                      () {
                    // Implement Change Password functionality
                  }),
                  _buildSettingsButton(
                      context, 'Notification Settings', Icons.notifications,
                      () {
                    // Implement Notification Settings functionality
                  }),
                  _buildSettingsButton(
                      context, 'Privacy Settings', Icons.privacy_tip, () {
                    // Implement Privacy Settings functionality
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create buttons for settings actions
  Widget _buildSettingsButton(BuildContext context, String label, IconData icon,
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
