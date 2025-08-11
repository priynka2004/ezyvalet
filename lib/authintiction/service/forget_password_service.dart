import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgetPasswordService {
  Future<String?> sendForgetPassword(String email) async {
    final url = Uri.parse("http://ezyvalet.bonanso.com/auth/forget/password/");

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return null; // Success
      } else {
        final data = jsonDecode(response.body);
        return data["error"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
