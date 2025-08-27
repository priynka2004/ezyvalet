import 'package:ezyvalet/screens/service/ActiveValetService.dart';
import 'package:flutter/material.dart';

class ActiveValetProvider with ChangeNotifier {
  final ActiveValetService _service = ActiveValetService();

  bool isLoading = false;
  String? errorMessage;
  int activeCount = 0;
  List<Map<String, dynamic>> activeList = [];

  Future<void> loadActiveData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final count = await _service.fetchActiveCounts();
      final list = await _service.fetchActiveList();

      activeCount = count ?? 0;
      activeList = list;
    } catch (e) {
      errorMessage = "Failed to load active valet data";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> manualRelease(int valetId, String pin) async {
    try {
      final success = await _service.manualRelease(valetId, pin);

      if (success) {
        // ✅ Sirf success pe reload karo
        await loadActiveData();
      }
      // ❌ Fail case me purana data disturb mat karo
      return success;

    } catch (e) {
      errorMessage = "Manual release failed";
      return false;
    }
  }


}
