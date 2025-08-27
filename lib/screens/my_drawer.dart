// import 'package:ezyvalet/authintiction/EditProfileScree.dart';
// import 'package:ezyvalet/authintiction/ProfileScreen.dart';
// import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
// import 'package:ezyvalet/authintiction/change_password_screen.dart';
// import 'package:ezyvalet/authintiction/provider/login_provider.dart';
// import 'package:ezyvalet/authintiction/provider/logout_provider.dart';
// import 'package:ezyvalet/constants/app_colors.dart';
// import 'package:ezyvalet/html/html_view_screen.dart';
// import 'package:ezyvalet/screens/AnalyticsScreen.dart';
// import 'package:ezyvalet/screens/StaffScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyDrawer extends StatefulWidget {
//   const MyDrawer({super.key});
//
//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }
//
// class _MyDrawerState extends State<MyDrawer> {
//   final Color accent = AppColors.highlight;
//
//   late String token;
//   String? userName;
//   String? userEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadToken();
//   }
//
//   Future<void> _loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedToken = prefs.getString('access_token');
//     if (savedToken != null && savedToken.isNotEmpty) {
//         setState(() {
//           token = prefs.getString('access_token')!;
//           userName = prefs.getString('user_name') ?? "Guest User";
//           userEmail = prefs.getString('user_email') ?? "guest@email.com";
//           token = savedToken;
//         });
//
//     } else {
//       debugPrint("Token not available yet.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [accent, accent.withOpacity(0.9)],
//                 ),
//                 borderRadius:
//                     const BorderRadius.vertical(bottom: Radius.circular(16)),
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const ProfileScreen()),
//                     ),
//                     child: const CircleAvatar(
//                       radius: 28,
//                       backgroundImage: AssetImage('assets/images/images.png'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           userName ?? "Loading...",
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           userEmail ?? "",
//                           style: const TextStyle(
//                               color: Colors.white70, fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const EditProfileScreen()),
//                     ),
//                     icon: const Icon(Icons.edit, color: Colors.white),
//                   )
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Drawer items
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   _drawerItem(
//                     context,
//                     text: 'Staff',
//                     icon: Icons.people,
//                     onTap: () => _navigate(context, const StaffScreen()),
//                   ),
//                   _drawerItem(
//                     context,
//                     text: 'Analytics',
//                     icon: Icons.analytics_outlined,
//                     onTap: () => _navigate(context, const AnalyticsScreen()),
//                   ),
//                   const Divider(),
//                   _drawerItem(
//                     context,
//                     text: 'Change Password',
//                     icon: Icons.password,
//                     onTap: () {
//                       final token =
//                           Provider.of<LoginProvider>(context, listen: false)
//                               .token;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChangePasswordScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   const Divider(),
//                   _sectionLabel('General'),
//                   _placeholderItem(
//                     context,
//                     'About Us',
//                     Icons.info_outline,
//                     url: 'https://ezyvalet.bonanso.com/about/us/',
//                   ),
//                   _placeholderItem(
//                     context,
//                     'Terms & Conditions',
//                     Icons.article_outlined,
//                     url: 'https://ezyvalet.bonanso.com/terms/conditions/',
//                   ),
//                   _placeholderItem(
//                     context,
//                     'Refund Policy',
//                     Icons.currency_exchange,
//                     url: 'https://ezyvalet.bonanso.com/refund/policies/',
//                   ),
//                   _placeholderItem(
//                     context,
//                     'Privacy Policy',
//                     Icons.privacy_tip_outlined,
//                     url: 'https://ezyvalet.bonanso.com/privacy/policies/',
//                   ),
//
//                 ],
//               ),
//             ),
//
//             // Footer
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//               child: Column(
//                 children: [
//                   const Divider(),
//                   Row(
//                     children: [
//                       const Icon(Icons.info_outline,
//                           size: 18, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       const Expanded(
//                         child: Text('App version 1.0.0',
//                             style: TextStyle(color: Colors.black54)),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           await context.read<LogoutProvider>().logout(context);
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return VendorLoginScreen();
//                           }));
//                         },
//                         child: const Text(
//                           'Sign out',
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _navigate(BuildContext context, Widget screen) {
//     Navigator.pop(context);
//     Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
//   }
//
//   Widget _drawerItem(
//     BuildContext context, {
//     required String text,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(
//             text,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           ),
//           trailing: Icon(icon, color: accent),
//           onTap: onTap,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         //  const Divider(indent: 20, endIndent: 20, height: 1),
//       ],
//     );
//   }
//
//   Widget _sectionLabel(String label) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 10, 0, 6),
//       child: Text(
//         label.toUpperCase(),
//         style: const TextStyle(
//             fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _placeholderItem(
//       BuildContext context,
//       String title,
//       IconData icon, {
//         String? assetPath,
//         String? url,
//       }) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HtmlFromApiScreen(
//               title: title,
//              // assetPath: assetPath,
//               url: url,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
// }


import 'package:ezyvalet/authintiction/EditProfileScree.dart';
import 'package:ezyvalet/authintiction/ProfileScreen.dart';
import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';
import 'package:ezyvalet/authintiction/change_password_screen.dart';
import 'package:ezyvalet/authintiction/provider/login_provider.dart';
import 'package:ezyvalet/authintiction/provider/logout_provider.dart';
import 'package:ezyvalet/authintiction/provider/profile_provider.dart'; // ✅ ProfileProvider import
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/html/html_view_screen.dart';
import 'package:ezyvalet/screens/AnalyticsScreen.dart';
import 'package:ezyvalet/screens/StaffScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final Color accent = AppColors.highlight;

  @override
  void initState() {
    super.initState();
    // ✅ Profile API call
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [

            Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                final profile = profileProvider.profile;

                String userName = profile?['vendor_name'] ??
                    profile?['username'] ??
                    "Guest User";

                String userEmail = profile?['email'] ?? "guest@email.com";

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withOpacity(0.9)],
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/images/images.png'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                      )
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Drawer Items (same as before)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    context,
                    text: 'Staff',
                    icon: Icons.people,
                    onTap: () => _navigate(context, const StaffScreen()),
                  ),
                  _drawerItem(
                    context,
                    text: 'Analytics',
                    icon: Icons.analytics_outlined,
                    onTap: () => _navigate(context, const AnalyticsScreen()),
                  ),
                  const Divider(),
                  _drawerItem(
                    context,
                    text: 'Change Password',
                    icon: Icons.password,
                    onTap: () {
                      final token =
                          Provider.of<LoginProvider>(context, listen: false)
                              .token;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _sectionLabel('General'),
                  _placeholderItem(
                    context,
                    'About Us',
                    Icons.info_outline,
                    url: 'https://ezyvalet.bonanso.com/about/us/',
                  ),
                  _placeholderItem(
                    context,
                    'Terms & Conditions',
                    Icons.article_outlined,
                    url: 'https://ezyvalet.bonanso.com/terms/conditions/',
                  ),
                  _placeholderItem(
                    context,
                    'Refund Policy',
                    Icons.currency_exchange,
                    url: 'https://ezyvalet.bonanso.com/refund/policies/',
                  ),
                  _placeholderItem(
                    context,
                    'Privacy Policy',
                    Icons.privacy_tip_outlined,
                    url: 'https://ezyvalet.bonanso.com/privacy/policies/',
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                children: [
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('App version 1.0.0',
                            style: TextStyle(color: Colors.black54)),
                      ),
                      TextButton(
                        onPressed: () async {
                          await context.read<LogoutProvider>().logout(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return VendorLoginScreen();
                              }));
                        },
                        child: const Text(
                          'Sign out',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _drawerItem(
      BuildContext context, {
        required String text,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(icon, color: accent),
          onTap: onTap,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
            fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _placeholderItem(
      BuildContext context,
      String title,
      IconData icon, {
        String? assetPath,
        String? url,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HtmlFromApiScreen(
              title: title,
              url: url,
            ),
          ),
        );
      },
    );
  }
}
