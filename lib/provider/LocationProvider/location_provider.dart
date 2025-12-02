// import 'package:flutter/foundation.dart';
// import 'package:veggify_delivery_app/services/Location/api_location.dart';
// import 'package:veggify_delivery_app/services/Location/location_sercice.dart';

// class LocationProvider extends ChangeNotifier {
//   String _address = 'Fetching location...';
//   List<double>? _coordinates;
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _errorMessage = '';

//   // Getters
//   String get address => _address;
//   List<double>? get coordinates => _coordinates;
//   bool get isLoading => _isLoading;
//   bool get hasError => _hasError;
//   String get errorMessage => _errorMessage;
//   bool get hasLocation => _coordinates != null && _coordinates!.length >= 2;

//   // Initialize location (get current location)
//   Future<void> initLocation(String userId) async {
//     try {
//       _isLoading = true;
//       _hasError = false;
//       _errorMessage = '';
//       notifyListeners();

//       // Get coordinates first
//       final coords = await LocationService.getCurrentCoordinates();
//       if (coords == null) {
//         throw Exception('Failed to get coordinates');
//       }
//       _coordinates = coords;

//       // Get address
//       final fullAddress = await LocationService.getCurrentAddress();
//       if (fullAddress == null) {
//         throw Exception('Failed to get address');
//       }

//       // Check if address contains error messages
//       if (fullAddress.contains('Location services are disabled') ||
//           fullAddress.contains('Location permission denied') ||
//           fullAddress.contains('permanently denied') ||
//           fullAddress.contains('Address not found')) {
//         throw Exception(fullAddress);
//       }

//       _address = _formatAddress(fullAddress);

//       print("latitude: ${_coordinates![0].toString()}");
//       print("longitude: ${_coordinates![1].toString()}");

      
//       // Call addLocation API with user's coordinates
//       final isSuccess = await ApiLocationService().addLocation(
//         userId: userId, 
//         latitude: _coordinates![0].toString(), // latitude
//         longitude: _coordinates![1].toString()  // longitude
//       );
      
//       if (!isSuccess) {
//         if (kDebugMode) {
//           print('Warning: Failed to save location to server');
//         }
//         // Note: We don't throw an error here as the location was still fetched successfully
//         // The API call failure shouldn't prevent the user from using the app
//       }

//       _isLoading = false;
//       _hasError = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _hasError = true;
//       _errorMessage = e.toString();
//       _address = 'Location not available';
//       _coordinates = null;
//       notifyListeners();
//     }
//   }

//   // Update location manually (from search)
//   Future<void> updateLocation(String newAddress, List<double> newCoordinates, String userId) async {
//     _address = _formatAddress(newAddress);
//     _coordinates = newCoordinates;
//     _isLoading = false;
//     _hasError = false;
//     _errorMessage = '';
//     print("llllllllllllllllllllllllllllllllllll$_address");
//           final isSuccess = await ApiLocationService().addLocation(
//         userId: userId, 
//         latitude: _coordinates![0].toString(), // latitude
//         longitude: _coordinates![1].toString()  // longitude
//       );
//           print("llllllllllllllllllllllllllllllllllll$isSuccess");

//     notifyListeners();
//   }

//   // Format address to show only first 2 parts
//   String _formatAddress(String fullAddress) {
//     if (fullAddress.isEmpty) return 'Unknown location';
    
//     final parts = fullAddress.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//     if (parts.isEmpty) return 'Unknown location';
    
//     return parts.length > 1 ? '${parts[0]}, ${parts[1]}' : parts[0];  
//   }

//   // Refresh current location
//   // Future<void> refreshLocation() async {
//   //   final user = await UserPreferences.getUser();
//   //   await initLocation("686cfbbbcd2def2c5d950f09");
//   // }

//   // Reset location state
//   void resetLocation() {
//     _address = 'Fetching location...';
//     _coordinates = null;
//     _isLoading = true;
//     _hasError = false;
//     _errorMessage = '';
//     notifyListeners();
//   }
// }















// lib/services/Location/location_provider.dart (or wherever you keep it)

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:veggify_delivery_app/services/Location/api_location.dart';
import 'package:veggify_delivery_app/services/Location/location_sercice.dart';

class LocationProvider extends ChangeNotifier {
  String _address = 'Fetching location...';
  List<double>? _coordinates;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // NEW: timer for periodic live updates
  Timer? _locationTimer;

  // Getters
  String get address => _address;
  List<double>? get coordinates => _coordinates;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasLocation => _coordinates != null && _coordinates!.length >= 2;

  // Initialize location (get current location)
  Future<void> initLocation(String userId) async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();

      // Get coordinates first
      final coords = await LocationService.getCurrentCoordinates();
      if (coords == null) {
        throw Exception('Failed to get coordinates');
      }
      _coordinates = coords;

      // Get address
      final fullAddress = await LocationService.getCurrentAddress();
      if (fullAddress == null) {
        throw Exception('Failed to get address');
      }

      // Check if address contains error messages
      if (fullAddress.contains('Location services are disabled') ||
          fullAddress.contains('Location permission denied') ||
          fullAddress.contains('permanently denied') ||
          fullAddress.contains('Address not found')) {
        throw Exception(fullAddress);
      }

      _address = _formatAddress(fullAddress);

      print("latitude: ${_coordinates![0].toString()}");
      print("longitude: ${_coordinates![1].toString()}");

      // Call addLocation API with user's coordinates
      final isSuccess = await ApiLocationService().addLocation(
        userId: userId,
        latitude: _coordinates![0].toString(), // latitude
        longitude: _coordinates![1].toString(), // longitude
      );

      if (!isSuccess) {
        if (kDebugMode) {
          print('Warning: Failed to save location to server');
        }
        // Note: We don't throw an error here as the location was still fetched successfully
        // The API call failure shouldn't prevent the user from using the app
      }

      _isLoading = false;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      _address = 'Location not available';
      _coordinates = null;
      notifyListeners();
    }
  }

  // Update location manually (from search)
  Future<void> updateLocation(
      String newAddress, List<double> newCoordinates, String userId) async {
    _address = _formatAddress(newAddress);
    _coordinates = newCoordinates;
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    print("llllllllllllllllllllllllllllllllllll$_address");

    final isSuccess = await ApiLocationService().addLocation(
      userId: userId,
      latitude: _coordinates![0].toString(), // latitude
      longitude: _coordinates![1].toString(), // longitude
    );
    print("llllllllllllllllllllllllllllllllllll$isSuccess");

    notifyListeners();
  }

  // Format address to show only first 2 parts
  String _formatAddress(String fullAddress) {
    if (fullAddress.isEmpty) return 'Unknown location';

    final parts = fullAddress
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'Unknown location';

    return parts.length > 1 ? '${parts[0]}, ${parts[1]}' : parts[0];
  }

  // NEW: internal helper to update live location (for timer use)
  Future<void> _updateLiveLocation(String userId) async {
    try {
                print("kkkkkkkkkkkkk2222$userId");

      final coords = await LocationService.getCurrentCoordinates();
      if (coords == null || coords.length < 2) {
        if (kDebugMode) {
          print('❌ Live location: failed to get coordinates');
        }
        return;
      }

      _coordinates = coords;

      if (kDebugMode) {
        print('📍 Live latitude: ${coords[0]}, longitude: ${coords[1]}');
      }

      final ok = await ApiLocationService().addLocation(
        userId: userId,
        latitude: coords[0].toString(),
        longitude: coords[1].toString(),
      );

      if (!ok && kDebugMode) {
        print('⚠️ Live location: failed to send to server');
      }

      // If UI depends on coordinates (e.g. small indicator), notify
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('🚨 Live location exception: $e');
      }
      // Don't change _hasError / _isLoading here, this is background-ish
    }
  }

  // NEW: start periodic live updates (every 5s) while app is alive
  void startLiveLocationUpdates(String userId) {
              print("kkkkkkkkkkkkk1111111111111111111111111111111111111111111111111");

    // avoid multiple timers
    if (_locationTimer != null) {
      return;
    }

    // Run once immediately
    _updateLiveLocation(userId);

    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateLiveLocation(userId);
    });

    if (kDebugMode) {
      print('✅ Live location updates started');
    }
  }

  // NEW: stop periodic updates
  void stopLiveLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;

    if (kDebugMode) {
      print('🛑 Live location updates stopped');
    }
  }

  // Reset location state
  void resetLocation() {
    _address = 'Fetching location...';
    _coordinates = null;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';

    // Also stop live updates when resetting
    stopLiveLocationUpdates();

    notifyListeners();
  }

  @override
  void dispose() {
    // Make sure timer is cleaned up when provider is disposed
    stopLiveLocationUpdates();
    super.dispose();
  }
}
