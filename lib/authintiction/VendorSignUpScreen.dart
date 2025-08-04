import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';

class VendorSignUpScreen extends StatefulWidget {
  const VendorSignUpScreen({super.key});

  @override
  State<VendorSignUpScreen> createState() => _VendorSignUpScreenState();
}

class _VendorSignUpScreenState extends State<VendorSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToPolicy = false;

  Widget _buildTextField(String hintText, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Color(0xFF9C854A)),
        filled: true,
        fillColor: Color(0xFFF0F2F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("EzyValet", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Vendor Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Full Name", Icons.person),
              SizedBox(height: 12),
              _buildTextField("Business Name", Icons.business_center),
              SizedBox(height: 12),
              _buildTextField("Phone Number", Icons.phone),
              SizedBox(height: 12),
              _buildTextField("Address", Icons.location_on),
              SizedBox(height: 12),
              _buildTextField("City", Icons.location_city),
              SizedBox(height: 12),
              _buildTextField("State", Icons.map),
              SizedBox(height: 12),
              _buildTextField("Pin Code", Icons.tag),
              SizedBox(height: 12),
              _buildTextField("Email", Icons.email),
              SizedBox(height: 12),
              _buildTextField("Password", Icons.lock, obscureText: true),
              SizedBox(height: 12),
              _buildTextField("Confirm Password", Icons.lock, obscureText: true),
              SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _agreedToPolicy,
                    activeColor: Color(0xFF9C854A),
                    onChanged: (value) {
                      setState(() {
                        _agreedToPolicy = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "I agree to the Terms of Service and Privacy Policy",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _agreedToPolicy) {
                      // Handle sign up logic
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE4B63A),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                     return VendorLoginScreen();
                    }));
                  },
                  child: Text(
                    "Already a vendor? Login",
                    style: TextStyle(color: AppColors.highlight,),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
