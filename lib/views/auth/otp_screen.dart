// lib/views/auth/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
import 'package:veggify_delivery_app/views/auth/signup_screen.dart';
import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/views/home/home_screen.dart';
import 'package:veggify_delivery_app/views/navbar/navbar_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (i) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (i) => FocusNode());

  @override
  void initState() {
    super.initState();
    // ensure provider starts timer if needed — provider started timer when OTP was sent
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _collectOtp() => _controllers.map((c) => c.text.trim()).join();

  Future<void> _verifyOtp() async {
    final otp = _collectOtp();
    if (otp.length < 4) {
      GlobalToast.showError('Enter 4-digit OTP');
      return;
    }
    final provider = context.read<LoginProvider>();
    final ok = await provider.verifyOtp(widget.mobile, otp);
    if (ok) {
      GlobalToast.showSuccess('Login successful');
      // Navigate to home or whatever; for now, go to signup or pop.
      // Example: if user not registered, push SignupScreen else home.
      // For demo we'll just pop to root:
      if (!mounted) return;
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const NavbarScreen(initialIndex: 0)),
);
      // or navigate to main app screen
    } else {
      GlobalToast.showError(provider.errorMessage ?? 'OTP verification failed');
    }
  }

  Future<void> _resendOtp() async {
    final provider = context.read<LoginProvider>();
    if (!provider.canResendOtp) return;
    final ok = await provider.resendOtp(widget.mobile);
    if (ok) {
      GlobalToast.showSuccess('OTP resent');
    } else {
      GlobalToast.showError(provider.errorMessage ?? 'Failed to resend OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          final remaining = provider.remainingSeconds;
          final canResend = provider.canResendOtp;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/otpimage.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Enter OTP',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: KeyboardListener(
                            focusNode: FocusNode(),
                            onKeyEvent: (event) => _onKeyEvent(event, index),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
                                ),
                              ),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) => _onChanged(value, index),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: canResend ? _resendOtp : null,
                      child: Text(
                        canResend ? 'Resend OTP' : 'Resend in ${remaining}s',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.state == LoginState.verifying ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: provider.state == LoginState.verifying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Verify', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
