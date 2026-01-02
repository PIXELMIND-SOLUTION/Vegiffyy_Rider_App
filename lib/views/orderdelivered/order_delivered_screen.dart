// lib/views/orderdelivered/order_delivered_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/models/Order/picked_order_model.dart';
import 'package:veggify_delivery_app/provider/PickedOrder/picked_order_provider.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';
import 'package:veggify_delivery_app/views/chat/chat_screen.dart';
import 'package:veggify_delivery_app/views/confirm/confirm_order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:veggify_delivery_app/views/navbar/navbar_screen.dart';

class OrderDeliveredScreen extends StatefulWidget {
  const OrderDeliveredScreen({super.key});

  @override
  State<OrderDeliveredScreen> createState() => _OrderDeliveredScreenState();
}

class _OrderDeliveredScreenState extends State<OrderDeliveredScreen> {
  bool _loadingLocal = true;
  String? _selectedPaymentType; // 'Cash' or 'Online'
  String? _qrCodeData;
  bool _isGeneratingQR = false;
  bool _isDeliveringOrder = false;
  String? riderId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (_)async {
    riderId = await SessionManager.getUserId();
      final prov = Provider.of<PickedOrderProvider>(context, listen: false);
      prov.fetchPickedOrders().whenComplete(() {
        if (mounted) setState(() => _loadingLocal = false);
      });
    });
  }

  Future<void> _generateQRCode() async {
    setState(() => _isGeneratingQR = true);
    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:5051/api/generateupiqr'),
        headers: {'Content-Type': 'application/json'},
      );
print("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _qrCodeData = data['qrCodeLink'];
          });
        } else {
          _showError('Failed to generate QR code');
        }
      } else {
        _showError('Failed to generate QR code');
      }
    } catch (e) {
      _showError('Error generating QR code: $e');
    } finally {
      setState(() => _isGeneratingQR = false);
    }
  }

  Future<void> _markOrderDelivered(PickedOrderModel order) async {
    setState(() => _isDeliveringOrder = true);
    try {
      final deliveryBoyId = order.deliveryBoyId?.id ?? '';
      
      Map<String, dynamic> body = {
        'deliveryBoyId': deliveryBoyId,
        'orderId': order.id,
      };

      // Only add paymentType if payment method is COD
      if (order.paymentMethod == 'COD' && _selectedPaymentType != null) {
        body['paymentType'] = _selectedPaymentType;
      }

      final response = await http.put(
        Uri.parse('http://31.97.206.144:5051/api/markorder-delivered'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
print("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NavbarScreen(initialIndex: 0,)),
          );
        } else {
          _showError(data['message'] ?? 'Failed to mark order as delivered');
        }
      } else {
        _showError('Failed to mark order as delivered');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isDeliveringOrder = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }


    Future<void> _openGoogleMaps(dynamic lg, dynamic lt) async {
    try {
      print("kkkkkkkkkkkkkkkk$lg");
            print("kkkkkkkkkkkkkkkk$lt");

      if (lt != null && lg != null) {

        final String googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$lt,$lg';

        final String googleMapsAppUrl =
            'google.navigation:q=$lt,$lg';

        bool launched = false;

        try {
          launched = await launchUrl(
            Uri.parse(googleMapsAppUrl),
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          print('Could not launch Google Maps app: $e');
        }

        if (!launched) {
          launched = await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        }

        if (!launched) {
          _showErrorSnackbar(
            'Could not open Google Maps. Please check if you have Google Maps installed.',
          );
        }
      } else {
        _showErrorSnackbar('Location coordinates are not available.');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to open Google Maps: $e');
    }
  }

    void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }


    Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cannot call $phone')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<PickedOrderProvider>(
          builder: (context, prov, _) {
            if (_loadingLocal || prov.state == PickedOrderState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (prov.state == PickedOrderState.error) {
              return _buildScreenContent(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Failed to load picked orders', style: TextStyle(color: Colors.red[700])),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: () => prov.fetchPickedOrders(), child: const Text('Retry')),
                    ],
                  ),
                ),
                order: null,
              );
            }

            final order = prov.firstPickedOrder;
            final isCOD = order?.paymentMethod == 'COD';
            
            return _buildScreenContent(
              order: order,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drop badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Drop', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Customer name
                      Text(
                        order?.deliveryBoyId?.fullName ?? 'Customer',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      // Address
                      Text(order?.deliveryAddress?.street ?? 'Address not available', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      // Order ID
                      Text('Order: ${order?.id ?? 'N/A'}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 20),
                      const Text('How To Reach:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildActionButton(icon: Icons.call_outlined, label: 'Call', onTap: () {
                                                  _launchPhone(order?.deliveryBoyId?.mobileNumber ?? '');

                          })),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.chat_bubble_outline,
                              label: 'Chat',
                              onTap: () =>                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          deliveryBoyId: riderId.toString(),
                          userId: order?.userId?.id ?? '',
                          title: 'Chat with User',
                        ),
                      ),
                    )
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: _buildActionButton(icon: Icons.map_outlined, label: 'Map', onTap: () {
                            _openGoogleMaps(order?.deliveryAddress?.location?.coordinates[0] ?? 0.0,order?.deliveryAddress?.location?.coordinates[1] ?? 0.0);
                          })),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Payment Status Container
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Container(
                              width: 24, 
                              height: 24, 
                              decoration: BoxDecoration(
                                color: isCOD ? Colors.orange : Colors.green, 
                                shape: BoxShape.circle
                              ), 
                              child: Icon(
                                isCOD ? Icons.payments : Icons.check, 
                                color: Colors.white, 
                                size: 16
                              )
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isCOD ? 'Cash on Delivery' : 'Bill Paid Through Online',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
                            ),
                          ],
                        ),
                      ),
                      
                      // Payment Type Selection (only for COD)
                      if (isCOD) ...[
                        const SizedBox(height: 20),
                        const Text('Payment Method:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
                        RadioListTile<String>(
                          title: const Text('Cash'),
                          value: 'Cash',
                          groupValue: _selectedPaymentType,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentType = value;
                              _qrCodeData = null; // Clear QR code when switching to cash
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Online'),
                          value: 'Online',
                          groupValue: _selectedPaymentType,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentType = value;
                            });
                            _generateQRCode();
                          },
                        ),
                        
                        // QR Code Display (only when Online is selected)
                        if (_selectedPaymentType == 'Online') ...[
                          const SizedBox(height: 20),
                          if (_isGeneratingQR)
                            const Center(child: CircularProgressIndicator())
                          else if (_qrCodeData != null)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  children: [
                                    Image.memory(
                                      base64Decode(_qrCodeData!.split(',')[1]),
                                      width: 200,
                                      height: 200,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Scan to Pay',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ],
                      
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Total Items', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Text(order?.totalItems.toString() ?? '0', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Total Paid', style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600)),
                        Text(
                          order != null ? '₹${order.totalPayable?.toStringAsFixed(2)}' : '₹0.00', 
                          style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600)
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScreenContent({required Widget child, PickedOrderModel? order}) {
    final isCOD = order?.paymentMethod == 'COD';
    final canDeliver = !isCOD || (isCOD && _selectedPaymentType != null);
    
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Image.asset('assets/map.png', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200])),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
                  ),
                  child: const Text('Drop Details!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
        Expanded(child: child),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (canDeliver && !_isDeliveringOrder && order != null) 
                ? () => _markOrderDelivered(order)
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: _isDeliveringOrder 
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Container(
                      //   width: 34, 
                      //   height: 34, 
                      //   decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), 
                      //   child: const Icon(Icons.keyboard_double_arrow_right, color: Color(0xFF4CAF50), size: 20)
                      // ),
                      const Expanded(
                        child: Text(
                          'Order Delivered', 
                          textAlign: TextAlign.center, 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        )
                      ),
                      const SizedBox(width: 34),
                    ],
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Icon(icon, color: Colors.green, size: 24), 
          const SizedBox(height: 4), 
          Text(label, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500))
        ]),
      ),
    );
  }
}