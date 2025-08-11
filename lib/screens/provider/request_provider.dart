import 'package:ezyvalet/screens/service/request_service.dart';
import 'package:flutter/material.dart';

class RequestProvider with ChangeNotifier {
  final RequestService _service = RequestService();

  bool isLoading = false;
  String? errorMessage;
  List<Map<String, dynamic>> requests = [];

  Future<void> loadRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      requests = await _service.fetchRequestList();
    } catch (e) {
      errorMessage = "Failed to load requests";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyAndRelease(int id, String pin) async {
    return await _service.verifyAndRelease(id, pin);
  }
}
