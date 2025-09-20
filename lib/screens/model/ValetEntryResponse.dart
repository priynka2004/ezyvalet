
class ValetEntryResponse {
  final String? pin;
  final String? qrCodeUrl;
  final String? scanResultUrl;
  final int id;
  final String carPlateNumber;
  final String customerMobileNumber;
  final bool carActive;

  ValetEntryResponse({
    this.pin,
    this.qrCodeUrl,
    this.scanResultUrl,
    required this.id,
    required this.carPlateNumber,
    required this.customerMobileNumber,
    required this.carActive,
  });

  factory ValetEntryResponse.fromJson(Map<String, dynamic> json) {
    return ValetEntryResponse(
      pin: json['pin'] as String?,
      qrCodeUrl: json['qr_code_image_url'] as String?,
      scanResultUrl: json['scan_result_url'] as String?,
      id: json['id'] ?? 0,
      carPlateNumber: json['car_plate_number'] ?? "",
      customerMobileNumber: json['customer_mobile_number'] ?? "",
      carActive: json['car_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pin": pin,
      "qr_code_image_url": qrCodeUrl,
      "scan_result_url": scanResultUrl,
      "id": id,
      "car_plate_number": carPlateNumber,
      "customer_mobile_number": customerMobileNumber,
      "car_active": carActive,
    };
  }
}

