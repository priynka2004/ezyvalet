import 'package:ezyvalet/authintiction/EditProfileScree.dart';
import 'package:ezyvalet/authintiction/provider/profile_provider.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchProfiles());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.buttonLight,
      appBar: AppBar(
        backgroundColor: AppColors.highlight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: const Text(
                    "Delete Profile",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                      "Are you sure you want to delete your profile? This action cannot be undone."),
                  actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(color: AppColors.dark)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Delete", style: TextStyle(color: AppColors.white),),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final provider = context.read<ProfileProvider>();
                int id = provider.profile?['id'] ?? 0;

                if (id == 0) {
                  CherryToast.error(
                    title: const Text("Invalid profile id"),
                    toastPosition: Position.bottom,
                    autoDismiss: true,
                  ).show(context);
                  return;
                }

                bool success = await provider.deleteProfile(id);

                if (success && mounted) {
                  CherryToast.success(
                    title: const Text("Profile deleted successfully"),
                    toastPosition: Position.bottom,
                    autoDismiss: true,
                  ).show(context);

                  Navigator.pop(context);
                } else {
                  CherryToast.error(
                    title: Text(provider.error ?? "Failed to delete profile"),
                    toastPosition: Position.bottom,
                    autoDismiss: true,
                  ).show(context);
                }
              }
            },
          ),
        ],
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text("Error: ${provider.error}"))
          : provider.profile == null
          ? const Center(child: Text("No profile found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Profile Header Card with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.highlight,
                    AppColors.highlight.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.highlight.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.profile?['vendor_name'] ??
                              "Vendor",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.profile?['email'] ?? "N/A",
                          style: TextStyle(
                            fontSize: 15,
                            color:
                            AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.white,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const EditProfileScreen()),
                        );
                      },
                      icon: Icon(Icons.edit,
                          color: AppColors.highlight),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 Contact Information
            _buildSectionTitle("Contact Information"),
            _buildInfoCard([
              _buildInfoTile(Icons.phone, "Mobile Number",
                  provider.profile?['mobile_number'] ?? "N/A"),
              _buildInfoTile(Icons.email, "Email",
                  provider.profile?['email'] ?? "N/A"),
            ]),

            const SizedBox(height: 24),

            /// 🔹 Address Information
            _buildSectionTitle("Address"),
            _buildInfoCard([
              _buildInfoTile(Icons.location_pin, "Street Address",
                  provider.profile?['vendor_address'] ?? "N/A"),
              _buildInfoTile(Icons.location_city, "City",
                  provider.profile?['city'] ?? "N/A"),
              _buildInfoTile(Icons.map_outlined, "State",
                  provider.profile?['state'] ?? "N/A"),
              _buildInfoTile(Icons.pin_drop, "Pincode",
                  provider.profile?['pin_code'] ?? "N/A"),
            ]),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.highlight,
          ),
        ),
      ),
    );
  }

  /// 🔹 Info Card
  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(children: children),
      ),
    );
  }

  /// 🔹 Single Info Tile
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.highlight.withOpacity(0.1),
            child: Icon(icon, color: AppColors.highlight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
