// lib/views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:veggify_delivery_app/provider/Dashboard/dashboard_provider.dart';
import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
import 'package:veggify_delivery_app/services/PendingOrder/pending_order_service.dart';
import 'package:veggify_delivery_app/views/orderdelivered/order_delivered_screen.dart';
import 'package:veggify_delivery_app/views/orderpickup/order_pickup_screen.dart';
import 'package:veggify_delivery_app/widgets/online_offline_button.dart';
import 'package:veggify_delivery_app/widgets/switch_widget.dart';
import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';
import 'package:veggify_delivery_app/global/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  String userId = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Initialize userId and location
  Future<void> _initializeData() async {
    try {
      await _loadUserId();
      final statusProv = Provider.of<DeliveryStatusProvider>(
        context,
        listen: false,
      );
      await statusProv.loadStatus(userIdOverride: userId);
      await _handleCurrentLocation();

      // Load dashboard data
      if (userId.isNotEmpty) {
        final dashboardProv = Provider.of<DashboardProvider>(
          context,
          listen: false,
        );
        await dashboardProv.loadDashboard(userId);
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> _loadUserId() async {
    try {
      final storedUserId = await SessionManager.getUserId();
      if (!mounted) return;
      setState(() {
        userId = storedUserId ?? '';
      });
      debugPrint('Loaded userId: $userId');
    } catch (e) {
      debugPrint('Failed to load userId: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCurrentLocation() async {
    try {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      await locationProvider.initLocation(userId.toString());
    } catch (e) {
      debugPrint('Location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Removed popup; navigation goes directly to OrderPickupScreen
  _onAcceptOrderTap(String? currentOrderStatus) {
    final status = (currentOrderStatus ?? '').trim();
    print(
      "kgdjksafjsfsjhfjdsfhlsdfhslfhjlfhdsfhsdfflkjflfhj$currentOrderStatus",
    );
    if (status == 'Rider Accepted') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrderPickupScreen()),
      );
      return;
    }

    if (status == 'Picked') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrderDeliveredScreen()),
      );
      return;
    }

    // For "Pending", empty, null or any other status -> show toast
    try {
      // use your existing GlobalToast if available
      GlobalToast.showInfo('No Orders Found');
    } catch (_) {
      // fallback to ScaffoldMessenger if GlobalToast isn't in scope
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Orders Found'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  String _getDisplayAddress(String address) {
    if (address.trim().isEmpty) {
      return "Set location";
    }

    String cleanAddress = address.trim();
    List<String> parts = cleanAddress.split(',');

    for (String part in parts) {
      String trimmed = part.trim();

      // Skip if starts with number or symbol
      if (trimmed.isEmpty || !RegExp(r'^[a-zA-Z]').hasMatch(trimmed)) {
        continue;
      }

      // Skip irrelevant parts
      final lower = trimmed.toLowerCase();
      if (lower.contains('plot') ||
          lower.contains('door') ||
          lower.contains('building') ||
          lower.contains('floor')) {
        continue;
      }

      // Return the first valid part without length limit for main title
      return trimmed;
    }

    // Fallback: show first part that starts with letter
    for (String part in parts) {
      String trimmed = part.trim();
      if (trimmed.isNotEmpty && RegExp(r'^[a-zA-Z]').hasMatch(trimmed)) {
        return trimmed;
      }
    }

    return "Location";
  }

  Widget _buildLocationWidget() {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        final address = provider.address ?? '';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.telegram_sharp, size: 24, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (provider.isLoading)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: const Color(0xFF120698),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _getDisplayAddress(address),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // const SizedBox(width: 4),
                            // Icon(
                            //   Icons.keyboard_arrow_down,
                            //   size: 20,
                            //   color: Colors.black,
                            // ),
                          ],
                        ),
                        Text(
                          address.isNotEmpty ? address : "Set location",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (userId.isNotEmpty) {
              final dashboardProv = Provider.of<DashboardProvider>(
                context,
                listen: false,
              );
              await dashboardProv.refreshDashboard(userId);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: avatar + location + actions
                  Row(
                    children: [
                      Consumer<ProfileProvider>(
                        builder: (context, provider, _) {
                          final profile = provider.profile;
                          final String? imageUrl = profile?.profileImage;

                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                                  (imageUrl != null && imageUrl.isNotEmpty)
                                  ? NetworkImage(imageUrl) as ImageProvider
                                  : const AssetImage('assets/home.png'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildLocationWidget(
                        ),
                      ),
                      const SizedBox(width: 8),
                      OnlineOfflineButton(),
                      const SizedBox(width: 12),
                      // Stack(
                      //   children: [
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.shade100,
                      //         shape: BoxShape.circle,
                      //       ),
                      //       child: const Icon(
                      //         Icons.notifications_outlined,
                      //         size: 24,
                      //       ),
                      //     ),
                      //     Positioned(
                      //       right: 8,
                      //       top: 8,
                      //       child: Container(
                      //         width: 8,
                      //         height: 8,
                      //         decoration: const BoxDecoration(
                      //           color: Colors.red,
                      //           shape: BoxShape.circle,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildTodayOrdersCard(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildCancelledCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildCompletedCard()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildUpdateOrderCard(), // now navigates directly to OrderPickupScreen
                  const SizedBox(height: 20),
                  _buildEarningsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayOrdersCard() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final count = provider.data?.todayOrdersCount ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Today Orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              provider.isLoading
                  ? const SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    )
                  : Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCancelledCard() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final count = provider.data?.cancelledOrdersCount ?? 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFFCE4EC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Cancelled',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              provider.isLoading
                  ? const SizedBox(
                      height: 36,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    )
                  : Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompletedCard() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final count = provider.data?.completedOrdersCount ?? 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              provider.isLoading
                  ? const SizedBox(
                      height: 36,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    )
                  : Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpdateOrderCard() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final currentOrderStatus = provider.data?.currentOrderStatus ?? '';
        return GestureDetector(
          onTap: () => _onAcceptOrderTap(currentOrderStatus),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: const Color(0xFFF2F8F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Order Details!',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// 🔥 Dynamic message based on currentOrderStatus
                      Builder(
                        builder: (_) {
                          final status = (currentOrderStatus ?? '')
                              .trim(); // ensure safe

                          String message;

                          if (status == 'Rider Accepted') {
                            message =
                                'Hi Manoj Kumar, You have an accepted order.';
                          } else if (status == 'Picked') {
                            message = 'You have a picked order.';
                          } else {
                            message = 'You have no orders.';
                          }

                          return Text(
                            message,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.double_arrow_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarningsSection() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Earnings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // GestureDetector(
                //   onTap: () => _showFilterMenu(context),
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 12,
                //       vertical: 6,
                //     ),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey.shade300),
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Text(
                //           _getFilterLabel(provider.filter),
                //           style: const TextStyle(
                //             fontSize: 13,
                //             color: Colors.black87,
                //           ),
                //         ),
                //         const SizedBox(width: 4),
                //         Icon(
                //           Icons.keyboard_arrow_down,
                //           size: 18,
                //           color: Colors.grey.shade700,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEarningsChart(),
          ],
        );
      },
    );
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'today':
        return 'Today';
      case 'thisweek':
        return 'This Week';
      case 'thismonth':
        return 'This Month';
      default:
        return 'This Week';
    }
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Period',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterOption('Today', 'today', provider),
                  _buildFilterOption('This Week', 'thisweek', provider),
                  _buildFilterOption('This Month', 'thismonth', provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(
    String label,
    String value,
    DashboardProvider provider,
  ) {
    final isSelected = provider.filter == value;
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF4CAF50))
          : null,
      onTap: () {
        Navigator.pop(context);
        if (userId.isNotEmpty) {
          provider.changeFilter(userId, value);
        }
      },
    );
  }

  Widget _buildEarningsChart() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            ),
          );
        }

        final dailyEarnings = provider.data?.dailyEarnings ?? [];

        // Create chart spots from daily earnings
        final spots = <FlSpot>[];
        final bottomTitles = <String>[];
        double maxY = 40.0;

        for (int i = 0; i < dailyEarnings.length; i++) {
          final earning = dailyEarnings[i];
          spots.add(FlSpot(i.toDouble(), earning.earnings));
          bottomTitles.add(earning.day);

          // Update maxY if needed
          if (earning.earnings > maxY) {
            maxY = (earning.earnings * 1.2).ceilToDouble();
          }
        }

        // If no data, show default chart
        if (spots.isEmpty) {
          return _buildDefaultChart();
        }

        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8F4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxY / 4,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < bottomTitles.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            bottomTitles[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (spots.length - 1).toDouble(),
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF4CAF50)],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50).withOpacity(0.1),
                        const Color(0xFF4CAF50).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thur',
                    'Fri',
                    'Sat',
                    'Sun',
                    'Mon',
                  ];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[value.toInt()],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 7,
          minY: 0,
          maxY: 40,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 15),
                FlSpot(1, 20),
                FlSpot(2, 35),
                FlSpot(3, 15),
                FlSpot(4, 25),
                FlSpot(5, 30),
                FlSpot(6, 25),
                FlSpot(7, 28),
              ],
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF4CAF50)],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.1),
                    const Color(0xFF4CAF50).withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
