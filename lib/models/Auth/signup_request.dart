// lib/models/signup_request.dart
class SignupRequest {
  final String fullName;
  final String mobileNumber;
  final String vehicleType;
  final String? email;
  final String? aadharCardPath;      // local file path
  final String? drivingLicensePath;  // local file path
  final String? profileImagePath;    // local file path

  SignupRequest({
    required this.fullName,
    required this.mobileNumber,
    required this.vehicleType,
    this.email,
    this.aadharCardPath,
    this.drivingLicensePath,
    this.profileImagePath,
  });
}
