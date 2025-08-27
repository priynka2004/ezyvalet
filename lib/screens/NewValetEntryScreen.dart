// import 'dart:io';
// import 'dart:ui';
// import 'package:cherry_toast/cherry_toast.dart';
// import 'package:cherry_toast/resources/arrays.dart';
// import 'package:http/http.dart' as http;
// import 'package:ezyvalet/constants/app_colors.dart';
// import 'package:ezyvalet/constants/app_text_styles.dart';
// import 'package:ezyvalet/screens/my_drawer.dart';
// import 'package:ezyvalet/screens/provider/ValetEntryProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class NewValetEntryScreen extends StatefulWidget {
//   final String token;
//   const NewValetEntryScreen({super.key, required this.token});
//
//   @override
//   State<NewValetEntryScreen> createState() => _NewValetEntryScreenState();
// }
//
// class _NewValetEntryScreenState extends State<NewValetEntryScreen> {
//   final _carPlateController = TextEditingController();
//   final _customerMobileController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ValetEntryProvider>();
//
//     return Scaffold(
//       endDrawer: MyDrawer(),
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppColors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Icon(Icons.directions_car, color: AppColors.highlight),
//             const SizedBox(width: 8),
//             Text(
//               'EzyValet',
//               style: TextStyle(
//                 color: AppColors.highlight,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Builder(
//             builder: (context) => IconButton(
//               onPressed: () {
//                 Scaffold.of(context).openEndDrawer();
//               },
//               icon: const Icon(Icons.menu, color: AppColors.highlight),
//             ),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColors.buttonLight,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade400, width: 0.5),
//           ),
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'New Valet Entry',
//                   style: TextStyle(
//                       color: AppColors.dark,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "Enter customer's car and mobile number.",
//                   style: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Car Plate Number
//                 const Text('Car Plate Number',
//                     style: TextStyle(color: AppColors.dark)),
//                 const SizedBox(height: 8),
//                 _customTextField(
//                   controller: _carPlateController,
//                   hint: 'Plate Number',
//                   icon: Icons.directions_car,
//                   isCarPlate: true,
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 const Text('Customer Mobile Number',
//                     style: TextStyle(color: AppColors.dark)),
//                 const SizedBox(height: 8),
//                 _customTextField(
//                   controller: _customerMobileController,
//                   hint: 'Mobile No.',
//                   icon: Icons.phone_android_rounded,
//                   isPhone: true,
//                 ),
//
//                 const SizedBox(height: 32),
//
//
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: provider.isLoading
//                         ? null
//                         : () async {
//                       final carPlate = _carPlateController.text.trim();
//                       final mobile = _customerMobileController.text.trim();
//
//                       // Car plate validation
//                       if (carPlate.isEmpty) {
//                         CherryToast.error(
//                           title: const Text("Please enter car plate number"),
//                           animationType: AnimationType.fromLeft,
//                           autoDismiss: true,
//                         ).show(context);
//                         return;
//                       }
//                       if (!RegExp(r'^[A-Z0-9/]+$').hasMatch(carPlate)) {
//                         CherryToast.error(
//                           title: const Text("Invalid car plate format"),
//                           animationType: AnimationType.fromLeft,
//                           autoDismiss: true,
//                         ).show(context);
//                         return;
//                       }
//
//                       // Phone validation
//                       if (mobile.isEmpty) {
//                         CherryToast.error(
//                           title: const Text("Please enter mobile number"),
//                           animationType: AnimationType.fromLeft,
//                           autoDismiss: true,
//                         ).show(context);
//                         return;
//                       }
//                       if (mobile.length != 10) {
//                         CherryToast.error(
//                           title: const Text("Mobile number must be 10 digits"),
//                           animationType: AnimationType.fromLeft,
//                           autoDismiss: true,
//                         ).show(context);
//                         return;
//                       }
//
//                       final success = await provider.createEntry(
//                         carPlateNumber: carPlate,
//                         customerMobileNumber: mobile,
//                       );
//
//                       if (success) {
//                         final pin = provider.lastCreatedPin ?? "0000";
//                         _carPlateController.clear();
//                         _customerMobileController.clear();
//
//                         showDialog(
//                           context: context,
//                           builder: (_) => ValetQRCodePopup(
//                             carPlate: carPlate,
//                             pin: pin,
//                             customerMobile: mobile,
//                             qrCodeUrl: provider.qrCodeUrl,
//                           ),
//                         );
//
//                         CherryToast.success(
//                           title: const Text("Valet entry created successfully"),
//                           animationType: AnimationType.fromTop,
//                           autoDismiss: true,
//                         ).show(context);
//                       } else {
//                         CherryToast.error(
//                           title: Text(provider.errorMessage ?? "Error"),
//                           animationType: AnimationType.fromTop,
//                           autoDismiss: true,
//                         ).show(context);
//                       }
//                     },
//                     icon: const Icon(Icons.qr_code, color: AppColors.white),
//                     label: provider.isLoading
//                         ? const CircularProgressIndicator(
//                       color: Colors.white,
//                     )
//                         : const Text(
//                       'Generate QR Code & Park',
//                       style: AppTextStyles.buttonWhiteText,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.button,
//                       foregroundColor: AppColors.dark,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   static Widget _customTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool isPhone = false,
//     bool isCarPlate = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.grey),
//       ),
//       child: TextField(
//         controller: controller,
//         style: const TextStyle(color: AppColors.grey),
//         keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
//         textCapitalization: isCarPlate
//             ? TextCapitalization.characters
//             : TextCapitalization.none, // Car plate in uppercase
//         inputFormatters: isPhone
//             ? [
//           FilteringTextInputFormatter.digitsOnly,
//           LengthLimitingTextInputFormatter(10),
//         ]
//             : isCarPlate
//             ? [
//           FilteringTextInputFormatter.allow(
//             RegExp(r'[A-Z0-9/]'), // Only uppercase letters, digits, and slash
//           ),
//           LengthLimitingTextInputFormatter(10), // Adjust as per format
//         ]
//             : [],
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(color: AppColors.grey),
//           prefixIcon: Icon(icon, color: AppColors.grey),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//       ),
//     );
//   }
//
// }
//
// class ValetQRCodePopup extends StatefulWidget {
//   final String carPlate;
//   final String pin;
//   final String customerMobile;
//   final String? qrCodeUrl;
//
//   const ValetQRCodePopup({
//     required this.carPlate,
//     required this.pin,
//     required this.customerMobile,
//     this.qrCodeUrl,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ValetQRCodePopup> createState() => _ValetQRCodePopupState();
// }
//
// class _ValetQRCodePopupState extends State<ValetQRCodePopup> {
//   final GlobalKey _qrKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _sendWhatsAppMessage();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final qrData = _buildQRUrl();
//
//     return Dialog(
//       backgroundColor: AppColors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Vehicle Retrieval QR',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Card(
//               color: AppColors.white,
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: RepaintBoundary(
//                   key: _qrKey,
//                   child: PrettyQr(
//                     data: qrData,
//                     size: 170,
//                     errorCorrectLevel: QrErrorCorrectLevel.M,
//                     roundEdges: true,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             _infoRow(Icons.directions_car, "Car Plate", widget.carPlate),
//             const SizedBox(height: 24),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 "Done",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: AppColors.highlight,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.grey.shade200,
//           child: Icon(icon, color: Colors.black87),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label,
//                   style: const TextStyle(fontSize: 14, color: Colors.grey)),
//               Text(value,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   String _buildQRUrl() {
//     final baseUrl = 'https://ezyvalet.bonanso.com';
//     final encodedCarPlate = Uri.encodeComponent(widget.carPlate);
//     return '$baseUrl/valet/scan/result/?plate=$encodedCarPlate&pin=${widget.pin}';
//   }
//
//   Future<void> _sendWhatsAppMessage() async {
//     final message =
//         "🚗 Your valet request is confirmed!\nCar Plate: ${widget.carPlate}\nPIN: ${widget.pin}\nClick here to retrieve: ${_buildQRUrl()}";
//
//     String phone = widget.customerMobile.replaceAll(RegExp(r'[^0-9]'), '');
//     if (!phone.startsWith("91")) {
//       phone = "91$phone";
//     }
//
//     final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
//
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint("Could not launch WhatsApp");
//     }
//   }
//
// }
//
//
//



import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:ezyvalet/screens/my_drawer.dart';
import 'package:ezyvalet/screens/provider/ValetEntryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewValetEntryScreen extends StatefulWidget {
  final String token;
  const NewValetEntryScreen({super.key, required this.token});

  @override
  State<NewValetEntryScreen> createState() => _NewValetEntryScreenState();
}

class _NewValetEntryScreenState extends State<NewValetEntryScreen> {
  final _carPlateController = TextEditingController();
  final _customerMobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ValetEntryProvider>();

    return Scaffold(
      endDrawer: MyDrawer(),
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.directions_car, color: AppColors.highlight),
            const SizedBox(width: 8),
            Text(
              'EzyValet',
              style: TextStyle(
                color: AppColors.highlight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu, color: AppColors.highlight),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.buttonLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Valet Entry',
                  style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Enter customer's car and mobile number.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Car Plate Number
                const Text('Car Plate Number',
                    style: TextStyle(color: AppColors.dark)),
                const SizedBox(height: 8),
                _customTextField(
                  controller: _carPlateController,
                  hint: 'Plate Number',
                  icon: Icons.directions_car,
                  isCarPlate: true,
                ),

                const SizedBox(height: 20),

                const Text('Customer Mobile Number',
                    style: TextStyle(color: AppColors.dark)),
                const SizedBox(height: 8),
                _customTextField(
                  controller: _customerMobileController,
                  hint: 'Mobile No.',
                  icon: Icons.phone_android_rounded,
                  isPhone: true,
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                      final carPlate = _carPlateController.text.trim();
                      final mobile = _customerMobileController.text.trim();

                      // Car plate validation
                      if (carPlate.isEmpty) {
                        CherryToast.error(
                          title: const Text("Please enter car plate number"),
                          animationType: AnimationType.fromLeft,
                          autoDismiss: true,
                        ).show(context);
                        return;
                      }
                      if (!RegExp(r'^[A-Z0-9/]+$').hasMatch(carPlate)) {
                        CherryToast.error(
                          title: const Text("Invalid car plate format"),
                          animationType: AnimationType.fromLeft,
                          autoDismiss: true,
                        ).show(context);
                        return;
                      }

                      // Phone validation
                      if (mobile.isEmpty) {
                        CherryToast.error(
                          title: const Text("Please enter mobile number"),
                          animationType: AnimationType.fromLeft,
                          autoDismiss: true,
                        ).show(context);
                        return;
                      }
                      if (mobile.length != 10) {
                        CherryToast.error(
                          title: const Text("Mobile number must be 10 digits"),
                          animationType: AnimationType.fromLeft,
                          autoDismiss: true,
                        ).show(context);
                        return;
                      }

                      final success = await provider.createEntry(
                        carPlateNumber: carPlate,
                        customerMobileNumber: mobile,
                      );

                      if (success && provider.lastCreatedEntry != null) {
                        final entry = provider.lastCreatedEntry!;
                        _carPlateController.clear();
                        _customerMobileController.clear();

                        showDialog(
                          context: context,
                          builder: (_) => ValetQRCodePopup(
                            carPlate: entry.carPlateNumber,
                            pin: entry.pin ?? "0000",
                            customerMobile: entry.customerMobileNumber,
                            scanResultUrl: entry.scanResultUrl ?? "",
                          ),
                        );

                        CherryToast.success(
                          title: const Text("Valet entry created successfully"),
                          animationType: AnimationType.fromTop,
                          autoDismiss: true,
                        ).show(context);
                      } else {
                        CherryToast.error(
                          title: Text(provider.errorMessage ?? "Error"),
                          animationType: AnimationType.fromTop,
                          autoDismiss: true,
                        ).show(context);
                      }
                    },
                    icon: const Icon(Icons.qr_code, color: AppColors.white),
                    label: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Generate QR Code & Park',
                      style: AppTextStyles.buttonWhiteText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: AppColors.dark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPhone = false,
    bool isCarPlate = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.grey),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        textCapitalization:
        isCarPlate ? TextCapitalization.characters : TextCapitalization.none,
        inputFormatters: isPhone
            ? [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ]
            : isCarPlate
            ? [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9/]')),
          LengthLimitingTextInputFormatter(10),
        ]
            : [],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: Icon(icon, color: AppColors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

class ValetQRCodePopup extends StatefulWidget {
  final String carPlate;
  final String pin;
  final String customerMobile;
  final String scanResultUrl;

  const ValetQRCodePopup({
    required this.carPlate,
    required this.pin,
    required this.customerMobile,
    required this.scanResultUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<ValetQRCodePopup> createState() => _ValetQRCodePopupState();
}

class _ValetQRCodePopupState extends State<ValetQRCodePopup> {
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendWhatsAppMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Vehicle Retrieval QR',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              color: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RepaintBoundary(
                  key: _qrKey,
                  child: PrettyQr(
                    data: widget.scanResultUrl, // ✅ use API URL
                    size: 170,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    roundEdges: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.directions_car, "Car Plate", widget.carPlate),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Done",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.highlight,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black87),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _sendWhatsAppMessage() async {
    final message =
        "🚗 Your valet request is confirmed!\nCar Plate: ${widget.carPlate}\nPIN: ${widget.pin}\nClick here to retrieve: ${widget.scanResultUrl}";

    String phone = widget.customerMobile.replaceAll(RegExp(r'[^0-9]'), '');
    if (!phone.startsWith("91")) {
      phone = "91$phone";
    }

    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp");
    }
  }
}
