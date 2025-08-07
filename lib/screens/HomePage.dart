import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/NewValetEntryScreen.dart';
import 'package:ezyvalet/screens/active_valet_screen.dart';
import 'package:flutter/material.dart';
import 'requests_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    NewValetEntryScreen(),
    ActiveValetScreen(),
    RequestsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.button,
        unselectedItemColor:AppColors.dark,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Valet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num_outlined),
            label: 'Active',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}
