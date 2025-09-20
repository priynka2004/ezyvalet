class VendorProfile {
  final String vendorName;
  final String vendorAddress;
  final String city;
  final String state;
  final String pinCode;
  final String mobileNumber;
  final String email;

  VendorProfile({
    required this.vendorName,
    required this.vendorAddress,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.mobileNumber,
    required this.email,
  });

  factory VendorProfile.fromJson(Map<String, dynamic> json) {
    return VendorProfile(
      vendorName: json['vendor_name'] ?? '',
      vendorAddress: json['vendor_address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pin_code'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'VendorProfile(vendorName: $vendorName, vendorAddress: $vendorAddress, city: $city, state: $state, pinCode: $pinCode, mobileNumber: $mobileNumber, email: $email)';
  }
}
