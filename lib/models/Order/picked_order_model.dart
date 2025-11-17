// lib/models/Order/picked_order_model.dart
class PickedOrderProduct {
  final String id;
  final String name;
  final int quantity;
  final double basePrice;
  final String? image;
  final Map<String, dynamic>? addOn;

  PickedOrderProduct({
    required this.id,
    required this.name,
    required this.quantity,
    required this.basePrice,
    this.image,
    this.addOn,
  });

  factory PickedOrderProduct.fromJson(Map<String, dynamic> json) {
    return PickedOrderProduct(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] is num) 
        ? (json['quantity'] as num).toInt() 
        : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      basePrice: (json['basePrice'] is num) 
        ? (json['basePrice'] as num).toDouble() 
        : double.tryParse(json['basePrice']?.toString() ?? '0') ?? 0.0,
      image: json['image']?.toString(),
      addOn: json['addOn'] is Map ? json['addOn'] as Map<String, dynamic> : null,
    );
  }
}

class PickedOrderModel {
  final String id;
  final String? deliveryAddress;
  final int totalItems;
  final double totalPayable;
  final double subTotal;
  final double deliveryCharge;
  final double couponDiscount;
  final List<PickedOrderProduct> products;
  final String orderStatus;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryStatus;
  final Map<String, dynamic>? restaurant;
  final Map<String, dynamic>? deliveryBoy;
  final Map<String, dynamic>? userId;
  final String? cartId;
  final double distanceKm;
  final String? createdAt;
  final String? updatedAt;
  final String? acceptedAt;

  PickedOrderModel({
    required this.id,
    this.deliveryAddress,
    required this.totalItems,
    required this.totalPayable,
    required this.subTotal,
    required this.deliveryCharge,
    required this.couponDiscount,
    required this.products,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryStatus,
    this.restaurant,
    this.deliveryBoy,
    this.userId,
    this.cartId,
    required this.distanceKm,
    this.createdAt,
    this.updatedAt,
    this.acceptedAt,
  });

  factory PickedOrderModel.fromJson(Map<String, dynamic> json) {
    final deliveryAddressObj = json['deliveryAddress'];
    String addressString = '';
    
    if (deliveryAddressObj is Map) {
      final street = deliveryAddressObj['street']?.toString() ?? '';
      final city = deliveryAddressObj['city']?.toString() ?? '';
      final state = deliveryAddressObj['state']?.toString() ?? '';
      final postalCode = deliveryAddressObj['postalCode']?.toString() ?? '';
      
      addressString = [street, city, state, postalCode]
        .where((s) => s.isNotEmpty)
        .join(', ');
    }

    final productsJson = json['products'] as List<dynamic>? ?? [];
    final products = productsJson
      .map((p) => PickedOrderProduct.fromJson(p as Map<String, dynamic>))
      .toList();

    return PickedOrderModel(
      id: json['_id']?.toString() ?? '',
      deliveryAddress: addressString.isNotEmpty ? addressString : null,
      totalItems: (json['totalItems'] is num) 
        ? (json['totalItems'] as num).toInt() 
        : int.tryParse(json['totalItems']?.toString() ?? '0') ?? 0,
      totalPayable: _parseDouble(json['totalPayable']),
      subTotal: _parseDouble(json['subTotal']),
      deliveryCharge: _parseDouble(json['deliveryCharge']),
      couponDiscount: _parseDouble(json['couponDiscount']),
      products: products,
      orderStatus: json['orderStatus']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      deliveryStatus: json['deliveryStatus']?.toString() ?? '',
      restaurant: json['restaurantId'] is Map 
        ? (json['restaurantId'] as Map<String, dynamic>) 
        : null,
      deliveryBoy: json['deliveryBoyId'] is Map 
        ? (json['deliveryBoyId'] as Map<String, dynamic>) 
        : null,
      userId: json['userId'] is Map 
        ? (json['userId'] as Map<String, dynamic>) 
        : null,
      cartId: json['cartId']?.toString(),
      distanceKm: _parseDouble(json['distanceKm']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      acceptedAt: json['acceptedAt']?.toString(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value != null) return double.tryParse(value.toString()) ?? 0.0;
    return 0.0;
  }
  
  // Helper getters
  String get restaurantName => restaurant?['restaurantName']?.toString() ?? 'Restaurant';
  String get restaurantLocation => restaurant?['locationName']?.toString() ?? '';
  String get deliveryBoyName => deliveryBoy?['fullName']?.toString() ?? 'Delivery Person';
  String get deliveryBoyPhone => deliveryBoy?['mobileNumber']?.toString() ?? '';
  String get customerEmail => userId?['email']?.toString() ?? '';
  
  bool get isPaidOnline => paymentMethod.toUpperCase() != 'COD';
  bool get isCOD => paymentMethod.toUpperCase() == 'COD';
}