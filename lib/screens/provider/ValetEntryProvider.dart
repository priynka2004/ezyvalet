// import 'package:flutter/material.dart';
// import '../service/valet_entry_service.dart';
//
// class ValetEntryProvider with ChangeNotifier {
//   final ValetEntryService _service = ValetEntryService();
//
//   bool isLoading = false;
//   String? errorMessage;
//
//   String? lastCreatedPin;
//   String? lastCreatedQrCodeUrl;
//   ValetEntryResponse? lastCreatedEntry;
//
//  ///helper
//
//   Future<bool> createEntry({
//     required String carPlateNumber,
//     required String customerMobileNumber,
//   }) async {
//     isLoading = true;
//     errorMessage = null;
//     lastCreatedPin = null;
//     lastCreatedQrCodeUrl = null;
//     lastCreatedEntry = null;
//     notifyListeners();
//
//     final response = await _service.createValetEntry(
//       carPlateNumber: carPlateNumber,
//       customerMobileNumber: customerMobileNumber,
//     ).catchError((error) {
//       errorMessage = error.toString();
//     });
//
//
//     isLoading = false;
//     if (response == null) {
//       errorMessage = "Admin approval required for a vehicle entry";
//       notifyListeners();
//       return false;
//     } else {
//       lastCreatedPin = response.pin;
//       lastCreatedQrCodeUrl = response.qrCodeUrl;
//       lastCreatedEntry = response;
//
//       if (lastCreatedPin == null) {
//         errorMessage = "PIN not available from server. Manual release will fail.";
//       }
//
//       notifyListeners();
//       return true;
//     }
//   }
//
//
//
//   String? get qrCodeUrl => lastCreatedQrCodeUrl;
//   String? get pin => lastCreatedPin;
//
//   // Clear data when needed
//   void clearLastEntry() {
//     lastCreatedPin = null;
//     lastCreatedQrCodeUrl = null;
//     lastCreatedEntry = null;
//     errorMessage = null;
//     notifyListeners();
//   }
// }



import 'package:ezyvalet/screens/service/valet_entry_service.dart';
import 'package:flutter/material.dart';

class ValetEntryProvider extends ChangeNotifier {
  final ValetEntryService _service = ValetEntryService();

  bool isLoading = false;
  String? errorMessage;
  ValetEntryResponse? lastCreatedEntry;

  Future<bool> createEntry({
    required String carPlateNumber,
    required String customerMobileNumber,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final entry = await _service.createValetEntry(
        carPlateNumber: carPlateNumber,
        customerMobileNumber: customerMobileNumber,
      );
      lastCreatedEntry = entry;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
