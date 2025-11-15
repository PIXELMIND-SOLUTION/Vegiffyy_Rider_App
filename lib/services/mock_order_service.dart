// // lib/services/mock_order_service.dart
// import 'dart:async';

// class MockOrderService {
//   MockOrderService._private();
//   static final MockOrderService instance = MockOrderService._private();

//   final StreamController<Map<String, dynamic>> _ctrl = StreamController.broadcast();

//   Stream<Map<String, dynamic>> get orders => _ctrl.stream;

//   void emitMockOrder({int index = 0, String? customId}) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final id = customId ?? 'mock_${now}_$index';
//     final order = {
//       'id': id,
//       'merchantName': 'Mock Merchant #$index',
//       'pickupAddress': 'Mock Pickup Address',
//       'amount': 40 + index * 10,
//       'items': [
//         {'name': 'Item A', 'quantity': 1 + index},
//         {'name': 'Item B', 'quantity': 2},
//       ],
//       'shortAddress': 'Block $index',
//       'timestamp': DateTime.now().toIso8601String(),
//     };
//     _ctrl.add(order);
//   }

//   void dispose() {
//     _ctrl.close();
//   }
// }
