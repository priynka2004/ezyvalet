import 'package:cherry_toast/cherry_toast.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/authintiction/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _businessNameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pinCodeController;
  late TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;

    _businessNameController = TextEditingController(text: profile?['vendor_name'] ?? "");
    _addressController = TextEditingController(text: profile?['vendor_address'] ?? "");
    _cityController = TextEditingController(text: profile?['city'] ?? "");
    _stateController = TextEditingController(text: profile?['state'] ?? "");
    _pinCodeController = TextEditingController(text: profile?['pin_code'] ?? "");
    _mobileController = TextEditingController(text: profile?['mobile_number'] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.highlight,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Make changes to your profile here. Click save when you’re done. Your email cannot be changed.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              _buildInputField('Business Name', _businessNameController),
              _buildInputField('Address', _addressController),
              _buildInputField('City', _cityController),
              _buildInputField('State', _stateController),
              _buildInputField('Pin Code', _pinCodeController, keyboardType: TextInputType.number),
              _buildInputField('Mobile Number', _mobileController, keyboardType: TextInputType.phone),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: provider.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Save Changes', style: TextStyle(fontSize: 18, color: AppColors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();

      final body = {
        "vendor_name": _businessNameController.text.trim(),
        "vendor_address": _addressController.text.trim(),
        "city": _cityController.text.trim(),
        "state": _stateController.text.trim(),
        "pin_code": _pinCodeController.text.trim(),
        "mobile_number": _mobileController.text.trim(),
      };

      // ✅ Profile id yaha se lo
      final id = provider.profile?['id'];

      if (id == null) {
        CherryToast.error(
          title: const Text("Profile ID not found"),
        ).show(context);
        return;
      }

      bool success = await provider.updateProfile(id, body);

      if (success) {
        CherryToast.success(
          title: const Text("Profile updated successfully"),
        ).show(context);
      } else {
        CherryToast.error(
          title: Text(provider.error ?? "Update failed"),
        ).show(context);
      }
    } else {
      CherryToast.error(
        title: const Text("Please correct the errors"),
      ).show(context);
    }
  }

}
