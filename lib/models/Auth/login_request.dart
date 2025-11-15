// lib/models/auth/login_request.dart
class LoginRequest {
  final String mobileNumber;
  LoginRequest({required this.mobileNumber});

  Map<String, dynamic> toJson() => {
        "mobileNumber": mobileNumber,
      };
}
