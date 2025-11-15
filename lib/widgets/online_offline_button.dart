// lib/widgets/online_offline_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';

class OnlineOfflineButton extends StatelessWidget {
  const OnlineOfflineButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryStatusProvider>(
      builder: (context, prov, _) {
        final isOnline = prov.isOnline;
        final busy = prov.state == DeliveryStatusState.updating || prov.state == DeliveryStatusState.loading;

        return GestureDetector(
          onTap: busy
              ? null
              : () async {
                  try {
                    // Optionally do optimistic UI:
                    prov.setLocal(!isOnline);
                    await prov.toggleStatus();
                    GlobalToast.showSuccess(isOnline ? 'Went offline' : 'You are online');
                  } catch (e) {
                    GlobalToast.showError('Status update failed');
                  }
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isOnline ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  isOnline ? Icons.toggle_on : Icons.toggle_off,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                if (busy) ...[
                  const SizedBox(width: 8),
                  const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
