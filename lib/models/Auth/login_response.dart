// lib/models/auth/login_response.dart
class LoginResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? deliveryBoy;
  final String? authToken;
  final int? otp;

  LoginResponse({
    required this.success,
    required this.message,
    this.deliveryBoy,
    this.authToken,
    this.otp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] == true,
      message: json['message'] ?? '',
      deliveryBoy: json['deliveryBoy'] as Map<String, dynamic>?,
      authToken: json['authToken'] as String?,
      otp: json['otp'] is int ? json['otp'] as int : null,
    );
  }
}
