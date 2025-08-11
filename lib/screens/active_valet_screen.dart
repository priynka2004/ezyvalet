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
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(Icons.warning_amber_rounded,
                  size: 60, color: AppColors.highlight),
              const SizedBox(height: 12),
              Text(
                "Manual Release",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to release car\n${valet['car_plate_number']}?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color:AppColors.highlight ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",style: TextStyle(color: AppColors.highlight,),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<ActiveValetProvider>()
                            .manualRelease(valet['id'], valet['pin']);
                      },
                      child: Text("Release",style: TextStyle(color:AppColors.white),),
                    ),
                  ),
                ],
              ),
            ],
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
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.activeList.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Container(
              //   margin: const EdgeInsets.all(16),
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: AppColors.highlight.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Icon(Icons.directions_car, color: AppColors.highlight, size: 28),
              //       const SizedBox(width: 8),
              //       Text(
              //         "Active Cars: ${provider.activeCount}",
              //         style: const TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: AppColors.highlight,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Valet List
              Expanded(
                child: _buildValetList(provider.activeList),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.highlight,
        onPressed: () {
          context.read<ActiveValetProvider>().loadActiveData();
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Plate Number
          Text(
            valet['car_plate_number']?.toString() ?? 'N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 6),

          // Customer Mobile Number
          Row(
            children: [
              const Icon(Icons.phone_android, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                valet['customer_mobile_number']?.toString() ?? '',
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock_open_rounded,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'PIN: ${valet['pin'] ?? ''}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              valet['qr_code_url'] != null
                  ? Image.network(valet['qr_code_url'], height: 40, width: 40)
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 12),

          // Manual Release Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.lock_open,
                size: 18,
                color: AppColors.white,
              ),
              label: Text(
                "Manual Release",
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _showReleaseConfirmation(context, valet);
              },
            ),
          )
        ],
      ),
    );
  }
}
