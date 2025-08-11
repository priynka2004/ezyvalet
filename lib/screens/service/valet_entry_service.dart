import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:http/http.dart' as http;

class ValetEntryService {
  final TokenService _tokenService = TokenService();

  Future<bool> createValetEntry({
    required String carPlateNumber,
    required String customerMobileNumber,
  }) async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) {
        print("No access token found");
        return false;
      }

      final url = Uri.parse("http://ezyvalet.bonanso.com/valet/create/");
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "car_plate_number": carPlateNumber,
          "customer_mobile_number": customerMobileNumber,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error creating valet entry: $e");
      return false;
    }
  }
}
