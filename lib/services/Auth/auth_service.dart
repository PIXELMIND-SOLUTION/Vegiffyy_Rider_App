// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veggify_delivery_app/constants/api_constant.dart';

class AuthService {
  AuthService._();

  static const _loginPath = '/api/delivery-boy/login';
  static const _verifyOtpPath = '/api/delivery-boy/verify-otp';
  static const _resendOtpPath = '/api/delivery-boy/resendotp';

  static Future<Map<String, dynamic>> login(String mobile) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_loginPath');
    final resp = await http.post(uri, body: {"mobileNumber": mobile});
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Login failed: ${resp.statusCode} ${resp.body}');
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_verifyOtpPath');
    final body = json.encode({"mobileNumber": mobile, "otp": int.tryParse(otp) ?? otp});
    final resp = await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('OTP verification failed: ${resp.statusCode} ${resp.body}');
    }
  }

  static Future<Map<String, dynamic>> resendOtp(String mobile) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_resendOtpPath');
    final resp = await http.post(uri, body: {"mobileNumber": mobile});
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Resend OTP failed: ${resp.statusCode} ${resp.body}');
    }
  }
}
