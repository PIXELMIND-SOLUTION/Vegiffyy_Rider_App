// lib/models/wallet.dart
class DailyEarning {
  final String date; // "2025-11-10"
  final String day; // "Monday"
  final double earnings;

  DailyEarning({required this.date, required this.day, required this.earnings});

  factory DailyEarning.fromJson(Map<String, dynamic> j) {
    final e = j['earnings'];
    return DailyEarning(
      date: j['date']?.toString() ?? '',
      day: j['day']?.toString() ?? '',
      earnings: (e is num) ? e.toDouble() : double.tryParse(e?.toString() ?? '0') ?? 0.0,
    );
  }
}

class WalletData {
  final double walletBalance;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final List<DailyEarning> dailyEarnings;

  WalletData({
    required this.walletBalance,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.dailyEarnings,
  });

  factory WalletData.fromJson(Map<String, dynamic> j) {
    final data = j;
    final list = (data['dailyEarnings'] as List<dynamic>?) ?? [];
    return WalletData(
      walletBalance: (data['walletBalance'] is num) ? (data['walletBalance'] as num).toDouble() : double.tryParse('${data['walletBalance']}') ?? 0.0,
      todayEarnings: (data['todayEarnings'] is num) ? (data['todayEarnings'] as num).toDouble() : double.tryParse('${data['todayEarnings']}') ?? 0.0,
      weekEarnings: (data['weekEarnings'] is num) ? (data['weekEarnings'] as num).toDouble() : double.tryParse('${data['weekEarnings']}') ?? 0.0,
      monthEarnings: (data['monthEarnings'] is num) ? (data['monthEarnings'] as num).toDouble() : double.tryParse('${data['monthEarnings']}') ?? 0.0,
      dailyEarnings: list.map((e) => DailyEarning.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
