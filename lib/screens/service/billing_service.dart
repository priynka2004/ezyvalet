import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:http/http.dart' as http;

class BillingService {
  final String baseUrl = "https://ezyvalet.bonanso.com/billing/management/data/";

  Future<List<Map<String, dynamic>>> fetchBillingData(String token) async {
    final tokenService = TokenService();
    final accessToken = await tokenService.getAccessToken();

    if (accessToken == null) {
      throw Exception("No access token found. Please login again.");
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception("Failed to fetch billing data: ${response.statusCode} - ${response.body}");
    }
  }
}
