import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goldColor = const Color(0xFF9C854A);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView(
          children: [
            const SectionTitle(title: 'Account',),
            const SizedBox(height: 8),
            SettingTile(
              icon: Icons.business_outlined,
              title: 'Business Information',
              subtitle: 'Business Name, Contact Info',
              subtitleColor: goldColor,
            ),
            SettingTile(
              icon: Icons.payment_outlined,
              title: 'Payment Settings',
              subtitle: 'Payment Methods, Billing Details',
              subtitleColor: goldColor,
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'App Preferences'),
            const SizedBox(height: 8),
            SettingTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Push Notifications, Email Alerts',
              subtitleColor: goldColor,
            ),
            SettingTile(
              icon: Icons.settings_outlined,
              title: 'General',
              subtitle: 'Language, Theme',
              subtitleColor: goldColor,
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Support'),
            const SizedBox(height: 8),
            SettingTile(
              icon: Icons.help_outline,
              title: 'Help Center',
            ),
            SettingTile(
              icon: Icons.lock_outline,
              title: 'Contact Support',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style:AppTextStyles.title,);
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title, style:AppTextStyles.buttonDarkText),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: subtitleColor ?? Colors.grey))
          : null,
    );
  }
}
