import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/authintiction/provider/signup_provider.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorSignUpScreen extends StatefulWidget {
  const VendorSignUpScreen({super.key});

  @override
  State<VendorSignUpScreen> createState() => _VendorSignUpScreenState();
}

class _VendorSignUpScreenState extends State<VendorSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToPolicy = false;

  // Password hide/show variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Widget _buildTextField(
      String hintText,
      IconData icon,
      TextEditingController controller, {
        bool obscureText = false,
        VoidCallback? toggleObscure,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $hintText";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF9C854A)),
        suffixIcon: toggleObscure != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: toggleObscure,
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF0F2F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignupProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("EzyValet", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Vendor Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildTextField("Full Name", Icons.person, _fullNameController),
              const SizedBox(height: 12),
              _buildTextField("Business Name", Icons.business_center, _businessNameController),
              const SizedBox(height: 12),
              _buildTextField("Phone Number", Icons.phone, _phoneController),
              const SizedBox(height: 12),
              _buildTextField("Address", Icons.location_on, _addressController),
              const SizedBox(height: 12),
              _buildTextField("City", Icons.location_city, _cityController),
              const SizedBox(height: 12),
              _buildTextField("State", Icons.map, _stateController),
              const SizedBox(height: 12),
              _buildTextField("Pin Code", Icons.tag, _pinCodeController),
              const SizedBox(height: 12),
              _buildTextField("Email", Icons.email, _emailController),
              const SizedBox(height: 12),
              _buildTextField(
                "Password",
                Icons.lock,
                _passwordController,
                obscureText: _obscurePassword,
                toggleObscure: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                "Confirm Password",
                Icons.lock,
                _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                toggleObscure: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Checkbox(
                    value: _agreedToPolicy,
                    activeColor: const Color(0xFF9C854A),
                    onChanged: (value) => setState(() => _agreedToPolicy = value ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Terms of Service and Privacy Policy",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              signupProvider.loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _agreedToPolicy) {
                      if (_passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Passwords do not match")));
                        return;
                      }

                      final body = {
                        "business_name": _businessNameController.text,
                        "address": _addressController.text,
                        "city": _cityController.text,
                        "state": _stateController.text,
                        "pin_code": _pinCodeController.text,
                        "mobile_number": _phoneController.text,
                        "email": _emailController.text,
                        "agree_to_terms": _agreedToPolicy,
                        "password": _passwordController.text,
                      };

                      bool success = await signupProvider.signup(body);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signup Successful")));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VendorLoginScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                signupProvider.errorMessage ?? "Signup Failed")));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE4B63A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const VendorLoginScreen())),
                child: Text("Already a vendor? Login", style: TextStyle(color: AppColors.highlight)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
