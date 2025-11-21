import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/global/notification_service.dart';
import 'package:veggify_delivery_app/models/Order/pending_order_model.dart';
import 'package:veggify_delivery_app/provider/Dashboard/dashboard_provider.dart';
import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
import 'package:veggify_delivery_app/services/PendingOrder/pending_order_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';


/// NotificationTester sits invisible in the widget tree (you already put it in main.builder)
/// It listens to DeliveryStatusProvider and starts / stops polling for new orders.
/// When a new order is detected it shows the forced popup using NotificationService.
class NotificationTester extends StatefulWidget {
  const NotificationTester({Key? key}) : super(key: key);

  @override
  State<NotificationTester> createState() => _NotificationTesterState();
}

class _NotificationTesterState extends State<NotificationTester> {
  Timer? _pollTimer;
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    // listen to provider changes after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statusProv = Provider.of<DeliveryStatusProvider>(context, listen: false);
      // start/stop based on initial state
      _handleStatusChange(statusProv.isOnline);

      // observe changes
      statusProv.addListener(() {
        _handleStatusChange(statusProv.isOnline);
      });
    });
  }

  void _handleStatusChange(bool online) {
    if (online && !_isPolling) {
      _startPolling();
    } else if (!online && _isPolling) {
      _stopPolling();
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _isPolling = true;

    // immediate fetch then periodic
    _fetchAndNotify();

    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchAndNotify();
    });
  }

  Future<void> _fetchAndNotify() async {
    try {
      final id = await SessionManager.getUserId();
      if (id == null || id.isEmpty) return;

      final ordersJson = await NewOrderService.fetchOrders(id);
      final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

      // service returns list; provider can also be notified
      final prov = Provider.of<NewOrderProvider>(context, listen: false);
      final newOrders = ordersJson.map((e) => PendingOrder.fromJson(e)).toList();

      // If provider has no orders or a new order exists, update provider
      prov.updatePendingOrders(newOrders);

      // if there is at least one order and it's new (provider decides), show popup:
      final first = prov.getFirstUnnotifiedOrder();
      if (first != null) {
        // Mark it as notified before showing to avoid duplicates
        prov.markOrderAsNotified(first.id);

        // show forced popup using NotificationService (your NotificationService handles sound)
        await NotificationService.instance.showOrderAlert(
          orderData: first.toMap(),
          onAccept: (orderData) async {
            // call accept in provider
            await prov.acceptOrder(first.id,dashboardProvider: dashboardProvider);
          },
          onReject: (orderData) async {
            await prov.rejectOrder(first.id);
          },
        );
      }
    } catch (e, st) {
      debugPrint('NotificationTester fetch error: $e\n$st');
    }
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _isPolling = false;
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // completely invisible in UI
    return const SizedBox.shrink();
  }
}
