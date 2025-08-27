import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ezyvalet/authintiction/service/token_service.dart';

class StaffService {
  final String baseUrl = "https://ezyvalet.bonanso.com";
  final TokenService _tokenService = TokenService();

  Future<List<Map<String, dynamic>>> getStaffList() async {
    try {
      final token = await _tokenService.getAccessToken();
      final url = Uri.parse("$baseUrl/staff/");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("GET Staff Status: ${response.statusCode}");
      print("GET Staff Response: ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print("Error fetching staff list: $e");
    }
    return [];
  }

  Future<bool> addStaff(String name) async {
    final token = await _tokenService.getAccessToken();
    final response = await http.post(
      Uri.parse("$baseUrl/staff/"),

      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"staff_name": name}), // ✅ correct field
    );

    print("POST Staff Status: ${response.statusCode}");
    print("POST Staff Response: ${response.body}");

    return response.statusCode == 201;
  }

  Future<bool> updateStaff(int id, String name) async {
    final token = await _tokenService.getAccessToken();

    final response = await http.put(
      Uri.parse("$baseUrl/staff/$id/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"staff_name": name}),
    );

    print("PUT Staff Status: ${response.statusCode}");
    print("PUT Staff Response: ${response.body}");

    return response.statusCode == 200;
  }


  Future<bool> deleteStaff(int id) async {
    try {
      final token = await _tokenService.getAccessToken();
      final url = Uri.parse("$baseUrl/staff/$id/");
      final response = await http.delete(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("DELETE Staff Status: ${response.statusCode}");
      return response.statusCode == 204;
    } catch (e) {
      print("Error deleting staff: $e");
      return false;
    }
  }

  Future<bool> markStaffActive(int id) async {
    try {
      final token = await _tokenService.getAccessToken();
      final url = Uri.parse("$baseUrl/mark/staff/active/$id/");
      final response = await http.patch(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("PATCH Active Status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("Error marking staff active: $e");
      return false;
    }
  }

  Future<bool> markStaffInactive(int id) async {
    try {
      final token = await _tokenService.getAccessToken();
      final url = Uri.parse("$baseUrl/mark/staff/inactive/$id/");
      final response = await http.patch(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("PATCH Inactive Status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("Error marking staff inactive: $e");
      return false;
    }
  }
}
