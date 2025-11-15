// // lib/provider/delivery_status_provider.dart
// import 'package:flutter/material.dart';
// import 'package:veggify_delivery_app/services/RiderStatus/delivery_status_service.dart';
// import 'package:veggify_delivery_app/utils/session_manager.dart';

// enum DeliveryStatusState { idle, loading, loaded, updating, error }

// class DeliveryStatusProvider extends ChangeNotifier {
//   DeliveryStatusState _state = DeliveryStatusState.idle;
//   String? _error;
//   bool _isOnline = false;

//   DeliveryStatusState get state => _state;
//   String? get error => _error;
//   bool get isOnline => _isOnline;

//   void _setState(DeliveryStatusState s, {String? err}) {
//     _state = s;
//     _error = err;
//     notifyListeners();
//   }

//   /// Load current status from server (uses SessionManager.getUserId())
//   Future<void> loadStatus({String? userIdOverride}) async {
//     _setState(DeliveryStatusState.loading);
//     try {
//       final id = userIdOverride ?? await SessionManager.getUserId();
//       if (id == null || id.isEmpty) throw Exception('User id not found');
//       final status = await DeliveryStatusService.fetchStatus(id);
//       _isOnline = status.toLowerCase() == 'active';
//       print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk1111111111111111${_isOnline}");

//       _setState(DeliveryStatusState.loaded);
//     } catch (e) {
//       _setState(DeliveryStatusState.error, err: e.toString());
//     }
//   }

//   /// Toggle status (if currently online -> set inactive, else active)
//   Future<void> toggleStatus({String? userIdOverride}) async {
//     _setState(DeliveryStatusState.updating);
//     print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${_isOnline}");

//     try {
//       final id = userIdOverride ?? await SessionManager.getUserId();
//       if (id == null || id.isEmpty) throw Exception('User id not found');
// print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${_isOnline}");
//       final newStatus = _isOnline ? 'active' : 'inactive';
//       await DeliveryStatusService.updateStatus(id, newStatus);

//       // update local flag only if server succeeded
//       _isOnline = newStatus == 'active';
//       _setState(DeliveryStatusState.loaded);
//     } catch (e) {
//       _setState(DeliveryStatusState.error, err: e.toString());
//       // keep previous _isOnline value unchanged in case of error
//     }
//   }

//   /// Force set local value (useful for optimistic UI; will NOT call server)
//   void setLocal(bool online) {
//     _isOnline = online;
//     notifyListeners();
//   }
// }














// lib/provider/delivery_status_provider.dart
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/services/RiderStatus/delivery_status_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum DeliveryStatusState { idle, loading, loaded, updating, error }

class DeliveryStatusProvider extends ChangeNotifier {
  DeliveryStatusState _state = DeliveryStatusState.idle;
  String? _error;
  bool _isOnline = false;

  DeliveryStatusState get state => _state;
  String? get error => _error;
  bool get isOnline => _isOnline;

  void _setState(DeliveryStatusState s, {String? err}) {
    _state = s;
    _error = err;
    notifyListeners();
  }

  /// Load current status from server (uses SessionManager.getUserId())
  Future<void> loadStatus({String? userIdOverride}) async {
    _setState(DeliveryStatusState.loading);
    try {
      final id = userIdOverride ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');

      final status = await DeliveryStatusService.fetchStatus(id);
      _isOnline = status.toLowerCase() == 'active';
      print("DeliveryStatusProvider.loadStatus -> isOnline: $_isOnline");

      _setState(DeliveryStatusState.loaded);
    } catch (e) {
      _setState(DeliveryStatusState.error, err: e.toString());
      debugPrint('DeliveryStatusProvider.loadStatus error: $e');
    }
  }

  /// Toggle status (if currently online -> set inactive, else active)
  /// Returns true on success, false on failure.
  Future<bool> toggleStatus({String? userIdOverride}) async {
    _setState(DeliveryStatusState.updating);
    print("DeliveryStatusProvider.toggleStatus BEFORE -> isOnline: $_isOnline");

    try {
      final id = userIdOverride ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');

      // If currently online, we want to set it to 'inactive', otherwise 'active'
      final String requestedStatus = _isOnline ? 'active' : 'inactive';
      final resp = await DeliveryStatusService.updateStatus(id, requestedStatus);

      // If server returns updated status in resp['data']['deliveryBoyStatus'], use it
      if (resp is Map<String, dynamic>) {
        final data = resp['data'] as Map<String, dynamic>?;
        if (data != null && data['deliveryBoyStatus'] != null) {
          final serverStatus = data['deliveryBoyStatus'].toString().toLowerCase();
          _isOnline = serverStatus == 'active';
        } else {
          // Fallback: assume success and set to requested value
          _isOnline = requestedStatus == 'active';
        }
      } else {
        // Fallback: assume success
        _isOnline = requestedStatus == 'active';
      }

      _setState(DeliveryStatusState.loaded);
      print("DeliveryStatusProvider.toggleStatus AFTER -> isOnline: $_isOnline");
      return true;
    } catch (e) {
      _setState(DeliveryStatusState.error, err: e.toString());
      debugPrint('DeliveryStatusProvider.toggleStatus error: $e');
      // Do not modify _isOnline on failure (keep previous state)
      return false;
    }
  }

  /// Force set local value (useful for optimistic UI; will NOT call server)
  void setLocal(bool online) {
    _isOnline = online;
    notifyListeners();
  }
}
