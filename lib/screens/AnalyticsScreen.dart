import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/provider/billing_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<BillingProvider>(context, listen: false).getBillingData());
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BillingProvider>(context);

    final formattedRange =
        '${DateFormat.yMMMd().format(selectedDateRange.start)} - ${DateFormat.yMMMd().format(selectedDateRange.end)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        backgroundColor: AppColors.highlight,
        foregroundColor: AppColors.white,
        elevation: 2,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text("Error: ${provider.error}"))
          : provider.billingData.isEmpty
          ? const Center(child: Text("No billing data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Date picker + Export button
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDateRange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              formattedRange,
                              style:
                              const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.download,
                    color: AppColors.white,
                  ),
                  label: const Text("Export"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 28),

            /// Summary cards (dynamic from billing data)
            Row(
              children: [
                _summaryCard(
                    "Vendors",
                    provider.billingData.length.toString(),
                    Icons.store,
                    Colors.blue),
                _summaryCard(
                    "Pending",
                    provider.billingData
                        .where((b) =>
                    b['payment_status'] == "Pending")
                        .length
                        .toString(),
                    Icons.access_time,
                    Colors.orange),
                _summaryCard(
                    "Paid",
                    provider.billingData
                        .where((b) =>
                    b['payment_status'] == "Paid")
                        .length
                        .toString(),
                    Icons.check_circle,
                    Colors.green),
              ],
            ),

            const SizedBox(height: 32),

            /// Billing Section
            Text(
              "Billing Records",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...provider.billingData.map(_billingCard).toList(),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingCard(Map<String, dynamic> bill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vendor: ${bill['vendor_name']}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Billing Method: ${bill['billing_method']}"),
          Text("Vehicles Released: ${bill['total_vehicle_released']}"),
          Text("Monthly Fees: ₹${bill['monthly_subscription_fees']}"),
          Text("Subtotal: ₹${bill['billing_subtotal']}"),
          Text("GST Collected: ₹${bill['gst_collected']}"),
          Text("Previous Dues: ₹${bill['previous_dues']}"),
          Text("Total with GST: ₹${bill['total_bill_with_gst']}"),
          const SizedBox(height: 6),
          _statusChip(bill['payment_status']),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bgColor =
    status == 'Pending' ? Colors.orange.shade100 : Colors.green.shade100;
    Color textColor = status == 'Pending' ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
