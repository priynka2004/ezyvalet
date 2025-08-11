import 'package:ezyvalet/authintiction/service/forget_password_service.dart';
import 'package:flutter/material.dart';

class ForgetPasswordProvider with ChangeNotifier {
  String? errorMessage;

  Future<void> sendForgetPassword(String email) async {
    errorMessage = await ForgetPasswordService().sendForgetPassword(email);
    notifyListeners();
  }
}
