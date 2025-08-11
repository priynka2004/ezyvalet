import 'package:ezyvalet/authintiction/ForgetPasswordScreen.dart';
import 'package:ezyvalet/authintiction/VendorSignUpScreen.dart';
import 'package:ezyvalet/authintiction/provider/forget_password_provider.dart';
import 'package:ezyvalet/authintiction/provider/login_provider.dart';
import 'package:ezyvalet/authintiction/service/login_service.dart';
import 'package:ezyvalet/screens/HomePage.dart';
import 'package:ezyvalet/screens/NewValetEntryScreen.dart';
import 'package:ezyvalet/unused_screen/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_images.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  bool rememberMe = false;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final loginProvider = context.read<LoginProvider>();

      final success = await loginProvider.login(email, password);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginProvider.errorMessage ?? "Login failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both email and password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.loginHeader),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  Center(
                      child: Text(AppStrings.appTitle,
                          style: AppTextStyles.titleStyle)),
                  const SizedBox(height: 8),
                  Center(
                      child: Text(AppStrings.vendorLogin,
                          style: AppTextStyles.headingStyle)),
                  const SizedBox(height: 32),

                  // Email Field
                  Text(AppStrings.emailLabel, style: AppTextStyles.labelStyle),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailHint,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  Text(AppStrings.passwordLabel,
                      style: AppTextStyles.labelStyle),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: AppStrings.passwordHint,
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            checkColor: AppColors.white,
                            activeColor: AppColors.highlight,
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text(AppStrings.rememberMe),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgetPasswordScreen();
                          }));
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: AppColors.highlight,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        return ElevatedButton(
                          onPressed: provider.loading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.button,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          child: provider.loading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppStrings.login,
                                  style: AppTextStyles.buttonStyle),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign Up Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.dontHaveAccount),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const VendorSignUpScreen()),
                          );
                        },
                        child: Text(AppStrings.signUp,
                            style: AppTextStyles.linkStyle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.hintStyle,
          prefixIcon: Icon(icon, color: AppColors.highlight),
          suffixIcon: onToggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
      ),
    );
  }
}
