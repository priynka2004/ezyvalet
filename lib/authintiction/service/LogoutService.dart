import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ezyvalet/authintiction/service/token_service.dart';

class LogoutService {
  static const String baseUrl = "http://ezyvalet.bonanso.com/auth/logout/";

  Future<Map<String, dynamic>> logout() async {
    try {
      final refreshToken = await TokenService().getRefreshToken();

      if (refreshToken == null) {
        return {"success": false, "message": "No refresh token found"};
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"refresh": refreshToken}),
      );

      print("Logout response status: ${response.statusCode}");
      print("Logout response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 205) {
        return {"success": true, "data": response.body.isNotEmpty ? jsonDecode(response.body) : null};
      } else {
        String message = "Logout failed";
        if (response.body.isNotEmpty) {
          try {
            final decoded = jsonDecode(response.body);
            message = decoded["message"] ?? message;
          } catch (_) {}
        }
        return {"success": false, "message": message};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
