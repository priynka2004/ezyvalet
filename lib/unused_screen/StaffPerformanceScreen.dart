import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StaffPerformanceScreen extends StatelessWidget {
  const StaffPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Colors.white;
    final cardBg = const Color(0xFFF6F8FA);
    final accent = const Color(0xFF7B563C);
    final subtitleStyle = TextStyle(color: Colors.grey.shade600);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          'Staff Performance',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview header
            const Text("Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Metric cards
            Row(
              children: [
                _metricCard("Total Cars Handled", "234", icon: Icons.local_shipping, bg: cardBg),
                const SizedBox(width: 12),
                _metricCard("Avg Retrieval Time", "12 min", icon: Icons.timer, bg: cardBg),
              ],
            ),
            const SizedBox(height: 20),

            // Staff metrics header
            const Text("Top Performers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Staff list (compact)
            _staffTile("Ethan Carter", "assets/images/images.png", "120 cars", accent),
            const SizedBox(height: 10),
            _staffTile("Liam Harper", "assets/images/images.png", "114 cars", accent),
            const SizedBox(height: 10),
            _staffTile("Sophia Bennett", "assets/images/images.png", "108 cars", accent),

            const SizedBox(height: 22),

            // Chart header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cars Handled", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text("Last 7 Days", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                // small legend
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text("Team total", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                )
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
              ),
              child: SizedBox(
                height: 220,
                child: _buildBarChart(),
              ),
            ),

            const SizedBox(height: 20),

            Text("Note: Retrieval time is averaged across all staff.", style: subtitleStyle),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, {IconData? icon, Color? bg}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg ?? const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))
                ]),
                child: Icon(icon, color: const Color(0xFF7B563C), size: 20),
              ),
            const SizedBox(width:10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _staffTile(String name, String avatarPath, String subtitle, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(avatarPath),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: accent, fontWeight: FontWeight.w500)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))
            ]),
            child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    // sample team totals for last 7 days
    final List<double> values = [65.0, 72.0, 68.0, 74.0, 77.0, 55.0, 70.0];

    // compute a nice maxY as double
    final double maxY = (values.reduce((a, b) => a > b ? a : b) / 10).ceil() * 10 + 10.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // only provide getTooltipItem (most versions support this)
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} cars',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (double value, TitleMeta meta) {
                const labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                final int idx = value.toInt();
                if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();

                // Use SideTitleWidget with axisSide from TitleMeta
                return SideTitleWidget(
                  //axisSide: meta.axisSide,
                  meta: meta,
                  child: Text(labels[idx], style: const TextStyle(fontSize: 12)),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(values.length, (i) {
          final double yVal = values[i];
          final bool isHighlight = i == 4; // highlight Friday for example

          return BarChartGroupData(
            x: i,
            barsSpace: 6.0,
            barRods: [
              BarChartRodData(
                toY: yVal,
                width: 18.0,
                borderRadius: BorderRadius.circular(6.0),
                color: isHighlight ? const Color(0xFF7B563C) : const Color(0xFFBDBDBD),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: const Color(0xFFF0F0F0),
                ),
              ),
            ],
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
    );
  }

}
