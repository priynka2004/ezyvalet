import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse("http://ezyvalet.bonanso.com/auth/change/password/");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return {"success": true, "message": "Password changed successfully"};
    } else {
      return {
        "success": false,
        "message": jsonDecode(response.body)["error"] ?? "Failed to change password"
      };
    }
  }
}
