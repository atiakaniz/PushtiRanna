import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';

/// Shown when the saved phone number is NOT yet subscribed.
/// Two actions:
///   • Edit number  → goes back to PHONE
///   • Subscribe / Send OTP → goes to OTP screen
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late String _phone;
  final PhoneAuthController auth = Get.find();

  @override
  void initState() {
    super.initState();
    _phone = auth.currentPhone.value;
  }

  Future<void> _subscribe() async {
    final ok = await auth.sendOtp();
    if (!mounted) return;
    if (ok) {
      Get.toNamed(AppRoutes.OTP);
    } else if (auth.lastError.value.isNotEmpty) {
      _snack(auth.lastError.value);
    }
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
        title: const Text('Subscription required'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.lock_outline,
                size: 80, color: Color(0xFF2E7D32)),
            const SizedBox(height: 16),
            const Text(
              'You are not subscribed yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $_phone',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            const Text(
              'Subscribe to unlock all recipes and continue using PushtiRanna. '
              'A verification OTP will be sent to your phone.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 36),
            Obx(() => SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: auth.isLoading.value ? null : _subscribe,
                    icon: auth.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send),
                    label: const Text('Subscribe / Send OTP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )),
            const SizedBox(height: 12),
            Obx(() => SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: auth.isLoading.value
                        ? null
                        : () => Get.offAllNamed(AppRoutes.PHONE),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit number'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )),
            const Spacer(),
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