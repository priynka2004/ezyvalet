import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:http/http.dart' as http;


// class ValetEntryResponse
// {
//   final String? pin;
//   final String? qrCodeUrl;
//   final int id;
//   final String carPlateNumber;
//   final String customerMobileNumber;
//   final bool carActive;
//
//   ValetEntryResponse({
//     this.pin,
//     this.qrCodeUrl,
//     required this.id,
//     required this.carPlateNumber,
//     required this.customerMobileNumber,
//     required this.carActive,
//   });
//
//   factory ValetEntryResponse.fromJson(Map<String, dynamic> json) {
//     return ValetEntryResponse(
//       pin: json['pin'] as String?,
//       qrCodeUrl: json['qr_code_url'] as String?,
//       id: json['id'] as int,
//       carPlateNumber: json['car_plate_number'] as String,
//       customerMobileNumber: json['customer_mobile_number'] as String,
//       carActive: json['car_active'] as bool,
//     );
//   }
// }


class ValetEntryResponse {
  final String? pin;
  final String? qrCodeUrl;
  final String? scanResultUrl; // 👈 add this
  final int id;
  final String carPlateNumber;
  final String customerMobileNumber;
  final bool carActive;

  ValetEntryResponse({
    this.pin,
    this.qrCodeUrl,
    this.scanResultUrl,
    required this.id,
    required this.carPlateNumber,
    required this.customerMobileNumber,
    required this.carActive,
  });

  factory ValetEntryResponse.fromJson(Map<String, dynamic> json) {
    return ValetEntryResponse(
      pin: json['pin'] as String?,
      qrCodeUrl: json['qr_code_image_url'] as String?, // backend field
      scanResultUrl: json['scan_result_url'] as String?, // backend field
      id: json['id'] as int,
      carPlateNumber: json['car_plate_number'] as String,
      customerMobileNumber: json['customer_mobile_number'] as String,
      carActive: json['car_active'] as bool,
    );
  }
}


class ValetEntryService {
  final TokenService _tokenService = TokenService();

  Future<ValetEntryResponse?> createValetEntry({
    required String carPlateNumber,
    required String customerMobileNumber,
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
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ValetEntryResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final body = jsonDecode(response.body);
          throw Exception(body["detail"] ?? body["error"] ?? "Unknown error");
        } catch (_) {
          throw Exception("Failed with status ${response.statusCode}: ${response.body}");
        }
      }
    } catch (e, stackTrace) {
      print("Error in createValetEntry: $e\n$stackTrace");
      rethrow; // keep the original error trace
    }
  }
}


// class ValetEntryService {
//   final TokenService _tokenService = TokenService();
//
//
//   // Future<ValetEntryResponse?> createValetEntry({
//   //   required String carPlateNumber,
//   //   required String customerMobileNumber,
//   // }) async {
//   //   try {
//   //     final token = await _tokenService.getAccessToken();
//   //     if (token == null || token.isEmpty) {
//   //       throw Exception("No access token found. Please login again.");
//   //     }
//   //
//   //     final response = await http.post(
//   //       Uri.parse("http://ezyvalet.bonanso.com/valet/create/"),
//   //       headers: {
//   //         "Accept": "application/json",
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //       body: jsonEncode({
//   //         "car_plate_number": carPlateNumber,
//   //         "customer_mobile_number": customerMobileNumber,
//   //       }),
//   //     );
//   //
//   //     print("Status Code: ${response.statusCode}");
//   //     print("Response: ${response.body}");
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       return ValetEntryResponse.fromJson(jsonDecode(response.body));
//   //     } else {
//   //       final body = jsonDecode(response.body);
//   //       throw Exception(body["detail"] ?? body["error"] ?? "Unknown error");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Server error: $e");
//   //   }
//   // }
//
//
//
// }

