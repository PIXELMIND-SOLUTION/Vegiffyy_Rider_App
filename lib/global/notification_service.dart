import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:veggify_delivery_app/main.dart';
import 'package:veggify_delivery_app/widgets/order_alert_dialog.dart';

// Make sure you have a GlobalKey<NavigatorState> called `navigatorKey` in main.dart
// e.g. final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

typedef OrderHandler = FutureOr<void> Function(Map<String, dynamic> orderData);

class NotificationService {
  NotificationService._private();
  static final NotificationService _instance = NotificationService._private();
  static NotificationService get instance => _instance;

  final AudioPlayer _player = AudioPlayer(playerId: 'order_alert');
  bool _isShowing = false;
  bool _isDisposed = false;

  // optional queue: uncomment to enable queueing
  final List<_QueuedAlert> _queue = [];

  /// Show an incoming order alert. Only one dialog shown at a time.
  /// onAccept/onReject are callbacks invoked with the orderData.
  Future<void> showOrderAlert({
    required Map<String, dynamic> orderData,
    required OrderHandler onAccept,
    required OrderHandler onReject,
    bool allowQueue = true, // if true, queue next alerts; otherwise ignore while one is shown
    bool loopSound = true,
  }) async {
    if (_isDisposed) return;

    if (_isShowing) {
      if (allowQueue) {
        _queue.add(_QueuedAlert(orderData, onAccept, onReject));
      }
      return; // either queued or ignored
    }

    _isShowing = true;

    try {
      // play sound (non-blocking)
      await playAlert(loop: loopSound);

      // use navigatorKey to show dialog
      final ctx = navigatorKey.currentState?.overlay?.context ?? navigatorKey.currentState?.context;
      if (ctx == null) {
        // Could not get context - stop sound and return
        await stopAlert();
        _isShowing = false;
        _drainQueueIfAny();
        return;
      }

      // showDialog is async and returns when popped
      await showGeneralDialog(
        context: ctx,
        barrierDismissible: false,
        barrierLabel: 'Incoming order',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          // Wrap with WillPopScope to intercept back button
          return WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              child: Center(
                child: OrderAlertDialog(
                  orderData: orderData,
                  onAccept: () async {
                    try {
                      await onAccept(orderData);
                    } finally {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  onReject: () async {
                    try {
                      await onReject(orderData);
                    } finally {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('NotificationService.showOrderAlert error: $e');
    } finally {
      await stopAlert();
      _isShowing = false;
      _drainQueueIfAny();
    }
  }

final AudioPlayer _alertPlayer = AudioPlayer();

Future<void> playAlert({bool loop = true}) async {
  try {
    // ensure stopped first
    await _alertPlayer.stop();

    // set volume & release mode
    await _alertPlayer.setVolume(1.0);
    await _alertPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);

    // Common asset paths to try (order matters)
    final candidates = <String>[
      'sounds/order_alert.mp3',      // if pubspec lists assets/sounds/...
      'order_alert.mp3',             // if pubspec lists assets/order_alert.mp3
    ];

    for (final path in candidates) {
      try {
        debugPrint('Trying AudioPlayer.play with AssetSource("$path")');
        await _alertPlayer.play(AssetSource(path));
        debugPrint('Play started for "$path"');
        return;
      } catch (e, st) {
        debugPrint('Failed to play "$path": $e\n$st');
      }
    }

    debugPrint('All asset path attempts failed. Make sure asset exists and pubspec is correct.');
  } catch (e, st) {
    debugPrint('playAlert top-level error: $e\n$st');
  }
}

Future<void> stopAlert() async {
  try {
    await _alertPlayer.stop();
    await _alertPlayer.setReleaseMode(ReleaseMode.stop);
    debugPrint('Alert stopped');
  } catch (e) {
    debugPrint('Error stopping alert: $e');
  }
}

  void _drainQueueIfAny() {
    if (_queue.isEmpty) return;
    final next = _queue.removeAt(0);
    // Fire and forget
    Future.microtask(() {
      showOrderAlert(
        orderData: next.order,
        onAccept: next.onAccept,
        onReject: next.onReject,
        allowQueue: true,
      );
    });
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await stopAlert();
    _player.dispose();
    _queue.clear();
  }
}

class _QueuedAlert {
  final Map<String, dynamic> order;
  final OrderHandler onAccept;
  final OrderHandler onReject;
  _QueuedAlert(this.order, this.onAccept, this.onReject);
}
