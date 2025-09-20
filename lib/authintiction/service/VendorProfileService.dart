import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class ProfileService {
  final TokenService tokenService;
  final String baseUrl = "https://ezyvalet.bonanso.com/vendors/";

  ProfileService({required this.tokenService});

  // dynamic _parseResponse(http.Response response) {
  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception("Error ${response.statusCode}: ${response.body}");
  //   }
  // }

  dynamic _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return []; // empty list return kar do instead of crash
      }
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed with status: ${response.statusCode}");
    }
  }


  /// ✅ GET all vendors
  Future<List<dynamic>> getProfiles() async {
    final token = await tokenService.getAccessToken();
    if (token == null || token.isEmpty) throw Exception("Token missing");

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint("GET Profile Status: ${response.statusCode}");
    debugPrint("GET Profile Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data; // ✅ directly list return
      } else if (data is Map<String, dynamic>) {
        return [data];
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      throw Exception("Failed: ${response.statusCode}");
    }
  }


  /// ✅ GET single profile by ID
  Future<Map<String, dynamic>> getProfileById(int id) async {
    final token = await tokenService.getAccessToken();
    if (token == null || token.isEmpty) throw Exception("Token missing");

    final response = await http.get(
      Uri.parse("$baseUrl$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final data = _parseResponse(response);
    if (data is Map<String, dynamic>) return data;
    throw Exception("Unexpected response format: ${data.runtimeType}");
  }

  /// ✅ PUT (replace) profile
  Future<Map<String, dynamic>> updateProfile(int id, Map<String, dynamic> body) async {
    final token = await tokenService.getAccessToken();
    if (token == null || token.isEmpty) throw Exception("Token missing");

    final response = await http.put(
      Uri.parse("$baseUrl$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = _parseResponse(response);
    if (data is Map<String, dynamic>) return data;
    throw Exception("Unexpected response format: ${data.runtimeType}");
  }

  /// ✅ PATCH (partial update) profile
  Future<Map<String, dynamic>> patchProfile(int id, Map<String, dynamic> body) async {
    final token = await tokenService.getAccessToken();
    if (token == null || token.isEmpty) throw Exception("Token missing");

    final response = await http.patch(
      Uri.parse("$baseUrl$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = _parseResponse(response);
    if (data is Map<String, dynamic>) return data;
    throw Exception("Unexpected response format: ${data.runtimeType}");
  }

  /// ✅ DELETE profile
  Future<bool> deleteProfile(int id) async {
    final token = await tokenService.getAccessToken();
    if (token == null || token.isEmpty) throw Exception("Token missing");

    final response = await http.delete(
      Uri.parse("$baseUrl$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

}
