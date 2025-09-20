import 'package:ezyvalet/screens/service/staff_service.dart';
import 'package:flutter/material.dart';

class StaffProvider extends ChangeNotifier {
  final StaffService _service = StaffService();

  List<Map<String, dynamic>> staffList = [];
  bool isLoading = false;

  Future<void> fetchStaff() async {
    isLoading = true;
    notifyListeners();
    staffList = await _service.getStaffList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addStaff(String name, String mobile) async {
    isLoading = true;
    notifyListeners();
    final success = await _service.addStaff(name,mobile);
    if (success) {
      await fetchStaff();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateStaff(int id, String name, String mobile) async {
    isLoading = true;
    notifyListeners();
    final success = await _service.updateStaff(id, name, mobile);
    if (success) {
      await fetchStaff();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteStaff(int id) async {
    isLoading = true;
    notifyListeners();
    final success = await _service.deleteStaff(id);
    if (success) {
      staffList.removeWhere((s) => s["id"] == id);
      await fetchStaff();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleAvailability(int id, bool active) async {
    isLoading = true;
    notifyListeners();
    if (active) {
      await _service.markStaffActive(id);
    } else {
      await _service.markStaffInactive(id);
    }
    await fetchStaff();
    isLoading = false;
    notifyListeners();
  }
}
