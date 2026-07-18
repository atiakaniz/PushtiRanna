import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';

/// 6-digit OTP verification screen. After success → HOME.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final PhoneAuthController auth = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = _ctrl.text.trim();
    if (otp.length != 6) {
      _snack('Please enter the 6-digit code');
      return;
    }
    final ok = await auth.verifyOtp(otp);
    if (!mounted) return;
    if (ok) {
      Get.offAllNamed(AppRoutes.HOME);
    } else if (auth.lastError.value.isNotEmpty) {
      _snack(auth.lastError.value);
    }
  }

  Future<void> _resend() async {
    final ok = await auth.sendOtp();
    if (!mounted) return;
    _snack(ok ? 'OTP resent' : auth.lastError.value);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.sms_outlined,
                size: 80, color: Color(0xFF2E7D32)),
            const SizedBox(height: 16),
            const Text(
              'Enter the verification code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sent to ${auth.currentPhone.value}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _ctrl,
              focusNode: _focus,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                letterSpacing: 12,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '------',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 24),
            Obx(() => SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: auth.isLoading.value ? null : _verify,
                    icon: auth.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Verify'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _resend,
              child: const Text('Resend code',
                  style: TextStyle(color: Color(0xFF2E7D32))),
            ),
            const SizedBox(height: 16),
            Obx(() => auth.lastError.value.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    auth.lastError.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  )),
          ],
        ),
      ),
    );
  }
}