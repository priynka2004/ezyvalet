import 'package:ezyvalet/authintiction/service/change_password_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordProvider with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ChangePasswordService().changePassword(
      token: token,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    isLoading = false;

    if (result["success"]) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result["message"];
      notifyListeners();
      return false;
    }
  }
}
