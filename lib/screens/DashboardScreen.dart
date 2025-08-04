import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/images.png'),
          ),
        ),
        title: Text(
          'Dashboard',
          style: AppTextStyles.sectionTitle
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _infoCard("Total Cars Parked", "234")),
                const SizedBox(width: 12),
                Expanded(child: _infoCard("Average Retrieval Time", "5 min")),
              ],
            ),

            const SizedBox(height: 12),
            _infoCard("Customer Satisfaction", "95%", isFullWidth: true),
            const SizedBox(height: 24),
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _activityItem("Vehicle Drop-off", "Valet: Alex", "10:15 AM"),
            _activityItem("Vehicle Pick-up", "Valet: Ben", "10:05 AM"),
            _activityItem("Vehicle Drop-off", "Valet: Chris", "9:50 AM"),
            _activityItem("Vehicle Pick-up", "Valet: David", "9:40 AM"),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: const Color(0xFF9C854A),
      //   unselectedItemColor: Colors.black54,
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      //     BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staff'),
      //     BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      //   ],
      // ),
    );
  }

  Widget _infoCard(String title, String value, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      margin: EdgeInsets.only(top: isFullWidth ? 0 : 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelStyle),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.hintStyle),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9C854A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}