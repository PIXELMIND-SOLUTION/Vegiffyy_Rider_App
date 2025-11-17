// lib/provider/accepted_order_provider.dart
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/Order/accepted_order_model.dart';
import 'package:veggify_delivery_app/services/AcceptedOrder/accepted_order_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum AcceptedOrderState { idle, loading, loaded, error, submitting }

class AcceptedOrderProvider extends ChangeNotifier {
  AcceptedOrderState _state = AcceptedOrderState.idle;
  String? _error;
  List<OrderModel> _acceptedOrders = [];

  AcceptedOrderState get state => _state;
  String? get error => _error;
  List<OrderModel> get acceptedOrders => List.unmodifiable(_acceptedOrders);

  void _setState(AcceptedOrderState s, {String? err}) {
    _state = s;
    _error = err;
    notifyListeners();
  }

  /// Fetch accepted orders for the current rider
  Future<void> fetchAcceptedOrders({String? deliveryBoyIdOverride}) async {
    _setState(AcceptedOrderState.loading);
    try {
      final id = deliveryBoyIdOverride ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');
      final list = await AcceptedOrderService.fetchAcceptedOrders(id);
      _acceptedOrders = list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      _setState(AcceptedOrderState.loaded);
    } catch (e) {
      _setState(AcceptedOrderState.error, err: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await fetchAcceptedOrders();
  }

  /// Accept pickup (mark as Picked). Returns true on success.
  Future<bool> acceptPickup(String orderId, {String? deliveryBoyIdOverride}) async {
    _setState(AcceptedOrderState.submitting);
    try {
      final id = deliveryBoyIdOverride ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');
      final res = await AcceptedOrderService.acceptPickup(orderId, id);
      // if success, update local lists: remove from acceptedOrders or change status
      if (res['success'] == true) {
        _acceptedOrders.removeWhere((o) => o.id == orderId);
        _setState(AcceptedOrderState.loaded);
        return true;
      } else {
        _setState(AcceptedOrderState.error, err: res['message']?.toString() ?? 'Failed to accept pickup');
        return false;
      }
    } catch (e) {
      _setState(AcceptedOrderState.error, err: e.toString());
      return false;
    }
  }
}
