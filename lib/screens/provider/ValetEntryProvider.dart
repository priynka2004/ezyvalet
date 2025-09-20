import 'package:ezyvalet/screens/model/ValetEntryResponse.dart';
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
    required int staffId,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final entry = await _service.createValetEntry(
        carPlateNumber: carPlateNumber,
        customerMobileNumber: customerMobileNumber,
        staffId: staffId,
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
