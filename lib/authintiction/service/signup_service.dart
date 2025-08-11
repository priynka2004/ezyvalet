import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static const String baseUrl = "http://ezyvalet.bonanso.com/auth/signup/";

  Future<Map<String, dynamic>> signupVendor(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(body),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)["message"] ?? "Signup failed"
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
