import 'package:cherry_toast/cherry_toast.dart';
import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/authintiction/provider/ResetPasswordProvider.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final uidController = TextEditingController();
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Reset Password", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.highlight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter New Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            _buildTextField(uidController, "UID", Icons.person),
            const SizedBox(height: 15),
            _buildTextField(tokenController, "Token", Icons.vpn_key),
            const SizedBox(height: 15),

            _buildTextField(
              newPasswordController,
              "New Password",
              Icons.lock,
              isPassword: true,
              obscureText: _obscureNewPassword,
              toggleObscureText: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            const SizedBox(height: 15),

            _buildTextField(
              confirmPasswordController,
              "Confirm Password",
              Icons.lock_outline,
              isPassword: true,
              obscureText: _obscureConfirmPassword,
              toggleObscureText: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (newPasswordController.text.trim() !=
                      confirmPasswordController.text.trim()) {
                    CherryToast.error(
                      title: const Text("Passwords do not match"),
                      animationDuration: const Duration(milliseconds: 500),
                      autoDismiss: true,
                    ).show(context);
                    return;
                  }

                  await context.read<ResetPasswordProvider>().resetPassword(
                    uid: uidController.text.trim(),
                    token: tokenController.text.trim(),
                    newPassword: newPasswordController.text.trim(),
                    confirmPassword: confirmPasswordController.text.trim(),
                  );

                  final provider = context.read<ResetPasswordProvider>();
                  if (provider.errorMessage == null) {
                    CherryToast.success(
                      title: const Text("Password reset successful"),
                      animationDuration: const Duration(milliseconds: 500),
                      autoDismiss: true,
                    ).show(context);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return VendorLoginScreen();
                        }));
                  } else {
                    CherryToast.error(
                      title: Text(provider.errorMessage!),
                      animationDuration: const Duration(milliseconds: 500),
                      autoDismiss: true,
                    ).show(context);
                  }
                },
                child: const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      IconData icon, {
        bool isPassword = false,
        bool obscureText = false,
        VoidCallback? toggleObscureText,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggleObscureText,
        )
            : null,
      ),
    );
  }

}
