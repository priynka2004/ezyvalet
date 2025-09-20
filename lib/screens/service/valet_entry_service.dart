import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:ezyvalet/screens/model/ValetEntryResponse.dart';
import 'package:http/http.dart' as http;

class ValetEntryService {
  final TokenService _tokenService = TokenService();
  static const String baseUrl = "http://ezyvalet.bonanso.com";

  Future<ValetEntryResponse?> createValetEntry({
    required String carPlateNumber,
    required String customerMobileNumber,
    required int staffId,
  }) async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception("No access token found. Please login again.");
      }

      final response = await http.post(
        Uri.parse("http://ezyvalet.bonanso.com/valet/create/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "car_plate_number": carPlateNumber,
          "customer_mobile_number": customerMobileNumber,
          "staff_id": staffId,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ValetEntryResponse.fromJson(jsonDecode(response.body));
      } else {
        final body = jsonDecode(response.body);
        final errorMessage =
            body["detail"] ?? body["error"] ?? body.toString();
        throw(errorMessage);
      }
    } catch ( stackTrace) {
      print("Error in createValetEntry:$stackTrace");
      rethrow;
    }
  }


}




