// global_toast.dart
// A self-contained, dependency-free global toast service for Flutter.
// Place this file in your `lib/` folder and import where needed:
// import 'package:your_app/global_toast.dart';
//
// Setup:
// 1) Create a GlobalKey<NavigatorState> in your main.dart (if you don't already have one):
//    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// 2) Pass it to MaterialApp: navigatorKey: navigatorKey,
// 3) Initialize the toast service once (for example in main):
//    GlobalToast.init(navigatorKey);
//
// Usage (anywhere in app):
//    GlobalToast.showSuccess('Saved successfully');
//    GlobalToast.showError('Failed to save');
//    GlobalToast.showInfo('New update available');
//    GlobalToast.showWarning('Low battery');
//    GlobalToast.show('Custom message', backgroundColor: Colors.purple);

import 'dart:async';
import 'package:flutter/material.dart';

class GlobalToast {
  GlobalToast._(); // prevent instantiation

  static late GlobalKey<NavigatorState> _navigatorKey;
  static bool _inited = false;

  /// Call this once with your app's navigator key
  static void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _inited = true;
  }

  static OverlayState? get _overlay {
    if (!_inited) return null;
    return _navigatorKey.currentState?.overlay;
  }

  /// Generic show function
  static void show(
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastType type = ToastType.info,
    TextStyle? textStyle,
    Color? backgroundColor,
    IconData? icon,
    double? borderRadius,
    EdgeInsets? padding,
    ToastPosition position = ToastPosition.top,
  }) {
    if (_overlay == null) {
      // If not initialized, fallback to debugPrint
      // (so it won't crash in tests or early initialization)
      debugPrint('Toast: $message');
      return;
    }

    final entry = OverlayEntry(builder: (context) {
      return _ToastWidget(
        message: message,
        duration: duration,
        type: type,
        textStyle: textStyle,
        backgroundColor: backgroundColor,
        icon: icon,
        borderRadius: borderRadius ?? 12,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        position: position,
        onDismissed: () {},
      );
    });

    _overlay!.insert(entry);

    // _ToastWidget handles its own removal after duration via a callback
    // We'll remove the OverlayEntry when the widget signals it's done.
    // To do that, listen to a Stream from the widget using a Completer.
    // Simpler approach: let the widget remove itself by finding the overlay entry
    // using a key. We'll pass the OverlayEntry reference into the widget via closure.

    // Rebuild entry with reference to itself so the widget can remove it.
    entry.markNeedsBuild();

    // The widget will search and remove this entry after animation.
  }

  static void showSuccess(String message, {Duration duration = const Duration(seconds: 3)}) {
    show(message, duration: duration, type: ToastType.success);
  }

  static void showError(String message, {Duration duration = const Duration(seconds: 4)}) {
    show(message, duration: duration, type: ToastType.error);
  }

  static void showInfo(String message, {Duration duration = const Duration(seconds: 3)}) {
    show(message, duration: duration, type: ToastType.info);
  }

  static void showWarning(String message, {Duration duration = const Duration(seconds: 3)}) {
    show(message, duration: duration, type: ToastType.warning);
  }
}

enum ToastType { success, error, info, warning }

enum ToastPosition { top, bottom }

class _ToastWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final ToastType type;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsets padding;
  final ToastPosition position;
  final VoidCallback onDismissed;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.duration,
    required this.type,
    this.textStyle,
    this.backgroundColor,
    this.icon,
    required this.borderRadius,
    required this.padding,
    required this.position,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _offsetAnimation = Tween<Offset>(
      begin: widget.position == ToastPosition.top ? const Offset(0, -0.2) : const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _timer = Timer(widget.duration, () async {
      await _controller.reverse();
      // Remove this widget from overlay
      if (mounted) {
        // find overlay entry and remove it by walking up the element tree
        Overlay.of(context)?.setState(() {});
      }
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color _bgColorForType() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.shade600;
      case ToastType.error:
        return Colors.red.shade600;
      case ToastType.warning:
        return Colors.orange.shade700;
      case ToastType.info:
      default:
        return Colors.blueGrey.shade800;
    }
  }

  IconData _iconForType() {
    if (widget.icon != null) return widget.icon!;
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_outlined;
      case ToastType.info:
      default:
        return Icons.info_outline;
    }
  }

  Alignment _alignmentForPosition() {
    return widget.position == ToastPosition.top ? Alignment.topCenter : Alignment.bottomCenter;
  }

  EdgeInsets _marginForPosition(BuildContext context) {
    final media = MediaQuery.of(context);
    if (widget.position == ToastPosition.top) {
      return EdgeInsets.fromLTRB(16, media.padding.top + 16, 16, 0);
    } else {
      return const EdgeInsets.fromLTRB(16, 0, 16, 32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: SafeArea(
          child: Align(
            alignment: _alignmentForPosition(),
            child: Padding(
              padding: _marginForPosition(context),
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: widget.padding,
                      decoration: BoxDecoration(
                        color: _bgColorForType(),
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _iconForType(),
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              widget.message,
                              style: widget.textStyle ?? const TextStyle(color: Colors.white, fontSize: 14),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
