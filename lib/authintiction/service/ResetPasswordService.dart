import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  Future<String?> resetPassword({
    required String uid,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse("http://ezyvalet.bonanso.com/auth/reset/password/");

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "uid": uid,
          "token": token,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        final data = jsonDecode(response.body);
        return data["error"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
