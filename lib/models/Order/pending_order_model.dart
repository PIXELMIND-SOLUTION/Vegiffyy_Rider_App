class PendingOrder {
  final String id;
  final String orderId; // if you want the nested order id, adjust accordingly
  final String restaurantName;
  final String deliveryAddress;
  final double totalPayable;
  final String createdAt;
  // keep original map for dialog details
  final Map<String, dynamic> raw;

  PendingOrder({
    required this.id,
    required this.orderId,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.totalPayable,
    required this.createdAt,
    required this.raw,
  });

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    // Your sample shows top-level _id for order
    final id = json['_id']?.toString() ?? '';
    final restaurant = json['restaurantId'] as Map<String, dynamic>?;
    final restaurantName = restaurant != null ? (restaurant['restaurantName']?.toString() ?? '') : '';
    final addr = json['deliveryAddress'] as Map<String, dynamic>?;
    final addressStr = addr != null ? (addr['street']?.toString() ?? '') : '';
    final total = (json['totalPayable'] is num) ? (json['totalPayable'] as num).toDouble() : 0.0;
    final createdAt = json['createdAt']?.toString() ?? '';

    return PendingOrder(
      id: id,
      orderId: id,
      restaurantName: restaurantName,
      deliveryAddress: addressStr,
      totalPayable: total,
      createdAt: createdAt,
      raw: json,
    );
  }

  Map<String, dynamic> toMap() => raw;
}
