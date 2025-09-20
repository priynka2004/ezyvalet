import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_images.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:ezyvalet/screens/my_drawer.dart';
import 'package:ezyvalet/screens/provider/ValetEntryProvider.dart';
import 'package:ezyvalet/screens/service/staff_service.dart';
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

  int? _selectedStaffId;
  List<Map<String, dynamic>> _staffList = [];

  @override
  void initState() {
    super.initState();
    _carPlateController.clear();
    _customerMobileController.clear();
    _selectedStaffId = null;
    _loadStaff();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carPlateController.clear();
    _customerMobileController.clear();
    _selectedStaffId = null;
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staffService = StaffService();
    final staff = await staffService.getStaffList();
    if (!mounted) return;
    setState(() {
      _staffList = staff;
    });
  }

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
          child: RefreshIndicator(
            onRefresh: _loadStaff,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

                  const Text("Select Staff", style: TextStyle(color: AppColors.dark)),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<int>(
                    value: _selectedStaffId != null &&
                        _staffList.any((staff) => staff["id"] == _selectedStaffId)
                        ? _selectedStaffId
                        : null,
                    items: _staffList.map<DropdownMenuItem<int>>((staff) {
                      return DropdownMenuItem<int>(
                        value: staff["id"],
                        child: Text(staff["staff_name"] ?? ""),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedStaffId = val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      prefixIcon: const Icon(Icons.groups_outlined),
                      hintText: "Select Staff",
                      hintStyle: TextStyle(color: AppColors.dark),
                    ),
                  ),

                  const SizedBox(height: 20),
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
                        if (_selectedStaffId == null) {
                          CherryToast.error(
                            title: const Text("Please select a staff member"),
                            animationType: AnimationType.fromLeft,
                            autoDismiss: true,
                          ).show(context);
                          return;
                        }

                        final selected = _staffList.firstWhere((s) => s["id"] == _selectedStaffId);
                        if (selected["isActive"] == false) {
                          CherryToast.error(
                            title: const Text("Inactive staff cannot enter a vehicle."),
                            animationType: AnimationType.fromLeft,
                            autoDismiss: true,
                          ).show(context);
                          return;
                        }


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
                          staffId: _selectedStaffId!,
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
        border: Border.all(color:  AppColors.dark),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color:  AppColors.dark),
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
          hintStyle: const TextStyle(color:AppColors.dark),
          prefixIcon: Icon(icon, color: AppColors.dark),
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
            Image.asset(
              AppImages.retrieval,
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
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
                    data: widget.scanResultUrl,
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
            Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 4,
                ),
                child: Text(
                  "Done",
                  style: AppTextStyles.appBarTitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
