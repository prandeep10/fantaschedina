import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatelessWidget {
  // Renamed to avoid conflict
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 52, 52),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  buildSettingsButton(
                    context,
                    'Change Password',
                    Icons.lock,
                    () {},
                  ),
                  buildSettingsButton(
                    context,
                    'Notification Settings',
                    Icons.notifications,
                    () {},
                  ),
                  buildSettingsButton(
                    context,
                    'Privacy Settings',
                    Icons.privacy_tip,
                    () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingsButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
