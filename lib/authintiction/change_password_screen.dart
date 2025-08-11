import 'package:ezyvalet/authintiction/provider/change_password_provider.dart';
import 'package:ezyvalet/authintiction/provider/login_provider.dart';
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
  }

  Future<void> _loadToken() async {
    // 1️⃣ Provider se try karo
    final loginProvider = context.read<LoginProvider>();
    if (loginProvider.token != null && loginProvider.token!.isNotEmpty) {
      setState(() => token = loginProvider.token);
      return;
    }

    // 2️⃣ SharedPreferences se try karo
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('access_token');
    if (savedToken != null && savedToken.isNotEmpty) {
      setState(() => token = savedToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: token == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPasswordField(_oldPassController, "Old Password", _obscureOld, () {
              setState(() => _obscureOld = !_obscureOld);
            }),
            const SizedBox(height: 12),
            _buildPasswordField(_newPassController, "New Password", _obscureNew, () {
              setState(() => _obscureNew = !_obscureNew);
            }),
            const SizedBox(height: 12),
            _buildPasswordField(_confirmPassController, "Confirm Password", _obscureConfirm, () {
              setState(() => _obscureConfirm = !_obscureConfirm);
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                final success = await provider.changePassword(
                  token: token!,
                  oldPassword: _oldPassController.text.trim(),
                  newPassword: _newPassController.text.trim(),
                  confirmPassword: _confirmPassController.text.trim(),
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password changed successfully")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage ?? "Error")),
                  );
                }
              },
              child: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Change Password"),
            ),
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
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
