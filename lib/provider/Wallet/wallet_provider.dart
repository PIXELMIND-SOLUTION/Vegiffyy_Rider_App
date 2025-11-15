// lib/provider/wallet_provider.dart
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/models/Wallet/account.dart';
import 'package:veggify_delivery_app/models/Wallet/wallet.dart';
import 'package:veggify_delivery_app/services/Wallet/wallet_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum WalletState { idle, loading, loaded, error, submitting }

class WalletProvider extends ChangeNotifier {
  WalletState _state = WalletState.idle;
  String? _error;
  WalletData? _wallet;
  List<AccountModel> _accounts = [];

  WalletState get state => _state;
  String? get error => _error;
  WalletData? get wallet => _wallet;
  List<AccountModel> get accounts => _accounts;

  void _setState(WalletState s, {String? error}) {
    _state = s;
    _error = error;
    notifyListeners();
  }

  Future<void> loadWallet({String? deliveryBoyId}) async {
    _setState(WalletState.loading);
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');
      final json = await WalletService.getWallet(id);
      final data = json['data'] as Map<String, dynamic>?;

      if (data == null) throw Exception('Invalid wallet response');

      _wallet = WalletData.fromJson(data);
      _setState(WalletState.loaded);
    } catch (e) {
      _setState(WalletState.error, error: e.toString());
    }
  }

  Future<void> loadAccounts({String? deliveryBoyId}) async {
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');
      final json = await WalletService.getAccounts(id);
      final list = (json['data'] as List<dynamic>?) ?? [];
      _accounts = list.map((e) => AccountModel.fromJson(e as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addAccount(AccountModel account, {String? deliveryBoyId}) async {
    _setState(WalletState.submitting);
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');
      final json = await WalletService.addAccount(id, account.toJson());
      // server returns data array
      await loadAccounts(deliveryBoyId: id);
      await loadWallet(deliveryBoyId: id);
      _setState(WalletState.loaded);
      return true;
    } catch (e) {
      _setState(WalletState.error, error: e.toString());
      return false;
    }
  }

  Future<bool> withdraw(double amount, AccountModel account, {String? deliveryBoyId}) async {
    _setState(WalletState.submitting);
    try {
      final id = deliveryBoyId ?? await SessionManager.getUserId();
      if (id == null || id.isEmpty) throw Exception('User id not found');
      final json = await WalletService.withdraw(id, amount, {
        'accountNumber': account.accountNumber,
        'bankName': account.bankName,
        'accountHolderName': account.accountHolderName,
        'ifscCode': account.ifscCode,
      });

      // If success, reload wallet and accounts
      await loadWallet(deliveryBoyId: id);
      _setState(WalletState.loaded);
      return (json['success'] == true);
    } catch (e) {
      _setState(WalletState.error, error: e.toString());
      return false;
    }
  }
}
