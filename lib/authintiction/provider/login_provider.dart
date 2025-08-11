import 'package:ezyvalet/authintiction/service/login_service.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _loginService.login(email, password);

    _loading = false;
    if (result["success"]) {
      _token = result["token"];
      notifyListeners();
      return true;
    } else {
      _errorMessage = result["message"];
      notifyListeners();
      return false;
    }
  }
}
