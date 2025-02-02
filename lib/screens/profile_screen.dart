// profile_screen.dart
import 'package:flutter/material.dart';
import 'profile_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userProfile = {
    'name': 'John Doe',
    'competitions': 5,
    'totalPoints': 450,
    'rank': '1st',
    'winRate': '75%',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildProfileHeader(),
              SizedBox(height: 30),
              _buildStatsSection(),
              SizedBox(height: 30),
              _buildActionButtons(context),
              SizedBox(height: 20),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/default_avatar.png'),
          backgroundColor: Colors.grey.shade300,
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userProfile['name'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              Text(
                'Competitions: ${userProfile['competitions']}',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow('Total Points', '${userProfile['totalPoints']}'),
          Divider(),
          _buildStatRow('Current Rank', userProfile['rank']),
          Divider(),
          _buildStatRow('Win Rate', userProfile['winRate']),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          context,
          'Edit Profile',
          Icons.edit,
          () {},
        ),
        SizedBox(height: 10),
        _buildActionButton(
          context,
          'Settings',
          Icons.settings,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          ),
        ),
        SizedBox(height: 10),
        _buildActionButton(
          context,
          'FAQ',
          Icons.help_outline,
          () {},
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
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
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

// settings_screen.dart
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            'Account Settings',
            [
              _buildSettingsTile(
                'Change Password',
                Icons.lock_outline,
                onTap: () {},
              ),
              _buildSettingsTile(
                'Email Preferences',
                Icons.email_outlined,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSettingsSection(
            'App Settings',
            [
              _buildSwitchTile(
                'Push Notifications',
                Icons.notifications_none,
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
              ),
              _buildSwitchTile(
                'Dark Mode',
                Icons.dark_mode_outlined,
                _darkModeEnabled,
                (value) => setState(() => _darkModeEnabled = value),
              ),
              _buildLanguageSelector(),
            ],
          ),
          SizedBox(height: 20),
          _buildSettingsSection(
            'Support',
            [
              _buildSettingsTile(
                'Help Center',
                Icons.help_outline,
                onTap: () {},
              ),
              _buildSettingsTile(
                'Privacy Policy',
                Icons.privacy_tip_outlined,
                onTap: () {},
              ),
              _buildSettingsTile(
                'Terms of Service',
                Icons.description_outlined,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue.shade900,
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading: Icon(Icons.language, color: Colors.blue.shade900),
      title: Text('Language'),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        items: ['English', 'Italian', 'Spanish']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (newValue) {
          setState(() => _selectedLanguage = newValue!);
        },
      ),
    );
  }
}
