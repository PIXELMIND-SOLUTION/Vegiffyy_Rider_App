// lib/models/signup_response.dart
class SignupResponse {
  final String message;
  final Map<String, dynamic>? data;
  final String? token;

  SignupResponse({required this.message, this.data, this.token});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? '',
      data: json['data'] as Map<String, dynamic>?,
      token: json['token'] as String?,
    );
  }
}
