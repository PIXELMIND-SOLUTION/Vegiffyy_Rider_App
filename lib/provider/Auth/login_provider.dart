// lib/provider/Auth/login_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/services/Auth/auth_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';
import '../../models/auth/login_response.dart';

enum LoginState { idle, loading, otpSent, verifying, loggedIn, error }

class LoginProvider extends ChangeNotifier {
  LoginState _state = LoginState.idle;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  // OTP timer
  Timer? _otpTimer;
  int _remainingSeconds = 0;
  static const int otpCooldown = 30;

  LoginState get state => _state;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  bool get canResendOtp => _remainingSeconds == 0;
  int get remainingSeconds => _remainingSeconds;

  void _setState(LoginState s, {String? error}) {
    _state = s;
    _errorMessage = error;
    notifyListeners();
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _remainingSeconds = otpCooldown;
    notifyListeners();

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        _remainingSeconds = 0;
        _otpTimer?.cancel();
      }
      notifyListeners();
    });
  }

  void cancelTimer() {
    _otpTimer?.cancel();
    _remainingSeconds = 0;
    notifyListeners();
  }

  Future<bool> sendLoginOtp(String mobile) async {
    _setState(LoginState.loading);
    try {
      final json = await AuthService.login(mobile);
      _loginResponse = LoginResponse.fromJson(json);
      _setState(LoginState.otpSent);
      _startOtpTimer();
      return true;
    } catch (e) {
      _setState(LoginState.error, error: e.toString());
      return false;
    }
  }

Future<bool> verifyOtp(String mobile, String otp) async {
  _setState(LoginState.verifying);
  try {
    final json = await AuthService.verifyOtp(mobile, otp);
    final resp = LoginResponse.fromJson(json);
    _loginResponse = resp;

    // Extract user ID and token from response
    final deliveryBoy = resp.deliveryBoy;
    final token = resp.authToken;

    if (deliveryBoy != null && token != null) {
      final userId = deliveryBoy["_id"]?.toString() ?? "";
            final username = deliveryBoy["fullName"]?.toString() ?? "";


      // Save session
      await SessionManager.saveSession(userId: userId, token: token, name:username);
    }

    _setState(LoginState.loggedIn);
    cancelTimer();
    return true;
  } catch (e) {
    _setState(LoginState.error, error: e.toString());
    return false;
  }
}


  Future<bool> resendOtp(String mobile) async {
    if (!canResendOtp) return false;
    _setState(LoginState.loading);
    try {
      final json = await AuthService.resendOtp(mobile);
      final resp = LoginResponse.fromJson(json);
      _loginResponse = resp;
      _setState(LoginState.otpSent);
      _startOtpTimer();
      return true;
    } catch (e) {
      _setState(LoginState.error, error: e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    super.dispose();
  }
}
