import 'package:ezyvalet/authintiction/service/ResetPasswordService.dart';
import 'package:flutter/material.dart';

class ResetPasswordProvider with ChangeNotifier {
  String? errorMessage;

  Future<void> resetPassword({
    required String uid,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    errorMessage = await ResetPasswordService().resetPassword(
      uid: uid,
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    notifyListeners();
  }
}
