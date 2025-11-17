// lib/provider/PickedOrder/picked_order_provider.dart
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/Order/picked_order_model.dart';
import 'package:veggify_delivery_app/services/PickedOrder/picked_order_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum PickedOrderState { idle, loading, loaded, error }

class PickedOrderProvider extends ChangeNotifier {
  PickedOrderState _state = PickedOrderState.idle;
  String? _error;
  List<PickedOrderModel> _pickedOrders = [];

  PickedOrderState get state => _state;
  String? get error => _error;
  List<PickedOrderModel> get pickedOrders => List.unmodifiable(_pickedOrders);

  void _setState(PickedOrderState s, {String? error}) {
    _state = s;
    _error = error;
    notifyListeners();
  }

  /// Fetch picked orders for the current logged-in delivery boy (uses SessionManager)
  Future<void> fetchPickedOrders({String? deliveryBoyIdOverride}) async {
    _setState(PickedOrderState.loading);
    try {
      final id = deliveryBoyIdOverride ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('DeliveryBoy id not found');

      final raw = await PickedOrderService.fetchPickedOrders(id);
      _pickedOrders = raw.map((e) => PickedOrderModel.fromJson(e as Map<String, dynamic>)).toList();
      _setState(PickedOrderState.loaded);
    } catch (e) {
      _pickedOrders = [];
      _setState(PickedOrderState.error, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await fetchPickedOrders();
  }

  /// convenience: first picked order or null
  PickedOrderModel? get firstPickedOrder => _pickedOrders.isNotEmpty ? _pickedOrders.first : null;

  /// find by id
  PickedOrderModel? findById(String id) {
    try {
      return _pickedOrders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
