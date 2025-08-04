import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/CityGuideScreen.dart';
import 'package:ezyvalet/screens/DashboardScreen.dart';
import 'package:ezyvalet/screens/SettingsScreen.dart';
import 'package:ezyvalet/screens/StaffPerformanceScreen.dart';
import 'package:ezyvalet/screens/HotelBookingScreen.dart';
import 'package:ezyvalet/screens/PreferencesScreen.dart';
import 'package:ezyvalet/screens/SecurityScreen.dart';
import 'package:ezyvalet/screens/StaffScreen.dart';
import 'package:ezyvalet/screens/SummaryScreen.dart';
import 'package:ezyvalet/screens/VehicleScreen.dart';
import 'package:ezyvalet/screens/VendorScreen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // EzyValetScreen(),
    // VendorScreen(),
    DashboardScreen(),
    StaffScreen(),
    StaffPerformanceScreen(),
    SettingsScreen(),
  //  SecurityScreen(),
   // SummaryScreen(),
   // PreferencesScreen(),
   // CityGuideScreen(),
   // VehicleScreen(),
  //  SecurityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.highlight,
        unselectedItemColor: AppColors.dark,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.report_gmailerrorred), label: 'Reports'),
         // BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}