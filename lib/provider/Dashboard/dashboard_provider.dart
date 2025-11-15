// lib/provider/dashboard_provider.dart
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/dashboard/dashboard.dart';
import 'package:veggify_delivery_app/services/Dashboard/dashboard_service.dart';

enum DashboardState { idle, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  DashboardState _state = DashboardState.idle;
  String? _error;
  DashboardData? _data;
  String _filter = 'thisweek'; // default

  DashboardState get state => _state;
  String? get error => _error;
  DashboardData? get data => _data;
  String get filter => _filter;
  bool get isLoading => _state == DashboardState.loading;
  bool get hasData => _data != null;

  void _setState(DashboardState s, {String? error}) {
    _state = s;
    _error = error;
    notifyListeners();
  }

  Future<void> loadDashboard(String deliveryBoyId, {String? filter}) async {
    _filter = filter ?? _filter;
    _setState(DashboardState.loading);
    try {
      final json = await DashboardService.fetchDashboard(deliveryBoyId, filter: _filter);
      final map = (json['data'] as Map<String, dynamic>?) ?? {};
      _data = DashboardData.fromJson(map);
      _setState(DashboardState.loaded);
    } catch (e) {
      _setState(DashboardState.error, error: e.toString());
    }
  }

  Future<void> refreshDashboard(String deliveryBoyId) async {
    await loadDashboard(deliveryBoyId, filter: _filter);
  }

  /// Change filter (e.g. 'today', 'thisweek', 'thismonth') and reload.
  Future<void> changeFilter(String deliveryBoyId, String newFilter) async {
    _filter = newFilter;
    await loadDashboard(deliveryBoyId, filter: newFilter);
  }
}
