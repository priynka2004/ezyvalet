import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/authintiction/service/LogoutService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final LogoutService _logoutService = LogoutService();

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString("refresh_token"); // match TokenService

    if (refreshToken == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _logoutService.logout();

    if (result["success"]) {
      await prefs.setBool('isLoggedIn', false);
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const VendorLoginScreen()),
            (route) => false,
      );
    } else {
      debugPrint("Logout failed: ${result["message"]}");
    }

    _isLoading = false;
    notifyListeners();
  }

}
