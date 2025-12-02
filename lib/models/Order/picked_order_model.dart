// // lib/models/Order/picked_order_model.dart
// class PickedOrderModelProduct {
//   final String id;
//   final String name;
//   final int quantity;
//   final double basePrice;
//   final String? image;
//   final Map<String, dynamic>? addOn;

//   PickedOrderModelProduct({
//     required this.id,
//     required this.name,
//     required this.quantity,
//     required this.basePrice,
//     this.image,
//     this.addOn,
//   });

//   factory PickedOrderModelProduct.fromJson(Map<String, dynamic> json) {
//     return PickedOrderModelProduct(
//       id: json['_id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       quantity: (json['quantity'] is num) 
//         ? (json['quantity'] as num).toInt() 
//         : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       basePrice: (json['basePrice'] is num) 
//         ? (json['basePrice'] as num).toDouble() 
//         : double.tryParse(json['basePrice']?.toString() ?? '0') ?? 0.0,
//       image: json['image']?.toString(),
//       addOn: json['addOn'] is Map ? json['addOn'] as Map<String, dynamic> : null,
//     );
//   }
// }

// class PickedOrderModelModel {
//   final String id;
//   final String? deliveryAddress;
//   final int totalItems;
//   final double totalPayable;
//   final double subTotal;
//   final double deliveryCharge;
//   final double couponDiscount;
//   final List<PickedOrderModelProduct> products;
//   final String orderStatus;
//   final String paymentMethod;
//   final String paymentStatus;
//   final String deliveryStatus;
//   final Map<String, dynamic>? restaurant;
//   final Map<String, dynamic>? deliveryBoy;
//   final Map<String, dynamic>? userId;
//   final String? cartId;
//   final double distanceKm;
//   final String? createdAt;
//   final String? updatedAt;
//   final String? acceptedAt;

//   PickedOrderModelModel({
//     required this.id,
//     this.deliveryAddress,
//     required this.totalItems,
//     required this.totalPayable,
//     required this.subTotal,
//     required this.deliveryCharge,
//     required this.couponDiscount,
//     required this.products,
//     required this.orderStatus,
//     required this.paymentMethod,
//     required this.paymentStatus,
//     required this.deliveryStatus,
//     this.restaurant,
//     this.deliveryBoy,
//     this.userId,
//     this.cartId,
//     required this.distanceKm,
//     this.createdAt,
//     this.updatedAt,
//     this.acceptedAt,
//   });

//   factory PickedOrderModelModel.fromJson(Map<String, dynamic> json) {
//     final deliveryAddressObj = json['deliveryAddress'];
//     String addressString = '';
    
//     if (deliveryAddressObj is Map) {
//       final street = deliveryAddressObj['street']?.toString() ?? '';
//       final city = deliveryAddressObj['city']?.toString() ?? '';
//       final state = deliveryAddressObj['state']?.toString() ?? '';
//       final postalCode = deliveryAddressObj['postalCode']?.toString() ?? '';
      
//       addressString = [street, city, state, postalCode]
//         .where((s) => s.isNotEmpty)
//         .join(', ');
//     }

//     final productsJson = json['products'] as List<dynamic>? ?? [];
//     final products = productsJson
//       .map((p) => PickedOrderModelProduct.fromJson(p as Map<String, dynamic>))
//       .toList();

//     return PickedOrderModelModel(
//       id: json['_id']?.toString() ?? '',
//       deliveryAddress: addressString.isNotEmpty ? addressString : null,
//       totalItems: (json['totalItems'] is num) 
//         ? (json['totalItems'] as num).toInt() 
//         : int.tryParse(json['totalItems']?.toString() ?? '0') ?? 0,
//       totalPayable: _parseDouble(json['totalPayable']),
//       subTotal: _parseDouble(json['subTotal']),
//       deliveryCharge: _parseDouble(json['deliveryCharge']),
//       couponDiscount: _parseDouble(json['couponDiscount']),
//       products: products,
//       orderStatus: json['orderStatus']?.toString() ?? '',
//       paymentMethod: json['paymentMethod']?.toString() ?? '',
//       paymentStatus: json['paymentStatus']?.toString() ?? '',
//       deliveryStatus: json['deliveryStatus']?.toString() ?? '',
//       restaurant: json['restaurantId'] is Map 
//         ? (json['restaurantId'] as Map<String, dynamic>) 
//         : null,
//       deliveryBoy: json['deliveryBoyId'] is Map 
//         ? (json['deliveryBoyId'] as Map<String, dynamic>) 
//         : null,
//       userId: json['userId'] is Map 
//         ? (json['userId'] as Map<String, dynamic>) 
//         : null,
//       cartId: json['cartId']?.toString(),
//       distanceKm: _parseDouble(json['distanceKm']),
//       createdAt: json['createdAt']?.toString(),
//       updatedAt: json['updatedAt']?.toString(),
//       acceptedAt: json['acceptedAt']?.toString(),
//     );
//   }

//   static double _parseDouble(dynamic value) {
//     if (value is num) return value.toDouble();
//     if (value != null) return double.tryParse(value.toString()) ?? 0.0;
//     return 0.0;
//   }
  
//   // Helper getters
//   String get restaurantName => restaurant?['restaurantName']?.toString() ?? 'Restaurant';
//   String get restaurantLocation => restaurant?['locationName']?.toString() ?? '';
//   String get deliveryBoyName => deliveryBoy?['fullName']?.toString() ?? 'Delivery Person';
//   String get deliveryBoyPhone => deliveryBoy?['mobileNumber']?.toString() ?? '';
//   String get customerEmail => userId?['email']?.toString() ?? '';
  
//   bool get isPaidOnline => paymentMethod.toUpperCase() != 'COD';
//   bool get isCOD => paymentMethod.toUpperCase() == 'COD';
// }





















// picked_orders_response.dart

class PickedOrderModelsResponse {
  final bool success;
  final String message;
  final List<PickedOrderModel> data;

  PickedOrderModelsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PickedOrderModelsResponse.fromJson(Map<String, dynamic> json) {
    return PickedOrderModelsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PickedOrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class PickedOrderModel {
  final GeoPoint? restaurantLocation;
  final String? id; // "_id"
  final UserRef? userId;
  final String? cartId;
  final RestaurantRef? restaurantId;
  final DeliveryAddress? deliveryAddress;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? orderStatus;
  final DeliveryBoy? deliveryBoyId;
  final String? deliveryStatus;
  final String? transactionId;
  final List<ProductItem> products;
  final int? totalItems;
  final num? subTotal;
  final num? deliveryCharge;
  final num? couponDiscount;
  final num? totalPayable;
  final num? distanceKm;
  final List<AvailableDeliveryBoy> availableDeliveryBoys;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final DateTime? acceptedAt;

  PickedOrderModel({
    this.restaurantLocation,
    this.id,
    this.userId,
    this.cartId,
    this.restaurantId,
    this.deliveryAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.orderStatus,
    this.deliveryBoyId,
    this.deliveryStatus,
    this.transactionId,
    this.products = const [],
    this.totalItems,
    this.subTotal,
    this.deliveryCharge,
    this.couponDiscount,
    this.totalPayable,
    this.distanceKm,
    this.availableDeliveryBoys = const [],
    this.createdAt,
    this.updatedAt,
    this.v,
    this.acceptedAt,
  });

  factory PickedOrderModel.fromJson(Map<String, dynamic> json) {
    return PickedOrderModel(
      restaurantLocation: json['restaurantLocation'] != null
          ? GeoPoint.fromJson(json['restaurantLocation'] as Map<String, dynamic>)
          : null,
      id: json['_id'] as String?,
      userId: json['userId'] != null
          ? UserRef.fromJson(json['userId'] as Map<String, dynamic>)
          : null,
      cartId: json['cartId'] as String?,
      restaurantId: json['restaurantId'] != null
          ? RestaurantRef.fromJson(
              json['restaurantId'] as Map<String, dynamic>,
            )
          : null,
      deliveryAddress: json['deliveryAddress'] != null
          ? DeliveryAddress.fromJson(
              json['deliveryAddress'] as Map<String, dynamic>,
            )
          : null,
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      orderStatus: json['orderStatus'] as String?,
      deliveryBoyId: json['deliveryBoyId'] != null
          ? DeliveryBoy.fromJson(
              json['deliveryBoyId'] as Map<String, dynamic>,
            )
          : null,
      deliveryStatus: json['deliveryStatus'] as String?,
      transactionId: json['transactionId'] as String?,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalItems: json['totalItems'] as int?,
      subTotal: json['subTotal'] as num?,
      deliveryCharge: json['deliveryCharge'] as num?,
      couponDiscount: json['couponDiscount'] as num?,
      totalPayable: json['totalPayable'] as num?,
      distanceKm: json['distanceKm'] as num?,
      availableDeliveryBoys: (json['availableDeliveryBoys'] as List<dynamic>?)
              ?.map((e) =>
                  AvailableDeliveryBoy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int?,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'restaurantLocation': restaurantLocation?.toJson(),
        '_id': id,
        'userId': userId?.toJson(),
        'cartId': cartId,
        'restaurantId': restaurantId?.toJson(),
        'deliveryAddress': deliveryAddress?.toJson(),
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'orderStatus': orderStatus,
        'deliveryBoyId': deliveryBoyId?.toJson(),
        'deliveryStatus': deliveryStatus,
        'transactionId': transactionId,
        'products': products.map((e) => e.toJson()).toList(),
        'totalItems': totalItems,
        'subTotal': subTotal,
        'deliveryCharge': deliveryCharge,
        'couponDiscount': couponDiscount,
        'totalPayable': totalPayable,
        'distanceKm': distanceKm,
        'availableDeliveryBoys':
            availableDeliveryBoys.map((e) => e.toJson()).toList(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'acceptedAt': acceptedAt?.toIso8601String(),
      };
}

// ───────────────── helper models ─────────────────

class GeoPoint {
  final String? type;
  final List<double> coordinates;

  GeoPoint({
    this.type,
    this.coordinates = const [],
  });

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

class UserRef {
  final String? id;
  final String? email;
  final String? rawId; // from "id" field inside userId

  UserRef({
    this.id,
    this.email,
    this.rawId,
  });

  factory UserRef.fromJson(Map<String, dynamic> json) {
    return UserRef(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      rawId: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'id': rawId,
      };
}

class RestaurantRef {
  final String? id;
  final String? restaurantName;
  final String? locationName;

  RestaurantRef({
    this.id,
    this.restaurantName,
    this.locationName,
  });

  factory RestaurantRef.fromJson(Map<String, dynamic> json) {
    return RestaurantRef(
      id: json['_id'] as String?,
      restaurantName: json['restaurantName'] as String?,
      locationName: json['locationName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'restaurantName': restaurantName,
        'locationName': locationName,
      };
}

class DeliveryAddress {
  final GeoPoint? location;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? addressType;
  final String? id;

  DeliveryAddress({
    this.location,
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.addressType,
    this.id,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      location: json['location'] != null
          ? GeoPoint.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      addressType: json['addressType'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
        'addressType': addressType,
        '_id': id,
      };
}

class DeliveryBoy {
  final String? id;
  final String? fullName;
  final String? mobileNumber;

  DeliveryBoy({
    this.id,
    this.fullName,
    this.mobileNumber,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) {
    return DeliveryBoy(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'fullName': fullName,
        'mobileNumber': mobileNumber,
      };
}

class ProductItem {
  final String? restaurantProductId;
  final String? recommendedId;
  final int? quantity;
  final String? name;
  final num? basePrice;
  final String? image;
  final String? id;

  ProductItem({
    this.restaurantProductId,
    this.recommendedId,
    this.quantity,
    this.name,
    this.basePrice,
    this.image,
    this.id,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      restaurantProductId: json['restaurantProductId'] as String?,
      recommendedId: json['recommendedId'] as String?,
      quantity: json['quantity'] as int?,
      name: json['name'] as String?,
      basePrice: json['basePrice'] as num?,
      image: json['image'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'restaurantProductId': restaurantProductId,
        'recommendedId': recommendedId,
        'quantity': quantity,
        'name': name,
        'basePrice': basePrice,
        'image': image,
        '_id': id,
      };
}

class AvailableDeliveryBoy {
  final String? deliveryBoyId;
  final String? fullName;
  final String? mobileNumber;
  final String? vehicleType;
  final num? walletBalance;
  final String? status;
  final String? id;

  AvailableDeliveryBoy({
    this.deliveryBoyId,
    this.fullName,
    this.mobileNumber,
    this.vehicleType,
    this.walletBalance,
    this.status,
    this.id,
  });

  factory AvailableDeliveryBoy.fromJson(Map<String, dynamic> json) {
    return AvailableDeliveryBoy(
      deliveryBoyId: json['deliveryBoyId'] as String?,
      fullName: json['fullName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      vehicleType: json['vehicleType'] as String?,
      walletBalance: json['walletBalance'] as num?,
      status: json['status'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'deliveryBoyId': deliveryBoyId,
        'fullName': fullName,
        'mobileNumber': mobileNumber,
        'vehicleType': vehicleType,
        'walletBalance': walletBalance,
        'status': status,
        '_id': id,
      };
}
