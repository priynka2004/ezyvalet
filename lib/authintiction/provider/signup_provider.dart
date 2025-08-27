// import 'package:ezyvalet/authintiction/service/signup_service.dart';
// import 'package:flutter/material.dart';
//
// class SignupProvider with ChangeNotifier {
//   bool _loading = false;
//   String? _errorMessage;
//
//   bool get loading => _loading;
//   String? get errorMessage => _errorMessage;
//
//   Future<bool> signup(Map<String, dynamic> body) async {
//     _loading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     final response = await SignupService().signupVendor(body);
//
//     _loading = false;
//     if (response["success"]) {
//       notifyListeners();
//       return true;
//     } else {
//       _errorMessage = response["message"];
//       notifyListeners();
//       return false;
//     }
//   }
// }



import 'package:ezyvalet/authintiction/service/signup_service.dart';
import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  bool _loading = false;
  String? _errorMessage;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<bool> signup(Map<String, dynamic> body) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SignupService().signupVendor(body);

      _loading = false;

      // Defensive check (agar response map nahi hua ya keys missing hui to)
      if (response != null && response is Map<String, dynamic>) {
        if (response["success"] == true) {
          notifyListeners();
          return true;
        } else {
          _errorMessage = response["message"] ?? "Something went wrong";
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = "Invalid response from server";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _loading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
