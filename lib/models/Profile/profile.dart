// lib/models/profile.dart
class Profile {
  final String id;
  final String fullName;
  final String? email;
  final String mobileNumber;
  final String vehicleType;
  final String? aadharCard;
  final String? drivingLicense;
  final String? profileImage;
  final bool isActive;
  final String deliveryBoyStatus;
  final double baseDeliveryCharge;
  final double walletBalance;

  Profile({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.vehicleType,
    this.email,
    this.aadharCard,
    this.drivingLicense,
    this.profileImage,
    required this.isActive,
    required this.deliveryBoyStatus,
    required this.baseDeliveryCharge,
    required this.walletBalance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] as String?,
      mobileNumber: json['mobileNumber'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      aadharCard: json['aadharCard'] as String?,
      drivingLicense: json['drivingLicense'] as String?,
      profileImage: json['profileImage'] as String?,
      isActive: json['isActive'] == true,
      deliveryBoyStatus: json['deliveryBoyStatus'] ?? '',
      baseDeliveryCharge: (json['baseDeliveryCharge'] is num) ? (json['baseDeliveryCharge'] as num).toDouble() : 0.0,
      walletBalance: (json['walletBalance'] is num) ? (json['walletBalance'] as num).toDouble() : 0.0,
    );
  }
}
