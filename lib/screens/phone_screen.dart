import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';
import '../themes/auth_theme.dart';

/// First screen for new users: ask for their phone number, save it, then
/// send the user to the subscription screen.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phone = TextEditingController(text: '+880');
  final PhoneAuthController auth = Get.find();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = auth.normalizePhone(_phone.text);
    if (!auth.isValidPhone(phone)) {
      _snack('Please enter your full phone number (e.g. +8801XXXXXXXXX)');
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

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AuthTheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AuthTheme.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/icon/app_icon.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Welcome to PushtiRanna',
                textAlign: TextAlign.center,
                style: AuthTheme.screenTitle,
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your phone number to continue.',
                textAlign: TextAlign.center,
                style: AuthTheme.screenSubtitle,
              ),
              const SizedBox(height: 36),
              _PhoneField(
                controller: _phone,
                auth: auth,
                onChanged: (_) {
                  if (!_phone.text.startsWith('+880')) {
                    _phone.value = TextEditingValue(
                      text: '+880',
                      selection: const TextSelection.collapsed(offset: 4),
                    );
                  }
                },
              ),
              const SizedBox(height: 28),
              Obx(() => SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      style: AuthTheme.primaryButtonStyle,
                      onPressed: auth.isLoading.value ? null : _submit,
                      child: auth.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Color(0xFF06231E),
                              ),
                            )
                          : const Text('Continue'),
                    ),
                  )),
              const Spacer(flex: 2),
              _ChargingNotice(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.auth,
    required this.onChanged,
  });

  final TextEditingController controller;
  final PhoneAuthController auth;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      style: const TextStyle(color: AuthTheme.textPrimary, fontSize: 16),
      cursorColor: AuthTheme.accent,
      decoration: InputDecoration(
        labelText: 'Phone number',
        labelStyle: const TextStyle(color: AuthTheme.textMuted),
        floatingLabelStyle: const TextStyle(color: AuthTheme.accent),
        prefixIcon: const Icon(Icons.phone_iphone, color: AuthTheme.accent),
        hintText: 'e.g. 017XXXXXXXXX',
        hintStyle: const TextStyle(color: AuthTheme.textMuted),
        filled: true,
        fillColor: AuthTheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AuthTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AuthTheme.borderFocused, width: 1.6),
        ),
      ),
    );
  }
}

class _ChargingNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AuthTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AuthTheme.accent.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: 'Charging: ',
                  style: TextStyle(color: AuthTheme.textSecondary),
                ),
                TextSpan(
                  text: '2.78 BDT',
                  style: TextStyle(
                    color: AuthTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' including (Vat+SC+SD)',
                  style: TextStyle(color: AuthTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'For Robi and Airtel Users only.',
            style: TextStyle(
              color: AuthTheme.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
