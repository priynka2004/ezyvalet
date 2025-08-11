import 'package:flutter/material.dart';
import '../service/valet_entry_service.dart';

class ValetEntryProvider with ChangeNotifier {
  final ValetEntryService _service = ValetEntryService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> createEntry({
    required String carPlateNumber,
    required String customerMobileNumber,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await _service.createValetEntry(
      carPlateNumber: carPlateNumber,
      customerMobileNumber: customerMobileNumber,
    );

    isLoading = false;
    if (!success) {
      errorMessage = "Failed to create valet entry";
    }
    notifyListeners();

    return success;
  }
}
