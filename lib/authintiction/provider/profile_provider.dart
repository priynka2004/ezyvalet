import 'package:ezyvalet/authintiction/model/VendorProfile.dart';
import 'package:ezyvalet/authintiction/service/VendorProfileService.dart';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic>? profile;
  List<dynamic>? profileList;
  bool loading = false;
  VendorProfile? profiles;
  String? error;

  final TokenService _tokenService = TokenService();
  late final ProfileService _service = ProfileService(tokenService: _tokenService);

  /// ✅ GET all Profiles
  Future<void> fetchProfiles() async {
    _setLoading(true);
    try {
      profileList = await _service.getProfiles();

      // agar API list return kare to first element le lo
      if (profileList != null && profileList!.isNotEmpty) {
        profile = Map<String, dynamic>.from(profileList!.first);
        profiles = VendorProfile.fromJson(profile!);
      } else {
        profile = null;
        profiles = null;
      }
    } catch (e) {
      error = "Failed to fetch profile: $e";
    }
    _setLoading(false);
  }

  /// ✅ GET Single Profile by ID
  Future<void> fetchProfileById(int id) async {
    _setLoading(true);
    try {
      final data = await _service.getProfileById(id);
      profile = data;
      profiles = VendorProfile.fromJson(data);
    } catch (e) {
      error = "Failed to fetch profile by ID: $e";
    }
    _setLoading(false);
  }

  /// ✅ PUT Profile (Full Update)
  Future<bool> updateProfile(int id, Map<String, dynamic> body) async {
    _setLoading(true);
    try {
      final response = await _service.updateProfile(id, body); // id pass
      profiles = VendorProfile.fromJson(response);
      return true;
    } catch (e) {
      error = "Failed to update profile: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ✅ PATCH Profile (Partial Update)
  Future<bool> patchProfile(int id, Map<String, dynamic> body) async {
    _setLoading(true);
    try {
      final response = await _service.patchProfile(id, body);
      profiles = VendorProfile.fromJson(response);
      profile = response;
      return true;
    } catch (e) {
      error = "Failed to patch profile: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ✅ DELETE Profile
  Future<bool> deleteProfile(int id) async {
    _setLoading(true);
    try {
      bool success = await _service.deleteProfile(id);
      if (success) {
        profile = null;   // single profile clear
        profileList = null; // agar list hai to clear
      }
      return success;
    } catch (e) {
      error = "Failed to delete profile: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }


  /// Helper function
  void _setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool get isLoading => loading;
}
