// lib/providers/signup_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/Auth/signup_response.dart';
import 'package:veggify_delivery_app/services/Auth/api_service.dart';

enum SignupState { idle, loading, success, error }

class SignupProvider extends ChangeNotifier {
  SignupState _state = SignupState.idle;
  String? _errorMessage;
  bool _isLoading = false;

  SignupState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _setLoading([bool v = true]) {
    _isLoading = v;
    _state = v ? SignupState.loading : SignupState.idle;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = SignupState.error;
    _isLoading = false;
    notifyListeners();
  }

  void _setSuccess() {
    _errorMessage = null;
    _state = SignupState.success;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == SignupState.error) _state = SignupState.idle;
    notifyListeners();
  }

  void resetState() {
    _state = SignupState.idle;
    _errorMessage = null;
    _isLoading = false;
  }

  // Basic validators (used in your screen)
  bool isValidName(String v) => v.trim().length >= 2;
  bool isValidEmail(String v) {
    final re = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$");
    return re.hasMatch(v.trim());
  }
  bool isValidPhone(String v) {
    final re = RegExp(r'^[0-9]{10,15}$');
    return re.hasMatch(v.trim());
  }
  bool isValidPassword(String v) {
    // at least 8 chars, includes upper, lower, digit, special
    final re = RegExp(r'(?=^.{8,}$)(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W)');
    return re.hasMatch(v);
  }

  /// Main signup method used by the screen
  Future<bool> signupRider({
    required String name,
    required String phone,
    required String vehicleType,
    String? email,
    String? aadharPath,
    String? drivingLicensePath,
    String? profileImage,
    String? password,
  }) async {
    _setLoading(true);
    try {
      final json = await ApiService.registerDeliveryBoy(
        fullName: name,
        mobileNumber: phone,
        vehicleType: vehicleType,
        email: email,
        aadharCardPath: aadharPath,
        drivingLicensePath: drivingLicensePath,
        profileImagePath: profileImage,
      );

      // parse
      final resp = SignupResponse.fromJson(json);
      if (resp.message.toLowerCase().contains('success')) {
        _setSuccess();
        return true;
      } else {
        _setError(resp.message.isNotEmpty ? resp.message : 'Signup failed');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      if (_state != SignupState.success) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
