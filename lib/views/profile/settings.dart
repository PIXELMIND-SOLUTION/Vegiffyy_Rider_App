import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSettingsScreen extends StatefulWidget {
  const LocationSettingsScreen({super.key});

  @override
  State<LocationSettingsScreen> createState() => _LocationSettingsScreenState();
}

class _LocationSettingsScreenState extends State<LocationSettingsScreen> {
  bool _isLoading = false;
  PermissionStatus? _status;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final status = await Permission.location.status;
    if (!mounted) return;
    setState(() {
      _status = status;
    });
  }

  String _statusLabel(PermissionStatus? status) {
    if (status == null) return "Checking...";
    switch (status) {
      case PermissionStatus.granted:
        return "Allowed";
      case PermissionStatus.denied:
        return "Denied";
      case PermissionStatus.restricted:
        return "Restricted";
      case PermissionStatus.limited:
        return "Limited";
      case PermissionStatus.permanentlyDenied:
        return "Permanently denied";
      default:
        return status.toString();
    }
  }

  Color _statusColor(PermissionStatus? status) {
    if (status == null) return Colors.grey;
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _handleAllow() async {
    setState(() => _isLoading = true);

    final status = await Permission.location.request();

    if (!mounted) return;
    setState(() {
      _status = status;
      _isLoading = false;
    });

    // Optional: show a small snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status.isGranted
              ? 'Location permission granted'
              : 'Location permission not granted',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleDontAllow() async {
    // We can't revoke permission directly. Open app settings instead.
    final opened = await openAppSettings();

    if (!mounted) return;

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open app settings'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // When user returns from settings, refresh status
      await _loadStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _statusLabel(_status);
    final statusColor = _statusColor(_status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Location Access",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Control whether the app can access your location.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Card showing current status
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: statusColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location permission",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 14,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Allow button
                  ElevatedButton.icon(
                    onPressed: _handleDontAllow,
                    icon: const Icon(Icons.check),
                    label: const Text("Allow location"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Don't allow button
                  OutlinedButton.icon(
                    onPressed: _handleDontAllow,
                    icon: const Icon(Icons.close),
                    label: const Text("Don’t allow"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    "Note: On Android/iOS, apps cannot directly remove permissions. "
                    "“Don’t allow” will open the system settings so you can turn off location access.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
