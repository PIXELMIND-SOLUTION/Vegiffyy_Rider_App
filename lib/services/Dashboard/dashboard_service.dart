// lib/services/dashboard_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String _base = 'http://31.97.206.144:5051';

  /// Fetch dashboard for delivery boy id.
  /// Optional [filter] will be sent as query param e.g. ?filter=thisweek
  static Future<Map<String, dynamic>> fetchDashboard(String deliveryBoyId, {String? filter}) async {
    final uri = Uri.parse('$_base/api/delivery-boy/mydashboard/$deliveryBoyId')
        .replace(queryParameters: filter != null && filter.isNotEmpty ? {'filter': filter} : null);
print("kkkkkkhhhhhhhhhhhhhhhhhhhhhhhhhhhh$uri");
    final resp = await http.get(uri);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to load dashboard: ${resp.statusCode}');
    }

    try {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      if (json['success'] != true) {
        throw Exception(json['message'] ?? 'Dashboard API returned failure');
      }
      return json;
    } catch (e) {
      throw Exception('Failed to parse dashboard response: $e');
    }
  }
}
