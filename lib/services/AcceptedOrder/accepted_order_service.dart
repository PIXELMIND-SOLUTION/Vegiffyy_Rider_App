// lib/services/accepted_order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veggify_delivery_app/constants/api_constant.dart';

class AcceptedOrderService {
  /// GET accepted orders for rider
  /// returns List<Map<String,dynamic>> (server's data array)
  static Future<List<dynamic>> fetchAcceptedOrders(String deliveryBoyId) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/myacceptedorders/$deliveryBoyId');
    print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj$uri");
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    print('Response:;;;;;;;;;;;;;;;;${resp.body}');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
      if (jsonBody['success'] == true) {
        final data = jsonBody['data'] as List<dynamic>? ?? [];
        return data;
      } else {
        throw Exception(jsonBody['message'] ?? 'Failed to fetch accepted orders');
      }
    } else {
      throw Exception('Failed to fetch accepted orders: ${resp.statusCode} ${resp.body}');
    }
  }

  /// PUT accept-pickup -> mark as Picked
  static Future<Map<String, dynamic>> acceptPickup(String orderId, String deliveryBoyId) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/accept-pickup/$orderId/$deliveryBoyId');
    print("llllllllllllllllllllllll$uri");
    final body = json.encode({'orderStatus': 'Picked'});
    final resp = await http.put(uri, headers: {'Content-Type': 'application/json'}, body: body);
        print("llllllllllllllllllllllll${resp.body}");


    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to accept pickup: ${resp.statusCode} ${resp.body}');
    }
  }
}
