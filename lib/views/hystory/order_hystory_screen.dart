// import 'package:flutter/material.dart';

// class OrderHistoryScreen extends StatelessWidget {
//   const OrderHistoryScreen({super.key});

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
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildOrderCard(
//             restaurant: 'Dosa Plaza',
//             restaurantTime: 'Dosa Plaza · 13:00 PM',
//             address: 'Temple street, kakinada',
//             addressTime: 'Home · 13:30 PM',
//             earned: '₹50',
//             isExpanded: false,
//           ),
//           const SizedBox(height: 16),
//           _buildOrderCard(
//             restaurant: 'Dosa Plaza',
//             restaurantTime: 'Dosa Plaza · 13:00 PM',
//             address: 'Temple street, kakinada',
//             addressTime: 'Home · 13:30 PM',
//             earned: '₹50',
//             isExpanded: true,
//             items: [
//               OrderItem(
//                 name: 'Veg panner fried rice',
//                 quantity: 1,
//                 image: 'assets/biriyani.png',
//               ),
//               OrderItem(
//                 name: 'Veg panner fried rice',
//                 quantity: 1,
//                 image: 'assets/biriyani.png',
//               ),
//             ],
//           ),
//         ],
//       ),
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
//                           Text(
//                             restaurantTime,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
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
//                             'Earned',
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
                
//                 // Dotted line
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
//                           Text(
//                             addressTime,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
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
//             onTap: () {},
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























// lib/views/order_history/order_history_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:veggify_delivery_app/utils/session_manager.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _loading = true;
  String? _error;
  List<DeliveredOrder> _orders = [];
  // track which cards are expanded
  final List<bool> _expanded = [];

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
        _orders = [];
        _expanded.clear();
        _loading = false;
      });
      return;
    }

    final uri = Uri.parse(
        'http://31.97.206.144:5051/api/mydeliveredorders/$userId');
    final resp = await http.get(uri);

    // 🔥 If API returns 404 -> treat as "No History Found"
    if (resp.statusCode == 404) {
      setState(() {
        _orders = [];
        // _expanded = [];
        _loading = false;
        // _error remains null so UI shows empty state
      });
      return;
    }

    // ❌ Any other non-2xx errors should show retry UI
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      setState(() {
        _error = "Server error: ${resp.statusCode}";
        _loading = false;
      });
      return;
    }

    // Parse body safely
    final body = json.decode(resp.body);

    final rawData =
        (body is Map && body.containsKey('data')) ? body['data'] : body;

    final listData = (rawData is List) ? rawData : [];

    final parsed = listData.map((e) {
      if (e is Map<String, dynamic>) return DeliveredOrder.fromJson(e);
      return null;
    }).whereType<DeliveredOrder>().toList();

    setState(() {
      _orders = parsed;
      // _expanded = List<bool>.filled(_orders.length, false);
      _loading = false;
    });
  } catch (e) {
    // network / JSON parse error -> show retry
    setState(() {
      _error = e.toString();
      _loading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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
                        Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _fetchDeliveredOrders, child: const Text('Retry'))
                      ],
                    ),
                  ),
                )
              : _orders.isEmpty
                  ? Center(child: Text('No delivered orders found', style: TextStyle(color: Colors.grey[700])))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        final o = _orders[idx];
                        final expanded = _expanded.length > idx ? _expanded[idx] : false;
                        return _buildOrderCard(
                          restaurant: o.restaurantName ?? '—',
                          restaurantTime: '', // not shown per request
                          address: o.deliveryAddress ?? '—',
                          addressTime: '', // not shown
                          earned: '₹${o.totalPayable.toStringAsFixed(2)}', // using totalPayable as earned
                          isExpanded: expanded,
                          items: o.products
                              .map((p) => OrderItem(name: p.name, quantity: p.quantity, image: p.image ?? 'assets/biriyani.png'))
                              .toList(),
                          onTapExpand: () {
                            setState(() {
                              if (_expanded.length <= idx) {
                                // ensure length
                                _expanded.length = idx + 1;
                              }
                              _expanded[idx] = !(_expanded[idx]);
                            });
                          },
                        );
                      },
                    ),
    );
  }

  Widget _buildOrderCard({
    required String restaurant,
    required String restaurantTime,
    required String address,
    required String addressTime,
    required String earned,
    required bool isExpanded,
    List<OrderItem>? items,
    VoidCallback? onTapExpand,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 197, 196, 196)),
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
                          // restaurantTime intentionally not shown (you asked don't show time)
                          const SizedBox.shrink(),
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
                            'Earned',
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

                // Dotted line (keeps same visual marker)
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Column(
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 2,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 2),
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
                          const SizedBox(height: 2),
                          // addressTime intentionally not shown
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expandable section
          if (isExpanded && items != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: items.map((item) => _buildOrderItem(item)).toList(),
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
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
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
            ),
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

/// Simple model classes to parse the delivered orders response.
class DeliveredOrder {
  final String id;
  final String? restaurantName;
  final String? deliveryAddress;
  final int totalItems;
  final double totalPayable;
  final List<DeliveredOrderItem> products;

  DeliveredOrder({
    required this.id,
    this.restaurantName,
    this.deliveryAddress,
    required this.totalItems,
    required this.totalPayable,
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
      // optionally append city/state if you want: + ', ' + (addr['city'] ?? '')
    }

    final productsJson = (json['products'] as List<dynamic>?) ?? [];
    final products = productsJson.map((p) => DeliveredOrderItem.fromJson(p as Map<String, dynamic>)).toList();

    double totalPayable = 0.0;
    final t = json['totalPayable'];
    if (t is num) totalPayable = t.toDouble();
    else if (t != null) totalPayable = double.tryParse(t.toString()) ?? 0.0;

    int totalItems = 0;
    final ti = json['totalItems'];
    if (ti is num) totalItems = ti.toInt();
    else if (ti != null) totalItems = int.tryParse(ti.toString()) ?? products.length;

    return DeliveredOrder(
      id: json['_id']?.toString() ?? '',
      restaurantName: restaurantName,
      deliveryAddress: addressStr,
      totalItems: totalItems,
      totalPayable: totalPayable,
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
      quantity: (json['quantity'] is num) ? (json['quantity'] as num).toInt() : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      image: json['image']?.toString(),
    );
  }
}
