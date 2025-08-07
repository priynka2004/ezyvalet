import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Preferences', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreferenceSection('Account Settings', [
              _buildPreferenceItem('Profile Information', Icons.person, () {}),
              _buildPreferenceItem('Change Password', Icons.lock, () {}),
              _buildPreferenceItem('Email Preferences', Icons.email, () {}),
            ]),
            SizedBox(height: 20),
            _buildPreferenceSection('App Settings', [
              _buildPreferenceItem('Notifications', Icons.notifications, () {}),
              _buildPreferenceItem('Language', Icons.language, () {}),
              _buildPreferenceItem('Theme', Icons.palette, () {}),
            ]),
            SizedBox(height: 20),
            _buildPreferenceSection('Support', [
              _buildPreferenceItem('Help Center', Icons.help, () {}),
              _buildPreferenceItem('Contact Support', Icons.support_agent, () {}),
              _buildPreferenceItem('About', Icons.info, () {}),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildPreferenceItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFFF9500)),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}
