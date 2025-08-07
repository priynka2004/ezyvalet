import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/unused_screen/RevenueSummaryScreen.dart';
import 'package:ezyvalet/unused_screen/SettingsScreen.dart';
import 'package:ezyvalet/unused_screen/home_tasks_screen.dart';
import 'package:ezyvalet/unused_screen/vehicle_secure_screens.dart';
import 'package:flutter/material.dart';

class HomeNaviScreen extends StatefulWidget {
  const HomeNaviScreen({super.key});

  @override
  HomeNaviScreenState createState() => HomeNaviScreenState();
}

class HomeNaviScreenState extends State<HomeNaviScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeTasksScreen(),
    VehicleSecureScreen(),
    RevenueSummaryScreen(),
    SettingsScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.directions_car_filled), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.report_gmailerrorred), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}