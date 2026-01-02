

// // lib/views/order_history/order_history_screen.dart
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:veggify_delivery_app/utils/session_manager.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});

//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   bool _loading = true;
//   String? _error;
//   List<DeliveredOrder> _orders = [];
//   // track which cards are expanded
//   final List<bool> _expanded = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchDeliveredOrders();
//   }

// Future<void> _fetchDeliveredOrders() async {
//   setState(() {
//     _loading = true;
//     _error = null;
//   });

//   try {
//     final userId = await SessionManager.getUserId();
//     if (userId == null || userId.trim().isEmpty) {
//       setState(() {
//         _orders = [];
//         _expanded.clear();
//         _loading = false;
//       });
//       return;
//     }

//     final uri = Uri.parse(
//         'http://31.97.206.144:5051/api/mydeliveredorders/$userId');
//     final resp = await http.get(uri);

//     // 🔥 If API returns 404 -> treat as "No History Found"
//     if (resp.statusCode == 404) {
//       setState(() {
//         _orders = [];
//         // _expanded = [];
//         _loading = false;
//         // _error remains null so UI shows empty state
//       });
//       return;
//     }

//     // ❌ Any other non-2xx errors should show retry UI
//     if (resp.statusCode < 200 || resp.statusCode >= 300) {
//       setState(() {
//         _error = "Server error: ${resp.statusCode}";
//         _loading = false;
//       });
//       return;
//     }

//     // Parse body safely
//     final body = json.decode(resp.body);

//     final rawData =
//         (body is Map && body.containsKey('data')) ? body['data'] : body;

//     final listData = (rawData is List) ? rawData : [];

//     final parsed = listData.map((e) {
//       if (e is Map<String, dynamic>) return DeliveredOrder.fromJson(e);
//       return null;
//     }).whereType<DeliveredOrder>().toList();

//     setState(() {
//       _orders = parsed;
//       // _expanded = List<bool>.filled(_orders.length, false);
//       _loading = false;
//     });
//   } catch (e) {
//     // network / JSON parse error -> show retry
//     setState(() {
//       _error = e.toString();
//       _loading = false;
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Order History',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Error: $_error', style: const TextStyle(color: Colors.red)),
//                         const SizedBox(height: 12),
//                         ElevatedButton(onPressed: _fetchDeliveredOrders, child: const Text('Retry'))
//                       ],
//                     ),
//                   ),
//                 )
//               : _orders.isEmpty
//                   ? Center(child: Text('No delivered orders found', style: TextStyle(color: Colors.grey[700])))
//                   : ListView.separated(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _orders.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 16),
//                       itemBuilder: (context, idx) {
//                         final o = _orders[idx];
//                         final expanded = _expanded.length > idx ? _expanded[idx] : false;
//                         return _buildOrderCard(
//                           restaurant: o.restaurantName ?? '—',
//                           restaurantTime: '', // not shown per request
//                           address: o.deliveryAddress ?? '—',
//                           addressTime: '', // not shown
//                           earned: '₹${o.totalPayable.toStringAsFixed(2)}', // using totalPayable as earned
//                           isExpanded: expanded,
//                           items: o.products
//                               .map((p) => OrderItem(name: p.name, quantity: p.quantity, image: p.image ?? 'assets/biriyani.png'))
//                               .toList(),
//                           onTapExpand: () {
//                             setState(() {
//                               if (_expanded.length <= idx) {
//                                 // ensure length
//                                 _expanded.length = idx + 1;
//                               }
//                               _expanded[idx] = !(_expanded[idx]);
//                             });
//                           },
//                         );
//                       },
//                     ),
//     );
//   }

//   Widget _buildOrderCard({
//     required String restaurant,
//     required String restaurantTime,
//     required String address,
//     required String addressTime,
//     required String earned,
//     required bool isExpanded,
//     List<OrderItem>? items,
//     VoidCallback? onTapExpand,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color.fromARGB(255, 197, 196, 196)),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Restaurant info
//                 Row(
//                   children: [
//                     Container(
//                       width: 12,
//                       height: 12,
//                       decoration: const BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             restaurant,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           // restaurantTime intentionally not shown (you asked don't show time)
//                           const SizedBox.shrink(),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Order amount',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           Text(
//                             earned,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Dotted line (keeps same visual marker)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
//                   child: Row(
//                     children: [
//                       Column(
//                         children: List.generate(
//                           3,
//                           (index) => Container(
//                             width: 2,
//                             height: 4,
//                             margin: const EdgeInsets.symmetric(vertical: 2),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(1),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                     ],
//                   ),
//                 ),

//                 // Delivery address
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.location_on_outlined,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             address,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           // addressTime intentionally not shown
//                           const SizedBox.shrink(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Expandable section
//           if (isExpanded && items != null) ...[
//             const Divider(height: 1),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: items.map((item) => _buildOrderItem(item)).toList(),
//               ),
//             ),
//           ],

//           // Expand/Collapse button
//           InkWell(
//             onTap: onTapExpand ?? () {},
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: Icon(
//                 isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(OrderItem item) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.asset(
//               item.image,
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 60,
//                   height: 60,
//                   color: Colors.grey[300],
//                   child: Icon(Icons.restaurant, color: Colors.grey[400]),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Qty: ${item.quantity} Full',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.green, width: 2),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.circle,
//                 size: 8,
//                 color: Colors.green,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderItem {
//   final String name;
//   final int quantity;
//   final String image;

//   OrderItem({
//     required this.name,
//     required this.quantity,
//     required this.image,
//   });
// }

// /// Simple model classes to parse the delivered orders response.
// class DeliveredOrder {
//   final String id;
//   final String? restaurantName;
//   final String? deliveryAddress;
//   final int totalItems;
//   final double totalPayable;
//   final List<DeliveredOrderItem> products;

//   DeliveredOrder({
//     required this.id,
//     this.restaurantName,
//     this.deliveryAddress,
//     required this.totalItems,
//     required this.totalPayable,
//     required this.products,
//   });

//   factory DeliveredOrder.fromJson(Map<String, dynamic> json) {
//     final rest = json['restaurantId'];
//     String? restaurantName;
//     if (rest is Map<String, dynamic>) {
//       restaurantName = (rest['restaurantName'] ?? rest['name'])?.toString();
//     }

//     String? addressStr;
//     final addr = json['deliveryAddress'];
//     if (addr is Map<String, dynamic>) {
//       addressStr = (addr['street'] ?? '').toString();
//       // optionally append city/state if you want: + ', ' + (addr['city'] ?? '')
//     }

//     final productsJson = (json['products'] as List<dynamic>?) ?? [];
//     final products = productsJson.map((p) => DeliveredOrderItem.fromJson(p as Map<String, dynamic>)).toList();

//     double totalPayable = 0.0;
//     final t = json['totalPayable'];
//     if (t is num) totalPayable = t.toDouble();
//     else if (t != null) totalPayable = double.tryParse(t.toString()) ?? 0.0;

//     int totalItems = 0;
//     final ti = json['totalItems'];
//     if (ti is num) totalItems = ti.toInt();
//     else if (ti != null) totalItems = int.tryParse(ti.toString()) ?? products.length;

//     return DeliveredOrder(
//       id: json['_id']?.toString() ?? '',
//       restaurantName: restaurantName,
//       deliveryAddress: addressStr,
//       totalItems: totalItems,
//       totalPayable: totalPayable,
//       products: products,
//     );
//   }
// }

// class DeliveredOrderItem {
//   final String id;
//   final String name;
//   final int quantity;
//   final String? image;

//   DeliveredOrderItem({
//     required this.id,
//     required this.name,
//     required this.quantity,
//     this.image,
//   });

//   factory DeliveredOrderItem.fromJson(Map<String, dynamic> json) {
//     return DeliveredOrderItem(
//       id: json['_id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       quantity: (json['quantity'] is num) ? (json['quantity'] as num).toInt() : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       image: json['image']?.toString(),
//     );
//   }
// }






















// lib/views/order_history/order_history_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';

enum OrderDateFilter {
  all,
  today,
  thisWeek,
  thisMonth,
  custom,
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _loading = true;
  String? _error;

  /// Full list from API
  List<DeliveredOrder> _allOrders = [];

  /// Filtered list shown in UI
  List<DeliveredOrder> _orders = [];

  /// Track which cards are expanded (same length as _orders)
  final List<bool> _expanded = [];

  /// Current filter
  OrderDateFilter _selectedFilter = OrderDateFilter.all;

  /// For custom range
  DateTime? _customFrom;
  DateTime? _customTo;

  @override
  void initState() {
    super.initState();
    _fetchDeliveredOrders();
  }

  Future<void> _fetchDeliveredOrders() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userId = await SessionManager.getUserId();
      if (userId == null || userId.trim().isEmpty) {
        setState(() {
          _allOrders = [];
          _orders = [];
          _expanded.clear();
          _loading = false;
        });
        return;
      }

      final uri = Uri.parse(
        'http://31.97.206.144:5051/api/mydeliveredorders/$userId',
      );
      final resp = await http.get(uri);

      // 404 => no history
      if (resp.statusCode == 404) {
        setState(() {
          _allOrders = [];
          _orders = [];
          _expanded.clear();
          _loading = false;
        });
        return;
      }

      // other non-2xx => show error
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        setState(() {
          _error = "Server error: ${resp.statusCode}";
          _loading = false;
        });
        return;
      }

      final body = json.decode(resp.body);

      final rawData =
          (body is Map && body.containsKey('data')) ? body['data'] : body;

      final listData = (rawData is List) ? rawData : [];

      final parsed = listData
          .map((e) {
            if (e is Map<String, dynamic>) {
              return DeliveredOrder.fromJson(e);
            }
            return null;
          })
          .whereType<DeliveredOrder>()
          .toList();

      setState(() {
        _allOrders = parsed;
        // apply current filter (initially "all")
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Apply the current date filter to _allOrders → set _orders
  void _applyFilter() {
    final now = DateTime.now();
    List<DeliveredOrder> filtered;

    switch (_selectedFilter) {
      case OrderDateFilter.all:
        filtered = List.from(_allOrders);
        break;

      case OrderDateFilter.today:
        filtered = _allOrders.where((o) {
          final d = o.createdAt.toLocal();
          return d.year == now.year &&
              d.month == now.month &&
              d.day == now.day;
        }).toList();
        break;

      case OrderDateFilter.thisWeek:
        // last 7 days including today
        filtered = _allOrders.where((o) {
          final d = o.createdAt.toLocal();
          final diff = now.difference(d).inDays;
          return diff >= 0 && diff < 7;
        }).toList();
        break;

      case OrderDateFilter.thisMonth:
        filtered = _allOrders.where((o) {
          final d = o.createdAt.toLocal();
          return d.year == now.year && d.month == now.month;
        }).toList();
        break;

      case OrderDateFilter.custom:
        if (_customFrom == null || _customTo == null) {
          // If no range set yet, just show all
          filtered = List.from(_allOrders);
        } else {
          final from = DateTime(
            _customFrom!.year,
            _customFrom!.month,
            _customFrom!.day,
          );
          final to = DateTime(
            _customTo!.year,
            _customTo!.month,
            _customTo!.day,
            23,
            59,
            59,
          );
          filtered = _allOrders.where((o) {
            final d = o.createdAt.toLocal();
            return !d.isBefore(from) && !d.isAfter(to);
          }).toList();
        }
        break;
    }

    _orders = filtered;
    _expanded
      ..clear()
      ..addAll(List<bool>.filled(_orders.length, false));
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);
    final lastDate = DateTime(now.year + 1);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: _customFrom != null && _customTo != null
          ? DateTimeRange(start: _customFrom!, end: _customTo!)
          : DateTimeRange(
              start: now.subtract(const Duration(days: 7)),
              end: now,
            ),
    );

    if (picked != null) {
      setState(() {
        _customFrom = picked.start;
        _customTo = picked.end;
        _selectedFilter = OrderDateFilter.custom;
        _applyFilter();
      });
    }
  }

  String _formatOrderDate(DateTime date) {
    final local = date.toLocal();
    return DateFormat('dd MMM yyyy, hh:mm a').format(local);
  }

  Widget _buildFilterChip({
    required String label,
    required OrderDateFilter filter,
    bool isCustom = false,
  }) {
    final selected = _selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (value) async {
          if (!value) return;

          if (isCustom) {
            await _pickCustomDateRange();
          } else {
            setState(() {
              _selectedFilter = filter;
              _applyFilter();
            });
          }
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(label: 'All', filter: OrderDateFilter.all),
          _buildFilterChip(label: 'Today', filter: OrderDateFilter.today),
          _buildFilterChip(label: 'This Week', filter: OrderDateFilter.thisWeek),
          _buildFilterChip(label: 'This Month', filter: OrderDateFilter.thisMonth),
          _buildFilterChip(
            label: _selectedFilter == OrderDateFilter.custom &&
                    _customFrom != null &&
                    _customTo != null
                ? '${DateFormat('dd/MM').format(_customFrom!)} - ${DateFormat('dd/MM').format(_customTo!)}'
                : 'Custom',
            filter: OrderDateFilter.custom,
            isCustom: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Error: $_error',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchDeliveredOrders,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Filter bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _buildFilterBar(),
                    ),
                    const SizedBox(height: 8),

                    // List or empty state
                    Expanded(
                      child: _orders.isEmpty
                          ? Center(
                              child: Text(
                                'No delivered orders found',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _orders.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, idx) {
                                final o = _orders[idx];
                                final expanded = _expanded[idx];

                                final items = o.products
                                    .map(
                                      (p) => OrderItem(
                                        name: p.name,
                                        quantity: p.quantity,
                                        image: p.image ?? '',
                                      ),
                                    )
                                    .toList();

                                return _buildOrderCard(
                                  restaurant: o.restaurantName ?? '—',
                                  restaurantTime: _formatOrderDate(o.createdAt),
                                  address: o.deliveryAddress ?? '—',
                                  earned:
                                      '₹${o.totalPayable.toStringAsFixed(2)}',
                                  isExpanded: expanded,
                                  items: items,
                                  onTapExpand: () {
                                    setState(() {
                                      _expanded[idx] = !expanded;
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildOrderCard({
    required String restaurant,
    required String restaurantTime,
    required String address,
    required String earned,
    required bool isExpanded,
    List<OrderItem>? items,
    VoidCallback? onTapExpand,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(color: const Color.fromARGB(255, 197, 196, 196)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Restaurant info
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (restaurantTime.isNotEmpty)
                            Text(
                              restaurantTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Order amount',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            earned,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Dotted line
                Padding(
                  padding:
                      const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Column(
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 2,
                            height: 4,
                            margin:
                                const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                // Delivery address
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expanded details: items list
          if (isExpanded && items != null && items.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children:
                    items.map((item) => _buildOrderItem(item)).toList(),
              ),
            ),
          ],

          // Expand/Collapse button
          InkWell(
            onTap: onTapExpand ?? () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    Widget imageWidget;

    if (item.image.isEmpty) {
      imageWidget = Container(
        width: 60,
        height: 60,
        color: Colors.grey[300],
        child: Icon(Icons.restaurant, color: Colors.grey[400]),
      );
    } else if (item.image.startsWith('http')) {
      imageWidget = Image.network(
        item.image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: Icon(Icons.restaurant, color: Colors.grey[400]),
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        item.image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: Icon(Icons.restaurant, color: Colors.grey[400]),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity} Full',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Icon(
                Icons.circle,
                size: 8,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final String image;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.image,
  });
}

/// Model class to parse delivered orders response.
class DeliveredOrder {
  final String id;
  final String? restaurantName;
  final String? deliveryAddress;
  final int totalItems;
  final double totalPayable;
  final DateTime createdAt;
  final List<DeliveredOrderItem> products;

  DeliveredOrder({
    required this.id,
    this.restaurantName,
    this.deliveryAddress,
    required this.totalItems,
    required this.totalPayable,
    required this.createdAt,
    required this.products,
  });

  factory DeliveredOrder.fromJson(Map<String, dynamic> json) {
    final rest = json['restaurantId'];
    String? restaurantName;
    if (rest is Map<String, dynamic>) {
      restaurantName = (rest['restaurantName'] ?? rest['name'])?.toString();
    }

    String? addressStr;
    final addr = json['deliveryAddress'];
    if (addr is Map<String, dynamic>) {
      addressStr = (addr['street'] ?? '').toString();
    }

    final productsJson = (json['products'] as List<dynamic>?) ?? [];
    final products = productsJson
        .map((p) => DeliveredOrderItem.fromJson(p as Map<String, dynamic>))
        .toList();

    double totalPayable = 0.0;
    final t = json['totalPayable'];
    if (t is num) {
      totalPayable = t.toDouble();
    } else if (t != null) {
      totalPayable = double.tryParse(t.toString()) ?? 0.0;
    }

    int totalItems = 0;
    final ti = json['totalItems'];
    if (ti is num) {
      totalItems = ti.toInt();
    } else if (ti != null) {
      totalItems = int.tryParse(ti.toString()) ?? products.length;
    }

    DateTime createdAt;
    final c = json['createdAt'];
    if (c is String) {
      createdAt = DateTime.tryParse(c) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return DeliveredOrder(
      id: json['_id']?.toString() ?? '',
      restaurantName: restaurantName,
      deliveryAddress: addressStr,
      totalItems: totalItems,
      totalPayable: totalPayable,
      createdAt: createdAt,
      products: products,
    );
  }
}

class DeliveredOrderItem {
  final String id;
  final String name;
  final int quantity;
  final String? image;

  DeliveredOrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.image,
  });

  factory DeliveredOrderItem.fromJson(Map<String, dynamic> json) {
    return DeliveredOrderItem(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt()
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      image: json['image']?.toString(),
    );
  }
}
