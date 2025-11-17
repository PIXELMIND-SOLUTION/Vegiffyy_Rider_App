import 'dart:convert';
import 'package:http/http.dart' as http;

class NewOrderService {
  static const String baseUrl = 'http://31.97.206.144:5051'; // adjust if different

  /// fetch orders for delivery boy - returns List<Map<String,dynamic>>
  static Future<List<dynamic>> fetchOrders(String deliveryBoyId) async {
    print(deliveryBoyId);
    final url = Uri.parse('$baseUrl/api/myorders/$deliveryBoyId');
        print("tttttttttttttttttttttttttttttttttttttttttt$url");

    final resp = await http.get(url);
    print("tttttttttttttttttttttttttttttttttttttttttt${resp.body}");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to fetch orders: ${resp.statusCode}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (json['success'] != true) throw Exception(json['message'] ?? 'Failed to fetch orders');
    final orders = json['orders'] as List<dynamic>? ?? [];
    return orders;
  }

  /// accept order
  static Future<Map<String, dynamic>> acceptOrder(String orderId, String deliveryBoyId) async {
    final url = Uri.parse('$baseUrl/api/accept-order/$orderId/$deliveryBoyId');
        print("ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss$url");

    final resp = await http.put(url, headers: {'Content-Type': 'application/json'},body: jsonEncode({'orderStatus': 'Rider Accepted'}),);
    print("kggggggggggggdddddddddddddddddddddddddddddddd${resp.body}");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to accept order: ${resp.statusCode}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return json;
  }

  /// reject order - based on your API sample you can pass orderStatus "Rider Rejected"
  static Future<Map<String, dynamic>> rejectOrder(String orderId, String deliveryBoyId) async {
    final url = Uri.parse('$baseUrl/api/accept-order/$orderId/$deliveryBoyId');
    // send PUT with body { "orderStatus": "Rider Rejected" }
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'orderStatus': 'Rider Rejected'}),
    );
        print("kggggggggggggdddddddddddddddddddddddddddddddd${resp.body}");

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to reject order: ${resp.statusCode}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return json;
  }
}
