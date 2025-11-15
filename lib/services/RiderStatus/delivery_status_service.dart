import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryStatusService {
  static const String baseUrl = 'http://31.97.206.144:5051';

  /// Fetches profile and returns normalized status: 'active' or 'inactive'.
  static Future<String> fetchStatus(String deliveryBoyId) async {
    final url = Uri.parse('$baseUrl/api/delivery-boy/myprofile/$deliveryBoyId');
    final resp = await http.get(url);

    // === Debug prints (very helpful) ===
    print('fetchStatus() -> URL: $url');
    print('fetchStatus() -> statusCode: ${resp.statusCode}');
    print('fetchStatus() -> body: ${resp.body}');
    // ===================================

    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch profile: ${resp.statusCode}');
    }

    final Map<String, dynamic> jsonMap = jsonDecode(resp.body) as Map<String, dynamic>;

    // Basic success check (matches your pasted response)
    final ok = jsonMap['success'] == true;
    if (!ok) {
      throw Exception(jsonMap['message'] ?? 'fetchStatus: success flag false');
    }

    final data = jsonMap['data'];
    if (data == null || data is! Map<String, dynamic>) {
      // unexpected shape
      throw Exception('fetchStatus: data missing or not an object');
    }

    // Extract status robustly
    final rawStatus = data['deliveryBoyStatus'];
    String statusStr = '';

    if (rawStatus == null) {
      // some responses may use another field name; try alternative keys
      statusStr = (data['status'] ?? data['deliveryStatus'] ?? '').toString();
    } else {
      statusStr = rawStatus.toString();
    }

    statusStr = statusStr.trim().toLowerCase();

    if (statusStr == 'active') return 'active';
    if (statusStr == 'inactive') return 'inactive';

    // Fallback: if unknown or empty, treat as inactive
    return 'inactive';
  }

  /// Update status (keeps your previous implementation)
  static Future<Map<String, dynamic>> updateStatus(String deliveryBoyId, String status) async {
    final url = Uri.parse('$baseUrl/api/delivery-boy/deliveryboystatus/$deliveryBoyId');
    print('updateStatus() -> URL: $url, body: {"deliveryBoyStatus": "$status"}');

    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'deliveryBoyStatus': status}),
    );

    print('updateStatus() -> statusCode: ${resp.statusCode}');
    print('updateStatus() -> body: ${resp.body}');

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to update status: ${resp.statusCode}');
    }

    final Map<String, dynamic> jsonMap = jsonDecode(resp.body) as Map<String, dynamic>;
    if (jsonMap['success'] != true) {
      throw Exception(jsonMap['message'] ?? 'Failed to update status');
    }

    return jsonMap;
  }
}
