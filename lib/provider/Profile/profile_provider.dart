// lib/provider/Auth/profile_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/Profile/profile.dart';
import 'package:veggify_delivery_app/services/Profile/profile_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum ProfileState { idle, loading, success, error, updating }

class ProfileProvider extends ChangeNotifier {
  ProfileState _state = ProfileState.idle;
  Profile? _profile;
  String? _errorMessage;

  ProfileState get state => _state;
  Profile? get profile => _profile;
  String? get errorMessage => _errorMessage;

  void _setState(ProfileState s, {String? error}) {
    _state = s;
    _errorMessage = error;
    notifyListeners();
  }

  /// Load profile using stored userId (SessionManager)
  Future<void> loadProfile({String? userId, String? authToken}) async {
    _setState(ProfileState.loading);
    try {
      final id = userId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) {
        _setState(ProfileState.error, error: 'User id not found');
        return;
      }

      final json = await ProfileService.getProfile(id, authToken: authToken ?? await SessionManager.getAuthToken());
      // server returns { success: true, message: ..., data: { ... } }
      final data = json['data'] as Map<String, dynamic>?;
      if (data == null) {
        _setState(ProfileState.error, error: 'Invalid profile response');
        return;
      }

      _profile = Profile.fromJson(data);
      _setState(ProfileState.success);
    } catch (e) {
      _setState(ProfileState.error, error: e.toString());
    }
  }

  /// Update profile image and refresh profile on success
  Future<bool> uploadProfileImage(File imageFile) async {
    if (_profile == null) {
      _setState(ProfileState.error, error: 'Profile not loaded');
      return false;
    }

    _setState(ProfileState.updating);
    try {
      final id = _profile!.id;
      final json = await ProfileService.updateProfileImage(
        deliveryBoyId: id,
        imageFile: imageFile,
        authToken: await SessionManager.getAuthToken(),
      );

      // if server responds with updated data in `data`
      final data = json['data'] as Map<String, dynamic>?;
      if (data != null) {
        _profile = Profile.fromJson(data);
      } else {
        // fallback: reload profile
        await loadProfile(userId: id);
      }

      _setState(ProfileState.success);
      return true;
    } catch (e) {
      _setState(ProfileState.error, error: e.toString());
      return false;
    }
  }

  /// Update basic profile fields (name, email). Returns true on success.
  Future<bool> updateProfile({String? fullName, String? email}) async {
    _setState(ProfileState.updating);
    try {
      // prefer current loaded profile id, otherwise session manager
      final id = await SessionManager.getUserId();
      if (id == null || id.isEmpty) {
        _setState(ProfileState.error, error: 'User id not found');
        return false;
      }

      final body = {
        if (fullName != null) 'fullName': fullName,
        if (email != null) 'email': email,
      };

      final json = await ProfileService.updateProfile(
        deliveryBoyId: id,
        body: body,
        authToken: await SessionManager.getAuthToken(),
      );

      // If response includes updated `data`, refresh local profile
      final data = json['data'] as Map<String, dynamic>?;
      if (data != null) {
        _profile = Profile.fromJson(data);
      } else {
        // fallback to reloading profile
        await loadProfile(userId: id);
      }

      _setState(ProfileState.success);
      return true;
    } catch (e) {
      _setState(ProfileState.error, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    _profile = null;
    _setState(ProfileState.idle);
  }
}
