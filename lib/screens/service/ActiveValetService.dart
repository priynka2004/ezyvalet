import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:http/http.dart' as http;

class ActiveValetService {
  final TokenService _tokenService = TokenService();

  // Active Count API
  Future<int?> fetchActiveCounts() async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final url = Uri.parse("http://ezyvalet.bonanso.com/valet/active/count/");
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Active Count Status: ${response.statusCode}");
      print("Active Count Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["count"] ?? 0;
      }
    } catch (e) {
      print("Error fetching active counts: $e");
    }
    return null;
  }

  // Active List API
  Future<List<Map<String, dynamic>>> fetchActiveList() async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) return [];

      final url = Uri.parse("http://ezyvalet.bonanso.com/valet/active/list/");
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Active List Status: ${response.statusCode}");
      print("Active List Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print("Error fetching active list: $e");
    }
    return [];
  }


  Future<bool> manualRelease(int valetId, String pin) async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) return false;

      final url = Uri.parse("http://ezyvalet.bonanso.com/valet/manual/release/$valetId/");
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"pin": pin}),
      );

      print("Manual Release Status: ${response.statusCode}");
      print("Manual Release Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error in manual release: $e");
      return false;
    }
  }

}
