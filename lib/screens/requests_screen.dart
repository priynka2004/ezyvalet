import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/provider/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RequestProvider>().loadRequests());
  }

  void _showVerifyDialog(BuildContext parentContext, int id) {
    final pinController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    bool localLoading = false;
    bool isPinVisible = false;

    showDialog(
      context: parentContext,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verify Release",
                  style: Theme.of(parentContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Please enter the 4-digit PIN provided by the customer.",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 20),

                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: pinController,
                    obscureText: !isPinVisible,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Enter 4-digit PIN",
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPinVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color:AppColors.dark,
                        ),
                        onPressed: () {
                          setState(() {
                            isPinVisible = !isPinVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the PIN';
                      }
                      if (value.length != 4) return 'PIN must be 4 digits';
                      if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                        return 'Numbers only';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(parentContext),
                      child: Text("Cancel",
                          style: TextStyle(color: AppColors.dark)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => localLoading = true);

                        final success = await parentContext
                            .read<RequestProvider>()
                            .verifyAndRelease(id, pinController.text);

                        setState(() => localLoading = false);

                        Navigator.pop(parentContext); // close dialog

                        Future.microtask(() {
                          if (!mounted) return;

                          if (success) {
                            CherryToast.success(
                              title: const Text("Vehicle released successfully!"),
                              toastPosition: Position.bottom,
                              displayIcon: true,
                            ).show(parentContext);

                            parentContext.read<RequestProvider>().loadRequests();
                          } else {
                            CherryToast.error(
                              title: const Text("Please enter the correct PIN."),
                              toastPosition: Position.bottom,
                              displayIcon: true,
                            ).show(parentContext);
                          }
                        });
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                      ),
                      child: localLoading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Verify & Release",
                        style: TextStyle(color: Colors.white),
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.directions_car, color: AppColors.white),
            const SizedBox(width: 8),
            Text(
              "Car Request",
              style: TextStyle(
                color: AppColors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.highlight,
        elevation: 2,
      ),
      body: Consumer<RequestProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(
              color: AppColors.highlight,
            ));
          }

          if (provider.requests.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car_filled_rounded,
                    size: 72,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No car retrieval requests at the moment.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.highlight,
            onRefresh: () async {
              await provider.loadRequests();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.requests.length,
              itemBuilder: (context, index) {
                final request = provider.requests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      radius: 26,
                      child: const Icon(
                        Icons.directions_car_filled_rounded,
                        color: AppColors.highlight,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      request['car_plate_number'] ?? 'Unknown Plate',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer: ${request['requester_mobile'] ?? 'N/A'}",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Requested on: ${request['requested_at'] ?? 'N/A'}",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                      onPressed: () => _showVerifyDialog(context, request['id'] as int),
                      child: const Text(
                        "Release",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: AppColors.white),
                      ),
                    ),
                  ),

                );
              },
            ),
          );
        },
      ),
    );
  }
}
