import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/authintiction/provider/ResetPasswordProvider.dart';
import 'package:ezyvalet/authintiction/provider/change_password_provider.dart';
import 'package:ezyvalet/authintiction/provider/forget_password_provider.dart';
import 'package:ezyvalet/authintiction/provider/login_provider.dart';
import 'package:ezyvalet/authintiction/provider/logout_provider.dart';
import 'package:ezyvalet/authintiction/provider/profile_provider.dart';
import 'package:ezyvalet/authintiction/provider/signup_provider.dart';
import 'package:ezyvalet/screens/HomePage.dart';
import 'package:ezyvalet/screens/ezy_valet_screen.dart';
import 'package:ezyvalet/screens/provider/ActiveValetProvider.dart';
import 'package:ezyvalet/screens/provider/ValetEntryProvider.dart';
import 'package:ezyvalet/screens/provider/billing_provider.dart';
import 'package:ezyvalet/screens/provider/request_provider.dart';
import 'package:ezyvalet/screens/service/staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(StitchDataApp(isLoggedIn: isLoggedIn));
}


class StitchDataApp extends StatelessWidget {
  final bool isLoggedIn;
  const StitchDataApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LogoutProvider()),
        ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ValetEntryProvider()),
        ChangeNotifierProvider(create: (_) => ActiveValetProvider()..loadActiveData()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
      ],
      child: MaterialApp(
        title: 'Stitch Data',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: const Color(0xFFFF9500),
          scaffoldBackgroundColor: Colors.grey[50],
          fontFamily: 'Inter',
        ),
       home: isLoggedIn ? const HomePage() : const EzyValetScreen(),
    debugShowCheckedModeBanner: false,
      ),
    );
  }
}
