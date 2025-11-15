// lib/models/dashboard/dashboard.dart
class DailyEarning {
  final String date;
  final String day;
  final double earnings;

  DailyEarning({
    required this.date,
    required this.day,
    required this.earnings,
  });

  factory DailyEarning.fromJson(Map<String, dynamic> json) {
    return DailyEarning(
      date: json['date']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      earnings: (json['earnings'] is num) ? (json['earnings'] as num).toDouble() : 0.0,
    );
  }
}

class DashboardData {
  final int completedOrdersCount;
  final int todayOrdersCount;
  final int cancelledOrdersCount;
  final double walletBalance;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final List<DailyEarning> dailyEarnings;

  DashboardData({
    required this.completedOrdersCount,
    required this.todayOrdersCount,
    required this.cancelledOrdersCount,
    required this.walletBalance,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.dailyEarnings,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final list = (json['dailyEarnings'] as List<dynamic>?) ?? [];
    return DashboardData(
      completedOrdersCount: (json['completedOrdersCount'] is int)
          ? json['completedOrdersCount'] as int
          : int.tryParse(json['completedOrdersCount']?.toString() ?? '0') ?? 0,
      todayOrdersCount: (json['todayOrdersCount'] is int)
          ? json['todayOrdersCount'] as int
          : int.tryParse(json['todayOrdersCount']?.toString() ?? '0') ?? 0,
      cancelledOrdersCount: (json['cancelledOrdersCount'] is int)
          ? json['cancelledOrdersCount'] as int
          : int.tryParse(json['cancelledOrdersCount']?.toString() ?? '0') ?? 0,
      walletBalance: (json['walletBalance'] is num) ? (json['walletBalance'] as num).toDouble() : 0.0,
      todayEarnings: (json['todayEarnings'] is num) ? (json['todayEarnings'] as num).toDouble() : 0.0,
      weekEarnings: (json['weekEarnings'] is num) ? (json['weekEarnings'] as num).toDouble() : 0.0,
      monthEarnings: (json['monthEarnings'] is num) ? (json['monthEarnings'] as num).toDouble() : 0.0,
      dailyEarnings: list.map((e) => DailyEarning.fromJson(e as Map<String,dynamic>)).toList(),
    );
  }
}
