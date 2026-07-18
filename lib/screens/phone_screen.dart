import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';

/// First screen for new users: ask for their phone number,
/// save it, then send the user to the subscription + OTP screen.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phone = TextEditingController(text: '+880');
  final PhoneAuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('+880');
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: const Text('Enter your phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text(
              'We will use this number to verify your subscription and '
              'send you an OTP.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black),
              onChanged: (_) {
                // keep the +880 prefix in place
                if (!_phone.text.startsWith('+880')) {
                  _phone.value = TextEditingValue(
                    text: '+880',
                    selection: const TextSelection.collapsed(offset: 4),
                  );
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF2E7D32)),
                hintText: fmt.pattern,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Obx(() => SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: auth.isLoading.value
                        ? null
                        : () => _submit(),
                    child: auth.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('Continue',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final phone = auth.normalizePhone(_phone.text);
    if (!auth.isValidPhone(phone)) {
      Get.snackbar(
        'Invalid number',
        'Please enter your full phone number (e.g. +8801XXXXXXXXX)',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await auth.savePhone(phone);

    final subscribed = await auth.checkSubscription();
    if (!mounted) return;

    if (subscribed) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.SUBSCRIPTION);
    }
  }
}
