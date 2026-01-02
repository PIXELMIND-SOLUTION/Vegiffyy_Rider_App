// lib/views/auth/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:veggify_delivery_app/utils/session_manager.dart';
import 'package:veggify_delivery_app/views/amoders_loading.dart';
import 'package:veggify_delivery_app/views/auth/login_screen.dart';
import 'package:veggify_delivery_app/views/navbar/navbar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  // ------------------------------------------------
  // SESSION + NAVIGATION
  // ------------------------------------------------
  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final loggedIn = await SessionManager.isLoggedIn();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => loggedIn
              ? const NavbarScreen(initialIndex: 0)
              : const LoginScreen(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // ------------------------------------------------
  // URL LAUNCHER
  // ------------------------------------------------
  Future<void> _openWebsite() async {
    final uri = Uri.parse("https://pixelmindsolutions.com");

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // ------------------------------------------------
  // POWERED BY BRANDING (BOTTOM)
  // ------------------------------------------------
  Widget _poweredByBranding() {
    return Positioned(
      bottom: 24 + MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            "Powered by",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),

          // ✅ CLICKABLE TEXT
          GestureDetector(
            onTap: _openWebsite,
            child: Text(
              "Pixelmindsolutions Pvt Ltd",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.underline,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // UI
  // ------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔥 FULL SCREEN BACKGROUND IMAGE
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/vegsplash.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // 🌑 DARK OVERLAY (DO NOT BLOCK TOUCH)
          IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),

          // ⏳ CENTER LOADER (DO NOT BLOCK TOUCH)
          IgnorePointer(
            ignoring: true,
            child: SafeArea(
              left: false,
              right: false,
              child: Column(
                children: const [
                  Spacer(),
                  AmodersLoading(size: 45),
                  Spacer(),
                ],
              ),
            ),
          ),

          // ✅ CLICKABLE BRANDING ON TOP
          _poweredByBranding(),
        ],
      ),
    );
  }
}
