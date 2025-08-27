import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ezyvalet/authintiction/ResetPasswordScreen.dart';
import 'package:ezyvalet/authintiction/provider/forget_password_provider.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text("Forgot Password", style: TextStyle(color:AppColors.white)),
        backgroundColor: AppColors.highlight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Forgot Your Password?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your registered email address below to receive password reset instructions.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email Address",
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    CherryToast.error(
                      title: const Text("Please enter your email"),
                      toastPosition: Position.bottom,
                    ).show(context);
                    return;
                  }

                  await context.read<ForgetPasswordProvider>().sendForgetPassword(email);

                  final provider = context.read<ForgetPasswordProvider>();
                  if (provider.errorMessage == null) {
                    CherryToast.success(
                      title: const Text("Reset link sent successfully"),
                      toastPosition: Position.bottom,
                    ).show(context);

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ResetPasswordScreen();
                    }));
                  } else {
                    CherryToast.error(
                      title: Text(provider.errorMessage!),
                      toastPosition: Position.bottom,
                    ).show(context);
                  }
                },
                child: const Text(
                  "Send Reset Link",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
