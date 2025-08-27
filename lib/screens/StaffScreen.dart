import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezyvalet/screens/service/staff_provider.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:cherry_toast/cherry_toast.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final DateTime selectedDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
    });
  }

  void _showStaffDialog(BuildContext context, {int? staffId, String? staffName}) {
    _nameController.text = staffName ?? "";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.people, color: AppColors.highlight),
            const SizedBox(width: 8),
            Text(staffId == null ? "Add Staff" : "Edit Staff",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Staff Name",
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.highlight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              if (_nameController.text.trim().isEmpty) return;

              final provider = Provider.of<StaffProvider>(context, listen: false);

              // Show loading while operation
              provider.isLoading = true;

              if (staffId == null) {
                await provider.addStaff(_nameController.text.trim());
                CherryToast.success(
                  title: const Text("Staff Added Successfully"),
                  animationType: AnimationType.fromBottom,
                  autoDismiss:true,
                ).show(context);
              } else {
                await provider.updateStaff(staffId, _nameController.text.trim());
                CherryToast.info(
                  title: const Text("Staff Updated Successfully"),
                  animationType: AnimationType.fromBottom,
                  autoDismiss: true,
                ).show(context);
              }

              await provider.fetchStaff();

              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text("Save", style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.highlight,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text(
          'Staff Availability',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Consumer<StaffProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) return const Center(child: CircularProgressIndicator());

            final staffList = provider.staffList;
            if (staffList.isEmpty) return const Center(child: Text("No staff available"));

            final availableCount = staffList.where((s) => s["is_active"] == true).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Manage Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(_formatDate(selectedDate),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.highlight),
                    const SizedBox(width: 8),
                    Text('$availableCount valet(s) available on ${selectedDate.day}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: staffList.length,
                    itemBuilder: (ctx, i) {
                      final staff = staffList[i];
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
                            Expanded(child: Text(staff["staff_name"] ?? "Unknown", style: AppTextStyles.bodyText)),
                            Switch(
                              value: staff["is_active"] ?? false,
                              onChanged: (val) async {
                                provider.isLoading = true;
                                await provider.toggleAvailability(staff["id"], val);
                                CherryToast.info(
                                  title: Text(val ? "Marked Active" : "Marked Inactive"),
                                  animationType: AnimationType.fromBottom,
                                  autoDismiss: true,
                                ).show(context);
                                await provider.fetchStaff();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showStaffDialog(
                                context,
                                staffId: staff["id"],
                                staffName: staff["staff_name"],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () async {
                                provider.isLoading = true;
                                provider.notifyListeners();
                                await provider.deleteStaff(staff["id"]);
                                CherryToast.error(
                                  title: const Text("Staff Deleted Successfully"),
                                  animationType: AnimationType.fromBottom,
                                  autoDismiss: true,
                                ).show(context);
                                await provider.fetchStaff();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.highlight,
        onPressed: () => _showStaffDialog(context),
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text('Add Staff Member', style: AppTextStyles.buttonWhiteText),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
