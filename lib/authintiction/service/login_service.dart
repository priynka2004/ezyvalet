import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = "http://ezyvalet.bonanso.com/auth/login/";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(baseUrl);
    final body = {"email": email, "password": password};

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        await TokenService().saveTokens(data["access"], data["refresh"]);

        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": json.decode(response.body)["message"] ?? "Login failed"
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
