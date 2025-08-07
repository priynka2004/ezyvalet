import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final DateTime selectedDate = DateTime.now();
  Map<String, bool> staffAvailability = {
    'Aakash': false,
    'Romit': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.highlight,
        elevation: 1,
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
        title: Text(
          'Staff Availability',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildAvailabilitySummary(),
            const SizedBox(height: 16),
            _buildStaffList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.highlight,
        onPressed: () {
          _showAddStaffDialog(context);
        },
        icon: Icon(Icons.add, color: AppColors.white),
        label: Text('Add Staff Member', style:AppTextStyles.buttonWhiteText),
      ),

    );
  }

  void _showAddStaffDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add New Staff Member', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'e.g., Ramesh Kumar',
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.highlight),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey,),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',style: AppTextStyles.highlightedText,),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty && !staffAvailability.containsKey(name)) {
                  setState(() {
                    staffAvailability[name] = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add Staff', style: TextStyle(color:AppColors.white,)),
            ),
          ],
        );
      },
    );
  }


  Widget _buildHeader() {
    return const Text(
      'Manage Schedule',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          _formatDate(selectedDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySummary() {
    final availableCount = staffAvailability.values.where((v) => v).length;
    return Row(
      children: [
        Icon(Icons.person, color: AppColors.highlight),
        const SizedBox(width: 8),
        Text(
          '$availableCount valet(s) available on ${selectedDate.day}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildStaffList() {
    return Expanded(
      child: ListView(
        children: staffAvailability.keys.map((name) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Switch(
                  value: staffAvailability[name]!,
                  onChanged: (value) {
                    setState(() {
                      staffAvailability[name] = value;
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      staffAvailability.remove(name);
                    });
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}
