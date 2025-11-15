// lib/services/api_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:veggify_delivery_app/constants/api_constant.dart';

class ApiService {
  ApiService._();
  static const _registerPath = '/api/delivery-boy/register';

  /// Multipart register request. Returns parsed json on success.
  static Future<Map<String, dynamic>> registerDeliveryBoy({
    required String fullName,
    required String mobileNumber,
    required String vehicleType,
    String? email,
    String? aadharCardPath,
    String? drivingLicensePath,
    String? profileImagePath,
  }) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_registerPath');

    final request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields['fullName'] = fullName;
    request.fields['mobileNumber'] = mobileNumber;
    request.fields['vehicleType'] = vehicleType;
    if (email != null) request.fields['email'] = email;

    // Add files if provided (multipart)
    Future<void> _maybeAttach(String field, String? path) async {
      if (path == null) return;
      final file = File(path);
      if (!await file.exists()) return;
      final filename = file.path.split(Platform.pathSeparator).last;
      // MultipartFile.fromPath will autodetect content-type on many platforms
      final multipartFile = await http.MultipartFile.fromPath(field, file.path, filename: filename);
      request.files.add(multipartFile);
    }

    await _maybeAttach('aadharCard', aadharCardPath);
    await _maybeAttach('drivingLicense', drivingLicensePath);
    await _maybeAttach('profileImage', profileImagePath);

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
      return jsonBody;
    } else {
      // try to parse error message
      String message = 'Server error: ${resp.statusCode}';
      try {
        final j = json.decode(resp.body);
        if (j is Map && j['message'] != null) message = j['message'];
      } catch (_) {}
      throw HttpException(message);
    }
  }
}
