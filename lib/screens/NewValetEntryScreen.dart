import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:ezyvalet/screens/my_drawer.dart';
import 'package:ezyvalet/screens/provider/ValetEntryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewValetEntryScreen extends StatefulWidget {
  final String token; // Token from login
  const NewValetEntryScreen({super.key, required this.token});

  @override
  State<NewValetEntryScreen> createState() => _NewValetEntryScreenState();
}

class _NewValetEntryScreenState extends State<NewValetEntryScreen> {
  final _carPlateController = TextEditingController();
  final _customerMobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ValetEntryProvider>();

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
                  controller: _carPlateController,
                  hint: 'Plate Number',
                  icon: Icons.directions_car,
                ),

                const SizedBox(height: 20),

                const Text('Customer Mobile Number',
                    style: TextStyle(color: AppColors.dark)),
                const SizedBox(height: 8),
                _customTextField(
                  controller: _customerMobileController,
                  hint: 'Mobile No.',
                  icon: Icons.phone_android_rounded,
                  isPhone: true,
                ),

                const SizedBox(height: 32),


                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                      final success = await provider.createEntry(
                      //  token: widget.token,
                        carPlateNumber:
                        _carPlateController.text.trim(),
                        customerMobileNumber:
                        _customerMobileController.text.trim(),
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("Valet entry created successfully")),
                        );
                        _carPlateController.clear();
                        _customerMobileController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  provider.errorMessage ?? "Error")),
                        );
                      }
                    },
                    icon: Icon(Icons.qr_code, color: AppColors.white),
                    label: provider.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
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
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPhone = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.grey),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        inputFormatters: isPhone
            ? [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ]
            : [],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: Icon(icon, color: AppColors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

}
