// lib/views/orderpickup/order_pickup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/models/Order/accepted_order_model.dart';
import 'package:veggify_delivery_app/provider/AcceptedOrder/accepted_order_provider.dart';
import 'package:veggify_delivery_app/views/orderdelivered/order_delivered_screen.dart';

class OrderPickupScreen extends StatefulWidget {
  const OrderPickupScreen({super.key});

  @override
  State<OrderPickupScreen> createState() => _OrderPickupScreenState();
}

class _OrderPickupScreenState extends State<OrderPickupScreen> {
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Call provider to fetch accepted orders after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<AcceptedOrderProvider>(context, listen: false);
      prov.fetchAcceptedOrders();
    });
  }

  Future<void> _onPickupPressed(String id) async {
    setState(() => _submitting = true);
    final prov = Provider.of<AcceptedOrderProvider>(context, listen: false);

    final ok = await prov.acceptPickup(id);
    setState(() => _submitting = false);

    if (ok) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderDeliveredScreen()));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to mark as picked'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildOrderItemFromProduct(AcceptedOrderModel p) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: p.image != null && p.image!.isNotEmpty
                ? Image.network(p.image!, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Image.asset('assets/biriyani.png', width: 60, height: 60, fit: BoxFit.cover))
                : Image.asset('assets/biriyani.png', width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('Qty: ${p.quantity}', style: const TextStyle(color: Colors.grey)),
            ]),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2), borderRadius: BorderRadius.circular(4)),
            child: Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle))),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemPlaceholder() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/biriyani.png', width: 60, height: 60, fit: BoxFit.cover)),
        const SizedBox(width: 10),
        const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Veg panner fried rice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text('Qty: 1 Full', style: TextStyle(color: Colors.grey)),
        ])),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2), borderRadius: BorderRadius.circular(4)),
          child: Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle))),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UI layout preserved — content driven by provider via Consumer
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(width: double.infinity, height: double.infinity, child: Image.asset('assets/map.png', fit: BoxFit.cover)),
          Column(
            children: [
              const SizedBox(height: 40),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
              ])),
              const SizedBox(height: 250),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                  ),
                  child: Consumer<AcceptedOrderProvider>(
                    builder: (context, prov, _) {
                      if (prov.state == AcceptedOrderState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (prov.state == AcceptedOrderState.error) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                child: const Text('Order Details!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(prov.error ?? 'Failed to load orders', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: () => prov.fetchAcceptedOrders(), child: const Text('Retry')),
                          ],
                        );
                      }

                      if (prov.acceptedOrders.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                child: const Text('Order Details!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('No accepted orders available', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 12),
                            _buildOrderItemPlaceholder(),
                            const SizedBox(height: 10),
                            _buildOrderItemPlaceholder(),
                          ],
                        );
                      }

                      // use first accepted order
                      final order = prov.acceptedOrders.first;
                      final products = order.products;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: const Text('Order Details!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (products.isNotEmpty) ...[
                            _buildOrderItemFromProduct(products[0]),
                            const SizedBox(height: 10),
                            if (products.length > 1) _buildOrderItemFromProduct(products[1]),
                          ] else ...[
                            _buildOrderItemPlaceholder(),
                            const SizedBox(height: 10),
                            _buildOrderItemPlaceholder(),
                          ],
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (_submitting) ? null : () => _onPickupPressed(order.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: _submitting
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(width: 34, height: 34, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.keyboard_double_arrow_right, color: Color(0xFF4CAF50), size: 20)),
                                        const Expanded(child: Text('Order Pickup', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                        const SizedBox(width: 34),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
