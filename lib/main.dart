import 'package:ezyvalet/screens/ezy_valet_screen.dart';
import 'package:ezyvalet/unused_screen/main_navigation_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(StitchDataApp());
}

class StitchDataApp extends StatelessWidget {
  const StitchDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stitch Data',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFFF9500),
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Inter',
      ),
      home: EzyValetScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
