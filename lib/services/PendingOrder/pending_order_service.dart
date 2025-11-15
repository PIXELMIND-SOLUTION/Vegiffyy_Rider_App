import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/Order/pending_order_model.dart';
import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum NewOrderState { idle, loading, loaded, error, submitting }

class NewOrderProvider extends ChangeNotifier {
  NewOrderState _state = NewOrderState.idle;
  String? _error;
  final List<PendingOrder> _pendingOrders = [];
  final Set<String> _notifiedOrderIds = {}; // prevent duplicate popups

  NewOrderState get state => _state;
  String? get error => _error;
  UnmodifiableListView<PendingOrder> get pendingOrders => UnmodifiableListView(_pendingOrders);

  void _setState(NewOrderState s, {String? err}) {
    _state = s;
    _error = err;
    notifyListeners();
  }

  /// called by NotificationTester initial fetch - replace local list
  void updatePendingOrders(List<PendingOrder> list) {
    _pendingOrders.clear();
    _pendingOrders.addAll(list);
    notifyListeners();
  }

  PendingOrder? getFirstUnnotifiedOrder() {
    for (var o in _pendingOrders) {
      if (!_notifiedOrderIds.contains(o.id)) return o;
    }
    return null;
  }

  void markOrderAsNotified(String id) {
    _notifiedOrderIds.add(id);
    notifyListeners();
  }

  Future<void> fetchNewOrders({String? deliveryBoyId}) async {
    _setState(NewOrderState.loading);
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id missing');
      final jsonList = await NewOrderService.fetchOrders(id);
      final list = jsonList.map((e) => PendingOrder.fromJson(e)).toList();
      updatePendingOrders(list);
      _setState(NewOrderState.loaded);
    } catch (e) {
      _setState(NewOrderState.error, err: e.toString());
    }
  }

  /// Accept order - calls API and updates local list
  Future<bool> acceptOrder(String orderId, {String? deliveryBoyId}) async {
    _setState(NewOrderState.submitting);
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id missing');
      final resp = await NewOrderService.acceptOrder(orderId, id);
      // remove from pending locally
      _pendingOrders.removeWhere((o) => o.id == orderId);
      _notifiedOrderIds.remove(orderId);
      notifyListeners();
      _setState(NewOrderState.loaded);
      return (resp['success'] == true);
    } catch (e) {
      _setState(NewOrderState.error, err: e.toString());
      return false;
    }
  }

  /// Reject order
  Future<bool> rejectOrder(String orderId, {String? deliveryBoyId}) async {
    _setState(NewOrderState.submitting);
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id missing');
      final resp = await NewOrderService.rejectOrder(orderId, id);
      _pendingOrders.removeWhere((o) => o.id == orderId);
      _notifiedOrderIds.remove(orderId);
      notifyListeners();
      _setState(NewOrderState.loaded);
      return (resp['success'] == true);
    } catch (e) {
      _setState(NewOrderState.error, err: e.toString());
      return false;
    }
  }
}
