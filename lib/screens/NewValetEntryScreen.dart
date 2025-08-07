import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:ezyvalet/screens/my_drawer.dart';
import 'package:flutter/material.dart';

class NewValetEntryScreen extends StatelessWidget {
  const NewValetEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MyDrawer(),
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.directions_car, color: AppColors.highlight),
            const SizedBox(width: 8),
            Text(
              'EzyValet',
              style: TextStyle(
                color: AppColors.highlight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu, color: AppColors.highlight),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.buttonLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Valet Entry',
                  style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Enter customer's car and mobile number.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Car Plate Number
                const Text('Car Plate Number',
                    style: TextStyle(color: AppColors.dark)),
                const SizedBox(height: 8),
                _customTextField(
                  hint: 'e.g., CA123XYZ',
                  icon: Icons.directions_car,
                ),

                const SizedBox(height: 20),

                // Customer Mobile Number
                const Text('Customer Mobile Number',
                    style: TextStyle(color: AppColors.dark)),
                const SizedBox(height: 8),
                _customTextField(
                  hint: 'e.g., 9876543210',
                  icon: Icons.phone_android_rounded,
                ),

                const SizedBox(height: 32),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.qr_code, color: AppColors.white),
                    label: const Text(
                      'Generate QR Code & Park',
                      style: AppTextStyles.buttonWhiteText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: AppColors.dark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _customTextField({
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey),
      ),
      child: TextField(
        style: const TextStyle(color:AppColors.grey),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color:AppColors.grey),
          prefixIcon: Icon(icon, color:AppColors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
