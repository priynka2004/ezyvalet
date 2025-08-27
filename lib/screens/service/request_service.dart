import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:http/http.dart' as http;

class RequestService {
  final TokenService _tokenService = TokenService();
  final String baseUrl = "http://ezyvalet.bonanso.com";

  Future<List<Map<String, dynamic>>> fetchRequestList() async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) return [];

      final url = Uri.parse("$baseUrl/valet/request/list/");
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Request List Status: ${response.statusCode}");
      print("Request List Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey("requests")) {
          return List<Map<String, dynamic>>.from(data["requests"]);
        }
      }
    } catch (e) {
      print("Error fetching request list: $e");
    }
    return [];
  }

  Future<bool> verifyAndRelease(int id, String pin) async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) return false;

      final url = Uri.parse("$baseUrl/valet/request/verify/$id/");
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"pin": pin}),
      );

      print("Verify Status: ${response.statusCode}");
      print("Verify Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error verifying request: $e");
    }
    return false;
  }
}
