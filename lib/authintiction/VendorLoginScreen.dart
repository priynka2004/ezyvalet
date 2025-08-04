import 'package:ezyvalet/authintiction/VendorSignUpScreen.dart';
import 'package:ezyvalet/screens/DashboardScreen.dart';
import 'package:ezyvalet/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both email and password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.loginHeader),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 16),

                  Center(child: Text(AppStrings.appTitle, style: AppTextStyles.titleStyle)),
                  const SizedBox(height: 16),

                  Center(child: Text(AppStrings.vendorLogin, style: AppTextStyles.headingStyle)),
                  const SizedBox(height: 32),

                  Text(AppStrings.emailLabel, style: AppTextStyles.labelStyle),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: AppStrings.emailHint,
                      hintStyle: AppTextStyles.hintStyle,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.highlight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(AppStrings.passwordLabel, style: AppTextStyles.labelStyle),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: AppStrings.passwordHint,
                      hintStyle: AppTextStyles.hintStyle,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.highlight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                        onPressed: () {},
                        child: Text(AppStrings.forgotPassword, style: AppTextStyles.linkStyle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(AppStrings.login, style: AppTextStyles.buttonStyle),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return VendorSignUpScreen();
                        }));
                      },
                      child: Text.rich(
                        TextSpan(
                          text: AppStrings.dontHaveAccount,
                          style: AppTextStyles.linkStyle,
                          children: [
                            TextSpan(
                              text: AppStrings.signUp,
                              style: AppTextStyles.linkStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
