// lib/services/PickedOrder/picked_order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veggify_delivery_app/constants/api_constant.dart';

class PickedOrderService {
  /// GET picked orders for a rider
  /// Returns List<Map<String,dynamic>> (the raw JSON array) on success
  static Future<List<dynamic>> fetchPickedOrders(String deliveryBoyId) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/riderpicked-orders/$deliveryBoyId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
      if (jsonBody['success'] == true && jsonBody['data'] is List) {
        return jsonBody['data'] as List<dynamic>;
      } else {
        throw Exception(jsonBody['message'] ?? 'Invalid response');
      }
    } else {
      throw Exception('Failed to fetch picked orders: ${resp.statusCode} - ${resp.body}');
    }
  }
}
