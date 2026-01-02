// // lib/models/order/order_model.dart
// import 'dart:convert';

// class AcceptedOrderModel {
//   final String id;
//   final String name;
//   final int quantity;
//   final double basePrice;
//   final String? image;

//   AcceptedOrderModel({
//     required this.id,
//     required this.name,
//     required this.quantity,
//     required this.basePrice,
//     this.image,
//   });

//   factory AcceptedOrderModel.fromJson(Map<String, dynamic> json) {
//     return AcceptedOrderModel(
//       id: json['_id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       quantity: (json['quantity'] is int) ? json['quantity'] as int : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       basePrice: (json['basePrice'] is num) ? (json['basePrice'] as num).toDouble() : double.tryParse(json['basePrice']?.toString() ?? '0') ?? 0.0,
//       image: json['image']?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'name': name,
//         'quantity': quantity,
//         'basePrice': basePrice,
//         'image': image,
//       };
// }

// class OrderModel {
//   final String id;
//   final List<AcceptedOrderModel> products;
//   final int totalItems;
//   final double subTotal;
//   final double deliveryCharge;
//   final double totalPayable;
//   final String deliveryAddress;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String orderStatus;
//   final String? acceptedAt;

//   OrderModel({
//     required this.id,
//     required this.products,
//     required this.totalItems,
//     required this.subTotal,
//     required this.deliveryCharge,
//     required this.totalPayable,
//     required this.deliveryAddress,
//     this.createdAt,
//     this.updatedAt,
//     required this.orderStatus,
//     this.acceptedAt,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     final productsJson = (json['products'] as List<dynamic>?) ?? [];
//     final products = productsJson.map((e) => AcceptedOrderModel.fromJson(e as Map<String, dynamic>)).toList();

//     String deliveryAddress = '';
//     final da = json['deliveryAddress'];
//     if (da is Map<String, dynamic>) {
//       final street = (da['street'] ?? '').toString();
//       final city = (da['city'] ?? '').toString();
//       deliveryAddress = [street, city].where((s) => s.isNotEmpty).join(', ');
//     } else if (da is String) {
//       deliveryAddress = da;
//     }

//     return OrderModel(
//       id: json['_id']?.toString() ?? '',
//       products: products,
//       totalItems: (json['totalItems'] is int) ? json['totalItems'] as int : int.tryParse(json['totalItems']?.toString() ?? '0') ?? products.length,
//       subTotal: (json['subTotal'] is num) ? (json['subTotal'] as num).toDouble() : double.tryParse(json['subTotal']?.toString() ?? '0') ?? 0.0,
//       deliveryCharge: (json['deliveryCharge'] is num) ? (json['deliveryCharge'] as num).toDouble() : double.tryParse(json['deliveryCharge']?.toString() ?? '0') ?? 0.0,
//       totalPayable: (json['totalPayable'] is num) ? (json['totalPayable'] as num).toDouble() : double.tryParse(json['totalPayable']?.toString() ?? '0') ?? 0.0,
//       deliveryAddress: deliveryAddress,
//       createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
//       orderStatus: json['orderStatus']?.toString() ?? '',
//       acceptedAt: json['acceptedAt']?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'products': products.map((p) => p.toJson()).toList(),
//         'totalItems': totalItems,
//         'subTotal': subTotal,
//         'deliveryCharge': deliveryCharge,
//         'totalPayable': totalPayable,
//         'deliveryAddress': deliveryAddress,
//         'orderStatus': orderStatus,
//       };
// }














// lib/models/order/order_model.dart
import 'dart:convert';

class AcceptedOrderModel {
  final String id;
  final String name;
  final int quantity;
  final double basePrice;
  final String? image;

  AcceptedOrderModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.basePrice,
    this.image,
  });

  factory AcceptedOrderModel.fromJson(Map<String, dynamic> json) {
    // API sends `price`, your model calls it `basePrice`
    final dynamic priceRaw = json['basePrice'] ?? json['price'] ?? 0;

    double parsedPrice;
    if (priceRaw is num) {
      parsedPrice = priceRaw.toDouble();
    } else {
      parsedPrice = double.tryParse(priceRaw.toString()) ?? 0.0;
    }

    return AcceptedOrderModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] is int)
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      basePrice: parsedPrice,
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'quantity': quantity,
        'basePrice': basePrice,
        'image': image,
      };
}

// ---------- EXTRA MODELS FOR RESTAURANT + LOCATION ----------

class LocationPoint {
  final String? type;
  final List<double>? coordinates; // [lng, lat]

  LocationPoint({this.type, this.coordinates});

  factory LocationPoint.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LocationPoint(type: null, coordinates: []);
    return LocationPoint(
      type: json['type']?.toString(),
      coordinates: (json['coordinates'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}

class RestaurantInfo {
  final String id;
  final String restaurantName;
  final String locationName;

  RestaurantInfo({
    required this.id,
    required this.restaurantName,
    required this.locationName,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      id: json['_id']?.toString() ?? '',
      restaurantName: json['restaurantName']?.toString() ?? '',
      locationName: json['locationName']?.toString() ?? '',
    );
  }
}

class DeliveryAddressFull {
  final LocationPoint? location;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String addressType;

  DeliveryAddressFull({
    this.location,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.addressType,
  });

  factory DeliveryAddressFull.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DeliveryAddressFull(
        location: null,
        street: '',
        city: '',
        state: '',
        country: '',
        postalCode: '',
        addressType: '',
      );
    }

    return DeliveryAddressFull(
      location: LocationPoint.fromJson(json['location'] as Map<String, dynamic>?),
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      addressType: json['addressType']?.toString() ?? '',
    );
  }
}

// ---------- ORDER MODEL ----------

class OrderModel {
  final String id;
  final List<AcceptedOrderModel> products;
  final int totalItems;
  final double subTotal;
  final double deliveryCharge;
  final double totalPayable;

  /// Old string for UI (street, city)
  final String deliveryAddress;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String orderStatus;
  final String? acceptedAt;

  /// NEW: full objects from API
  final RestaurantInfo? restaurantInfo;
  final LocationPoint? restaurantLocation;
  final DeliveryAddressFull? deliveryAddressFull;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalItems,
    required this.subTotal,
    required this.deliveryCharge,
    required this.totalPayable,
    required this.deliveryAddress,
    this.createdAt,
    this.updatedAt,
    required this.orderStatus,
    this.acceptedAt,
    this.restaurantInfo,
    this.restaurantLocation,
    this.deliveryAddressFull,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productsJson = (json['products'] as List<dynamic>?) ?? [];
    final products = productsJson
        .map((e) => AcceptedOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Build simple deliveryAddress string for backward compatibility
    String deliveryAddress = '';
    final da = json['deliveryAddress'];
    if (da is Map<String, dynamic>) {
      final street = (da['street'] ?? '').toString();
      final city = (da['city'] ?? '').toString();
      deliveryAddress = [street, city].where((s) => s.isNotEmpty).join(', ');
    } else if (da is String) {
      deliveryAddress = da;
    }

    return OrderModel(
      id: json['_id']?.toString() ?? '',
      products: products,
      totalItems: (json['totalItems'] is int)
          ? json['totalItems'] as int
          : int.tryParse(json['totalItems']?.toString() ?? '0') ??
              products.length,
      subTotal: (json['subTotal'] is num)
          ? (json['subTotal'] as num).toDouble()
          : double.tryParse(json['subTotal']?.toString() ?? '0') ?? 0.0,
      deliveryCharge: (json['deliveryCharge'] is num)
          ? (json['deliveryCharge'] as num).toDouble()
          : double.tryParse(json['deliveryCharge']?.toString() ?? '0') ?? 0.0,
      totalPayable: (json['totalPayable'] is num)
          ? (json['totalPayable'] as num).toDouble()
          : double.tryParse(json['totalPayable']?.toString() ?? '0') ?? 0.0,
      deliveryAddress: deliveryAddress,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      orderStatus: json['orderStatus']?.toString() ?? '',
      acceptedAt: json['acceptedAt']?.toString(),

      // NEW mappings
      restaurantInfo: json['restaurantId'] != null
          ? RestaurantInfo.fromJson(json['restaurantId'] as Map<String, dynamic>)
          : null,
      restaurantLocation: json['restaurantLocation'] != null
          ? LocationPoint.fromJson(
              json['restaurantLocation'] as Map<String, dynamic>,
            )
          : null,
      deliveryAddressFull: json['deliveryAddress'] != null
          ? DeliveryAddressFull.fromJson(
              json['deliveryAddress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'products': products.map((p) => p.toJson()).toList(),
        'totalItems': totalItems,
        'subTotal': subTotal,
        'deliveryCharge': deliveryCharge,
        'totalPayable': totalPayable,
        'deliveryAddress': deliveryAddress,
        'orderStatus': orderStatus,
      };
}
