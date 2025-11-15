// lib/services/profile_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:veggify_delivery_app/constants/api_constant.dart';

class ProfileService {
  static const _profilePath = '/api/delivery-boy/myprofile';
  static const _updateImagePath = '/api/delivery-boy/updateProfileImage';
  static const _updateProfilePath = '/api/updateprofile'; // new

  /// GET profile by id
  static Future<Map<String, dynamic>> getProfile(String id, {String? authToken}) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_profilePath/$id');
    final headers = <String, String>{'Accept': 'application/json'};
    if (authToken != null) headers['Authorization'] = 'Bearer $authToken';

    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile (${resp.statusCode}): ${resp.body}');
    }
  }

  /// PUT profile image (multipart/form-data)
  static Future<Map<String, dynamic>> updateProfileImage({
    required String deliveryBoyId,
    required File imageFile,
    String? authToken,
  }) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_updateImagePath/$deliveryBoyId');
    final request = http.MultipartRequest('PUT', uri);

    if (authToken != null) request.headers['Authorization'] = 'Bearer $authToken';
    request.files.add(await http.MultipartFile.fromPath('profileImage', imageFile.path));

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update profile image (${resp.statusCode}): ${resp.body}');
    }
  }

  /// PUT update basic profile data (json body)
  /// body example: { "fullName": "John Doe", "email": "johndoe@example.com" }
  static Future<Map<String, dynamic>> updateProfile({
    required String deliveryBoyId,
    required Map<String, dynamic> body,
    String? authToken,
  }) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}$_updateProfilePath/$deliveryBoyId');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) headers['Authorization'] = 'Bearer $authToken';

    final resp = await http.put(uri, headers: headers, body: json.encode(body));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update profile (${resp.statusCode}): ${resp.body}');
    }
  }
}
