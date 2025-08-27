import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/provider/ActiveValetProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveValetScreen extends StatefulWidget {
  const ActiveValetScreen({super.key});

  @override
  State<ActiveValetScreen> createState() => _ActiveValetScreenState();
}

class _ActiveValetScreenState extends State<ActiveValetScreen> {

  void _showReleaseConfirmation(
      BuildContext context, Map<String, dynamic> valet) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController pinController = TextEditingController();
    bool localLoading = false;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verify Handover",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Ask the customer for their 4-digit PIN to confirm vehicle release.",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    const Text(
                      "Releasing Car :",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const Spacer(),
                    Text(
                      valet['car_plate_number'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  "Customer's 4-Digit PIN",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: pinController,
                  obscureText: true,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    hintText: "Enter 4-digit PIN",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the PIN';
                    }
                    if (value.length != 4) {
                      return 'PIN must be exactly 4 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(color: AppColors.dark)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => localLoading = true);

                        final success = await context
                            .read<ActiveValetProvider>()
                            .manualRelease(valet['id'], pinController.text);

                        setState(() => localLoading = false);

                        if (success) {
                          Navigator.pop(context);
                          CherryToast.success(
                            title: const Text("Vehicle released successfully!"),
                            toastPosition: Position.bottom,
                          ).show(context);
                        } else {
                          CherryToast.error(
                            title: const Text("Please enter the correct PIN."),
                            toastPosition: Position.bottom,
                          ).show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                      ),
                      child: localLoading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : Text(
                        "Verify & Release",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
        title: Text(
          "Active Valets",
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.highlight,
        elevation: 2,
      ),
      body: Consumer<ActiveValetProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.activeList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.highlight),
            );
          }

          if (provider.errorMessage != null && provider.activeList.isEmpty) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.activeList.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ActiveValetProvider>().loadActiveData(),
            color: AppColors.highlight,
            child: _buildValetList(provider.activeList),
          );
        },
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.highlight,
      //   onPressed: () {
      //     context.read<ActiveValetProvider>().loadActiveData();
      //   },
      //   child: const Icon(Icons.refresh, color: Colors.white),
      // ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled, color: Colors.grey[400], size: 80),
          const SizedBox(height: 12),
          const Text(
            "No active valets at the moment.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildValetList(List<Map<String, dynamic>> valets) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: valets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final valet = valets[index];
        return _buildValetCard(valet);
      },
    );
  }

  Widget _buildValetCard(Map<String, dynamic> valet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                valet['car_plate_number'] ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                valet['created_at_time'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Phone number row
          Row(
            children: [
              const Icon(Icons.phone_android, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                valet['customer_mobile_number'] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),

          GestureDetector(
            onTap: () => _showReleaseConfirmation(context, valet),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_open, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    "Manual Release",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
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
