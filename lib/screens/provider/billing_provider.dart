import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:ezyvalet/screens/service/billing_service.dart';
import 'package:flutter/material.dart';

class BillingProvider with ChangeNotifier {
  final BillingService _service = BillingService();

  List<Map<String, dynamic>> billingData = [];
  bool loading = false;
  String? error;

  Future<void> getBillingData() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final token = await TokenService().getAccessToken();
      if (token == null) {
        error = "Session expired. Please login again.";
        billingData = [];
      } else {
        billingData = await _service.fetchBillingData(token);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
