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

    final response = await SignupService().signupVendor(body);

    _loading = false;
    if (response["success"]) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = response["message"];
      notifyListeners();
      return false;
    }
  }
}
