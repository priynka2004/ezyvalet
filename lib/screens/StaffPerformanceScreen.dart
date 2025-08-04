import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class StaffPerformanceScreen extends StatelessWidget {
  const StaffPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Staff Performance',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overview",
                style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMetricCard("Total Cars Handled", "234"),
                const SizedBox(width: 12),
                _buildMetricCard("Average Retrieval Time", "12 min"),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Staff Metrics",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStaffMetric("assets/images/images.png", "Ethan Carter", "120 cars"),
            const SizedBox(height: 12),
            _buildStaffMetric("assets/images/images.png", "Liam Harper", "114 cars"),
            const SizedBox(height: 24),
            const Text("Cars Handled",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("234",
                style: AppTextStyles.titleStyle),
            const SizedBox(height: 8),
            const Text("Last 7 Days",
              style: AppTextStyles.highlightedText,),
            const SizedBox(height: 12),
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.labelStyle),
            const SizedBox(height: 8),
            Text(value,
                style: AppTextStyles.titleStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffMetric(String imagePath, String name, String carsHandled) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(carsHandled, style: AppTextStyles.highlightedText,),
          ],
        )
      ],
    );
  }

  Widget _buildBarChart() {
    final heights = [80.0, 85.0, 83.0, 87.0, 84.0, 66.0, 81.0];
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(days.length, (index) {
        return Column(
          children: [
            Container(
              width: 14,
              height: heights[index],
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Text(days[index],
              style: AppTextStyles.highlightedText,),
          ],
        );
      }),
    );
  }
}
