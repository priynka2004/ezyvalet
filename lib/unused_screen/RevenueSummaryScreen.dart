import 'package:flutter/material.dart';
import 'dart:math';

class RevenueSummaryScreen extends StatefulWidget {
  const RevenueSummaryScreen({super.key});

  @override
  State<RevenueSummaryScreen> createState() => _RevenueSummaryScreenState();
}

class _RevenueSummaryScreenState extends State<RevenueSummaryScreen> {
  String selectedTab = "Weekly";
  String filterText = "";

  // sample datasets for each tab (7 values = last 7 days/weeks/months)
  final Map<String, List<double>> _data = {
    'Daily': [80, 72, 60, 90, 85, 75, 95],
    'Weekly': [450, 520, 480, 500, 560, 530, 590],
    'Monthly': [1800, 1700, 1900, 2100, 2000, 2200, 2050],
  };

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF7B563C);
    final bg = Colors.white;
    final values = _data[selectedTab]!;
    final total = values.fold<double>(0, (a, b) => a + b);
    // simple percent change from previous (compare last value with average of previous)
    final prevAvg = values.length > 1 ? values.sublist(0, values.length - 1).fold<double>(0, (a, b) => a + b) / (values.length - 1) : values.last;
    final changePercent = ((values.last - prevAvg) / (prevAvg == 0 ? 1 : prevAvg)) * 100;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Revenue Summary",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header + segmented control
              Align(
                alignment: Alignment.centerLeft,
                child: Text('EzyValet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
              ),
              const SizedBox(height: 12),
              _segmentedControl(),

              const SizedBox(height: 18),

              // Revenue card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Revenue', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_formatCurrency(total), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: changePercent >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(changePercent >= 0 ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: changePercent >= 0 ? Colors.green : Colors.red),
                              const SizedBox(width: 4),
                              Text('${changePercent.abs().toStringAsFixed(1)}%', style: TextStyle(color: changePercent >= 0 ? Colors.green.shade700 : Colors.red.shade700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Animated bars row
                    SizedBox(
                      height: 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(values.length, (i) {
                          final v = values[i];
                          // normalize height to 0..1
                          final maxVal = values.reduce(max);
                          final ratio = maxVal == 0 ? 0.0 : (v / maxVal);
                          return Expanded(
                            child: _AnimatedBar(
                              label: _smallLabelForIndex(i),
                              ratio: ratio,
                              accent: accent,
                              isLast: i == values.length - 1,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // small legend / timeframe text
                    Text('Last ${values.length} ${selectedTab == "Daily" ? "days" : selectedTab == "Weekly" ? "weeks" : "months"} • Total: ${_formatCurrency(total)}',
                        style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Filter + search
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (s) => setState(() => filterText = s),
                      decoration: InputDecoration(
                        hintText: 'Search filter...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _filterChip('All'),
                ],
              ),

              const SizedBox(height: 12),

              // Example list (can be replaced with actual breakdown)
              // NOTE: ListView is shrink-wrapped and non-scrollable to avoid conflicts
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  return _revenueRow(idx, accent);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmentedControl() {
    final tabs = ['Daily', 'Weekly', 'Monthly'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: tabs.map((t) {
          final selected = t == selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : Colors.black54, fontWeight: FontWeight.w600)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _revenueRow(int idx, Color accent) {
    // example static rows — replace with your data
    final items = [
      {'title': 'In-App Bookings', 'sub': 'Mobile & Web', 'amount': 420.0},
      {'title': 'Walk-ins', 'sub': 'Onspot', 'amount': 250.0},
      {'title': 'Subscriptions', 'sub': 'Monthly Plans', 'amount': 360.0},
      {'title': 'Other', 'sub': 'Fees & tips', 'amount': 220.0},
    ];
    final it = items[idx % items.length];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.grey.shade100, child: Icon(idx % 2 == 0 ? Icons.phone_android : Icons.store, color: accent)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(it['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(it['sub'] as String, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ]),
          ),
          Text(_formatCurrency(it['amount'] as double), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // simple currency formatter (USD style). Change prefix if needed.
  String _formatCurrency(double v) {
    if (v >= 1000) {
      return '\$${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}k';
    }
    return '\$${v.toStringAsFixed(0)}';
  }

  // small label for bar indices
  String _smallLabelForIndex(int i) {
    const labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return labels[i % labels.length];
  }
}

/// Animated vertical bar widget (simple, no external deps)
class _AnimatedBar extends StatelessWidget {
  final double ratio; // 0..1
  final String label;
  final Color accent;
  final bool isLast;

  const _AnimatedBar({
    required this.ratio,
    required this.label,
    required this.accent,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isLast ? accent : accent.withOpacity(0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: ratio),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final maxHeight = 80.0;
              return Container(
                height: maxHeight * value,
                width: 12,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
