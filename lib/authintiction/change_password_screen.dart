import 'package:cherry_toast/cherry_toast.dart';
import 'package:ezyvalet/authintiction/provider/change_password_provider.dart';
import 'package:ezyvalet/authintiction/provider/login_provider.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();

    // Listen to changes in text fields
    _oldPassController.addListener(_updateState);
    _newPassController.addListener(_updateState);
    _confirmPassController.addListener(_updateState);
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  bool get _isButtonEnabled {
    return _oldPassController.text.isNotEmpty &&
        _newPassController.text.isNotEmpty &&
        _confirmPassController.text.isNotEmpty &&
        _newPassController.text == _confirmPassController.text;
  }

  Future<void> _loadToken() async {
    final loginProvider = context.read<LoginProvider>();
    if (loginProvider.token != null && loginProvider.token!.isNotEmpty) {
      setState(() => token = loginProvider.token);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('access_token');
    if (savedToken != null && savedToken.isNotEmpty) {
      setState(() => token = savedToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.highlight,
        elevation: 1,
        iconTheme: IconThemeData(color: AppColors.white),
        centerTitle: false,
        title: const Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
      ),
      body: token == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              "Update your password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your new password must be different from previous passwords.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _buildPasswordField(_oldPassController, "Old Password", _obscureOld, () {
              setState(() => _obscureOld = !_obscureOld);
            }),
            const SizedBox(height: 16),
            _buildPasswordField(_newPassController, "New Password", _obscureNew, () {
              setState(() => _obscureNew = !_obscureNew);
            }),
            const SizedBox(height: 16),
            _buildPasswordField(_confirmPassController, "Confirm Password", _obscureConfirm, () {
              setState(() => _obscureConfirm = !_obscureConfirm);
            }),
            const SizedBox(height: 32),
            SizedBox(
              width: screenWidth,
              height: 50,
              child: ElevatedButton(
                onPressed: provider.isLoading || !_isButtonEnabled
                    ? null
                    : () async {
                  final success = await provider.changePassword(
                    token: token!,
                    oldPassword: _oldPassController.text.trim(),
                    newPassword: _newPassController.text.trim(),
                    confirmPassword: _confirmPassController.text.trim(),
                  );

                  if (success) {
                    CherryToast.success(
                      title: const Text(
                        "Password changed successfully",
                        style: TextStyle(color: Colors.black),
                      ),
                    ).show(context);

                    Navigator.pop(context);
                  } else {
                    CherryToast.error(
                      title: Text(
                        provider.errorMessage ?? "Error",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ).show(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? AppColors.highlight : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                  "Change Password",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool obscure, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.dark),
        hintStyle: TextStyle(color: AppColors.highlight),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
