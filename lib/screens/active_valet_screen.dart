import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ActiveValetScreen extends StatelessWidget {
  final List<Map<String, String>> activeValets;

  const ActiveValetScreen({super.key, this.activeValets = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: activeValets.isEmpty ? _buildEmptyState() : _buildValetList(),
      ),
    );
  }

  // Empty State when no active valets
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.highlight.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.directions_car_filled, color: Colors.grey, size: 48),
            SizedBox(height: 12),
            Text(
              "No active valets at the moment.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValetList() {
    return ListView.separated(
      itemCount: activeValets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final valet = activeValets[index];
        return _buildValetCard(valet);
      },
    );
  }

  Widget _buildValetCard(Map<String, String> valet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valet['vehicleNumber'] ?? 'N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.phone_android, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                valet['phone'] ?? '',
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.lock_open_rounded, size: 18, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    'Manual Release',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Text(
                valet['time'] ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
