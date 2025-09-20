import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/provider/billing_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

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

  Future<void> _exportToPDF() async {
    try {
      final provider = Provider.of<BillingProvider>(context, listen: false);

      final pdf = pw.Document();

      // Load a font that supports the Rupee symbol (optional but recommended)
      // final font = await PdfGoogleFonts.notoSansRegular();
      // final fontBold = await PdfGoogleFonts.notoSansBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Billing Analytics Report',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    // font: fontBold, // Uncomment if using custom font
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Period: ${DateFormat.yMMMd().format(selectedDateRange.start)} - ${DateFormat.yMMMd().format(selectedDateRange.end)}',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey700,
                  // font: font, // Uncomment if using custom font
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Summary',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        // font: fontBold, // Uncomment if using custom font
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Total Records: ${provider.billingData.length}',
                      // style: pw.TextStyle(font: font), // Uncomment if using custom font
                    ),
                    pw.Text(
                      'Total Amount: Rs. ${_calculateTotalAmount(provider.billingData)}',
                      // style: pw.TextStyle(font: font), // Uncomment if using custom font
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: [
                  [
                    'Vendor',
                    'Method',
                    'Vehicles',
                    'Subtotal',
                    'GST',
                    'Total',
                    'Status'
                  ],
                  ...provider.billingData.map((bill) => [
                    bill['vendor_name']?.toString() ?? 'Unknown',
                    bill['billing_method']?.toString() ?? '-',
                    bill['total_vehicle_released']?.toString() ?? '0',
                    'Rs. ${bill['billing_subtotal']?.toString() ?? '0'}',
                    'Rs. ${bill['gst_collected']?.toString() ?? '0'}',
                    'Rs. ${bill['total_bill_with_gst']?.toString() ?? '0'}',
                    bill['payment_status']?.toString() ?? 'Unknown',
                  ]),
                ],
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  // font: fontBold, // Uncomment if using custom font
                ),
                cellStyle: pw.TextStyle(
                  // font: font, // Uncomment if using custom font
                ),
                cellHeight: 28,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              ),

              // Add a footer with generation timestamp
              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Report generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  // font: font, // Uncomment if using custom font
                ),
              ),
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/billing_analytics_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: 'Billing Analytics Report');

      CherryToast.success(
        title: const Text("PDF exported successfully!"),
        animationType: AnimationType.fromTop,
      ).show(context);
    } catch (e) {
      CherryToast.error(
        title: Text("Error exporting PDF: $e"),
        animationType: AnimationType.fromTop,
      ).show(context);
    }
  }


  String _calculateTotalAmount(List<Map<String, dynamic>> data) {
    double total = 0;
    for (var bill in data) {
      var amount = bill['total_bill_with_gst'];
      if (amount != null) {
        if (amount is String) {
          total += double.tryParse(amount) ?? 0;
        } else if (amount is num) {
          total += amount.toDouble();
        }
      }
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BillingProvider>(context);

    final formattedRange =
        '${DateFormat.yMMMd().format(selectedDateRange.start)} - ${DateFormat.yMMMd().format(selectedDateRange.end)}';

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text("Analytics"),
        backgroundColor: AppColors.highlight,
        foregroundColor: AppColors.white,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: _exportToPDF,
            icon: const Icon(Icons.download),
          )
        ],
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
        child: CherryToast.error(
          title: Text(provider.error!),
          displayCloseButton: false,
          toastPosition: Position.bottom,
          animationDuration: const Duration(milliseconds: 500),
          autoDismiss: true,
        ),
      )
          : provider.billingData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              "No billing data found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formattedRange,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.highlight.withOpacity(0.15),
                    AppColors.highlight.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color:
                    AppColors.highlight.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem("Total Records",
                      provider.billingData.length.toString()),
                  _summaryItem("Total Amount",
                      "₹${_calculateTotalAmount(provider.billingData)}"),
                ],
              ),
            ),

            const SizedBox(height: 28),

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

  Widget _summaryItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.highlight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _billingCard(Map<String, dynamic> bill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bill['vendor_name'] ?? "Unknown Vendor",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _statusChip(bill['payment_status']),
            ],
          ),
          const Divider(height: 20),

          _infoRow("Billing Method", bill['billing_method']),
          _infoRow("Vehicles Released",
              bill['total_vehicle_released'].toString()),
          _infoRow("Subscription Fees",
              "₹${bill['monthly_subscription_fees'].toString()}"),
          _infoRow("Subtotal", "₹${bill['billing_subtotal'].toString()}"),
          _infoRow("GST", "₹${bill['gst_collected'].toString()}"),
          _infoRow("Previous Dues", "₹${bill['previous_dues'].toString()}"),
          const Divider(height: 20),
          _infoRow("Total", "₹${bill['total_bill_with_gst'].toString()}",
              bold: true),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bgColor =
    status == 'Pending' ? Colors.orange.shade100 : Colors.green.shade100;
    Color textColor = status == 'Pending' ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
