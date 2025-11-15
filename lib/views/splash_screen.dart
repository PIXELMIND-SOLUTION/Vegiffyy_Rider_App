// lib/views/auth/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';
import 'package:veggify_delivery_app/views/auth/login_screen.dart';
import 'package:veggify_delivery_app/views/home/home_screen.dart';
import 'package:veggify_delivery_app/views/navbar/navbar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // small animation for polish
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();

    // start navigation check after a short delay to show splash nicely
    _navigate();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    // keep splash visible for at least 1200ms
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    try {
      final loggedIn = await SessionManager.isLoggedIn();

      if (!mounted) return;

      if (loggedIn) {
        // go to Home and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const NavbarScreen(initialIndex: 0)),
          (Route<dynamic> route) => false,
        );
      } else {
        // go to Login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      // On error fallback to login screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF083F1A), // top dark green
              Color(0xFF000000), // bottom blackish
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 260,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 28),

                // optional subtitle
                const Text(
                  "Powered by Nemishhrree",
                  style: TextStyle(
                    color: Color(0xFFEDEDED),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Operated by JEIPLX",
                  style: TextStyle(
                    color: Color(0xFFEDEDED),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 36),

                // small linear progress for feedback
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    backgroundColor: Colors.white.withOpacity(0.12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
