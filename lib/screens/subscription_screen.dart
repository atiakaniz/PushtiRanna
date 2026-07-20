import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';
import '../themes/auth_theme.dart';

/// Subscription screen with built-in OTP entry.
///
/// Layout (matches the reference screenshots):
///   • Header row with "Activate your subscription" + "Edit number" link
///   • "Enter the code we sent" title + phone hint
///   • 6 box-style digit inputs
///   • Pill "Verify" button + "Resend OTP" link
///   • Inline error label
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final PhoneAuthController auth = Get.find();

  /// OTP input state.
  static const _otpLength = 6;
  final List<TextEditingController> _ctrls =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _foci = List.generate(_otpLength, (_) => FocusNode());

  /// True once the OTP has been requested at least once this screen visit.
  final RxBool _otpSent = false.obs;

  @override
  void initState() {
    super.initState();
    // Pre-trigger an OTP send when the screen first lands so the user can
    // just look at their SMS and start typing.
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _foci) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _ctrls.map((c) => c.text).join();

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();
    final result = await auth.sendOtp();
    if (!mounted) return;
    _otpSent.value = true;
    if (result == true) {
      _snack('OTP sent to ${auth.currentPhone.value}');
      // Move focus to the first box.
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _foci.first.requestFocus());
    } else if (result == 'already') {
      // bdapps says this number is already subscribed. Confirm via the
      // dedicated status endpoint and route to HOME if active.
      final active = await auth.checkSubscription();
      if (!mounted) return;
      if (active) {
        await auth.markSubscribed();
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        _snack('This number is already on our records but is not currently '
            'active. Please contact support.');
      }
    } else {
      _snack(auth.lastError.value.isEmpty
          ? 'Could not send OTP'
          : auth.lastError.value);
    }
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();
    final code = _code;
    if (code.length != _otpLength) {
      _snack('Please enter the $_otpLength-digit code');
      return;
    }
    debugPrint('[Subscription] _verify starting code=$code ref=${auth.referenceNo.value}');
    final ok = await auth.verifyOtp(code);
    debugPrint('[Subscription] _verify ok=$ok err=${auth.lastError.value}');
    if (!mounted) return;
    if (ok) {
      Get.offAllNamed(AppRoutes.HOME);
      return;
    }
    final msg = auth.lastError.value.isEmpty
        ? 'OTP not accepted. Please try again.'
        : auth.lastError.value;
    auth.lastError.value = msg; // ensure the inline label updates
  }

  void _onDigitChanged(int index, String value) {
    // Handle paste of the full code into a single box.
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < _otpLength; i++) {
        final ch = i < digits.length ? digits[i] : '';
        _ctrls[i].text = ch;
      }
      final nextFocus = digits.length < _otpLength ? digits.length : _otpLength - 1;
      _foci[nextFocus].requestFocus();
      _maybeAutoVerify();
      return;
    }

    if (value.isNotEmpty && index < _otpLength - 1) {
      _foci[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _foci[index - 1].requestFocus();
    }
    _maybeAutoVerify();
  }

  void _maybeAutoVerify() {
    // Auto-verify disabled so the user controls when the request fires.
    // Tap the Verify button to submit.
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                phone: auth.currentPhone.value,
                onEdit: () => Get.offAllNamed(AppRoutes.PHONE),
              ),
              const SizedBox(height: 28),
              const Text(
                'Enter the code we sent',
                textAlign: TextAlign.center,
                style: AuthTheme.screenTitle,
              ),
              const SizedBox(height: 10),
              Obx(() => Text(
                    'A $_otpLength-digit verification code was sent to your '
                    'number:\n${auth.currentPhone.value}',
                    textAlign: TextAlign.center,
                    style: AuthTheme.screenSubtitle,
                  )),
              const SizedBox(height: 32),
              _OtpBoxes(
                ctrls: _ctrls,
                foci: _foci,
                onChanged: _onDigitChanged,
              ),
              const SizedBox(height: 14),
              Obx(() => auth.lastError.value.isEmpty
                  ? const SizedBox(height: 6)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        auth.lastError.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AuthTheme.error,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    )),
              const SizedBox(height: 24),
              Obx(() {
                final canVerify = auth.referenceNo.value != null &&
                    auth.referenceNo.value!.isNotEmpty &&
                    auth.referenceNo.value != 'null';
                return SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: AuthTheme.primaryButtonStyle,
                    onPressed: (auth.isLoading.value || !canVerify)
                        ? null
                        : _verify,
                    child: auth.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Color(0xFF06231E),
                            ),
                          )
                        : const Text('Verify'),
                  ),
                );
              }),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: auth.isLoading.value ? null : _sendOtp,
                  child: const Text(
                    'Resend OTP',
                    style: AuthTheme.linkMuted,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.phone, required this.onEdit});

  final String phone;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'Activate your subscription',
            style: TextStyle(
              color: AuthTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          behavior: HitTestBehavior.opaque,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit number',
                style: TextStyle(
                  color: AuthTheme.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.edit, size: 16, color: AuthTheme.accent),
            ],
          ),
        ),
      ],
    );
  }
}

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({
    required this.ctrls,
    required this.foci,
    required this.onChanged,
  });

  final List<TextEditingController> ctrls;
  final List<FocusNode> foci;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Compute box width from available space, keep them square-ish.
      const spacing = 10.0;
      final boxWidth =
          (constraints.maxWidth - spacing * (ctrls.length - 1)) / ctrls.length;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(ctrls.length, (i) {
          return SizedBox(
            width: boxWidth.clamp(36.0, 56.0),
            height: boxWidth.clamp(44.0, 64.0),
            child: _OtpBox(
              controller: ctrls[i],
              focusNode: foci[i],
              onChanged: (v) => onChanged(i, v),
            ),
          );
        }),
      );
    });
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      autofocus: false,
      style: const TextStyle(
        color: AuthTheme.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      cursorColor: AuthTheme.accent,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: AuthTheme.surface,
        contentPadding: EdgeInsets.zero,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AuthTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AuthTheme.accent,
            width: 1.6,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}