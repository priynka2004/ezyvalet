// import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
// import 'package:ezyvalet/authintiction/service/LogoutService.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LogoutProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   final LogoutService _logoutService = LogoutService();
//
//   Future<void> logout(BuildContext context) async {
//     _isLoading = true;
//     notifyListeners();
//
//     final prefs = await SharedPreferences.getInstance();
//     String? refreshToken = prefs.getString("refresh_token");
//
//     if (refreshToken == null) {
//       _isLoading = false;
//       notifyListeners();
//       return;
//     }
//
//     final result = await _logoutService.logout();
//
//     if (result["success"]) {
//       await prefs.setBool('isLoggedIn', false);
//       await prefs.clear();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Logout successful"),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );
//
//       Future.delayed(const Duration(milliseconds: 500), () {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const VendorLoginScreen()),
//               (route) => false,
//         );
//       });
//     } else {
//       debugPrint("Logout failed: ${result["message"]}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result["message"] ?? "Logout failed"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
// }


import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/authintiction/service/LogoutService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class LogoutProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final LogoutService _logoutService = LogoutService();

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString("refresh_token");

    if (refreshToken == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _logoutService.logout();

    if (result["success"]) {
      await prefs.setBool('isLoggedIn', false);
      await prefs.clear();

      CherryToast.success(
        title: const Text("Logout successful"),
        animationType: AnimationType.fromTop,
        toastDuration: const Duration(seconds: 2),
      ).show(context);

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const VendorLoginScreen()),
              (route) => false,
        );
      });
    } else {
      debugPrint("Logout failed: ${result["message"]}");


      CherryToast.error(
        title: Text(result["message"] ?? "Logout failed"),
        animationType: AnimationType.fromBottom,
        toastDuration: const Duration(seconds: 2),
      ).show(context);
    }

    _isLoading = false;
    notifyListeners();
  }
}
