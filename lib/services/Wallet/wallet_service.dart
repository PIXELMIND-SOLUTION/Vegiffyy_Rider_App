// lib/services/wallet_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:veggify_delivery_app/constants/api_constant.dart';

class WalletService {
  static Future<Map<String, dynamic>> getWallet(String deliveryBoyId) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/mywallet/$deliveryBoyId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load wallet: ${resp.statusCode} ${resp.body}');
  }

  static Future<Map<String, dynamic>> addAccount(String deliveryBoyId, Map<String, dynamic> payload) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/delivery-boy/add-account/$deliveryBoyId');
    final resp = await http.post(uri, headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, body: json.encode(payload));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to add account: ${resp.statusCode} ${resp.body}');
  }

  static Future<Map<String, dynamic>> getAccounts(String deliveryBoyId) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/delivery-boy/get-account/$deliveryBoyId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to get accounts: ${resp.statusCode} ${resp.body}');
  }

  static Future<Map<String, dynamic>> withdraw(String deliveryBoyId, double amount, Map<String, dynamic> accountDetails) async {
    final uri = Uri.parse('${ApiConstant.baseUrl}/api/delivery-boy/withdraw/$deliveryBoyId');
    final body = json.encode({'amount': amount, 'accountDetails': accountDetails});
    final resp = await http.post(uri, headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, body: body);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed withdraw: ${resp.statusCode} ${resp.body}');
  }
}
