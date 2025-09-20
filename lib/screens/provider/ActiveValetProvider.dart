import 'package:ezyvalet/screens/service/ActiveValetService.dart';
import 'package:flutter/material.dart';

class ActiveValetProvider with ChangeNotifier {
  final ActiveValetService _service = ActiveValetService();

  bool _isLoading = false;
  String? _errorMessage;
  int _activeCount = 0;
  List<Map<String, dynamic>> _activeList = [];

  // Getters (UI ke liye safer way)
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get activeCount => _activeCount;
  List<Map<String, dynamic>> get activeList => List.unmodifiable(_activeList);

  Future<void> loadActiveData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final count = await _service.fetchActiveCounts();
      final list = await _service.fetchActiveList();

      _activeCount = count ?? 0;
      _activeList = list;
    } catch (e) {
      _errorMessage = "Failed to load active valet data";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> manualRelease(int valetId, String pin) async {
    try {
      final success = await _service.manualRelease(valetId, pin);

      if (success) {
        await loadActiveData(); // ✅ Only reload on success
      }

      return success; // true/false return for UI
    } catch (e) {
      _errorMessage = "Manual release failed";
      notifyListeners();
      return false;
    }
  }
}
