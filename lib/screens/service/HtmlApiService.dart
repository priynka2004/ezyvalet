import 'dart:convert';
import 'package:http/http.dart' as http;

class HtmlApiService {
  static Future<String?> fetchHtmlContent(String url, String token) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized! Token expired or invalid");
      } else {
        throw Exception(
            "Failed to load content. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
