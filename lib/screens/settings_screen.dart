import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_gate_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Worker? _revokedWorker;
  Timer? _subscriptionPoll;

  @override
  void initState() {
    super.initState();
    // If a server-side check fires while the user is on the Settings
    // screen, bounce them straight to the gate.
    _revokedWorker = ever<int>(
      Get.find<PhoneAuthController>().subscriptionRevokedAt,
      (_) {
        if (!mounted) return;
        Get.offAllNamed(AppRoutes.GATE);
      },
    );

    // Same 30s background poll as HomeScreen — covers long foreground
    // sessions where the AppLifecycleState.resumed hook never fires.
    _subscriptionPoll = Timer.periodic(
      const Duration(seconds: 30),
      (_) => Get.find<PhoneAuthController>().checkSubscription(),
    );
  }

  @override
  void dispose() {
    _revokedWorker?.dispose();
    _subscriptionPoll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController());

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              'language'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  iconEnabledColor: Colors.green,
                  underline: const SizedBox(),

                  value: langController
                      .currentLocale.value.languageCode,

                  isExpanded: true,

                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(
                        'English',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'bn',
                      child: Text(
                        'বাংলা',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      langController.changeLanguage(
                        value,
                      );
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: 30),


            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text(
                  "Share App",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await SharePlus.instance.share(
                    ShareParams(
                      text:
                      "🍲 Check out PushtiRanna - Healthy Bengali Recipe App!\n\n"
                          "Learn more:\n"
                          "https://NestorabyAtia/pushtiranna",
                    ),
                  );
                },

              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text(
                  "Unsubscribe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFFE53935),
                  side: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await _confirmUnsubscribe(context);
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                onPressed: () async {
                  final authController = Get.put(AuthController());

                  await authController.logout();

                  Get.offAllNamed(
                    AppRoutes.GATE,
                  );
                },
              ),
            ),

            // Leave room so the pinned footer never overlaps content.
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Pinned version footer with the hidden admin unlock gesture.
          // End users will never see a "Manage recipes" entry — only the
          // owner who knows to long-press this label gets the PIN dialog.
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () => _showAdminUnlock(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    'PushtiRanna v1.0.0',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Asks the user to confirm cancellation of their bdapps subscription.
  ///
  /// On confirmation, [PhoneAuthController.unsubscribe] is called. The
  /// server returns one of:
  ///   * success      → local phone is cleared and the app routes to GATE
  ///   * failure      → the error is surfaced in a snackbar and we stay here
  Future<void> _confirmUnsubscribe(BuildContext context) async {
    final phone = Get.find<PhoneAuthController>().currentPhone.value;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Unsubscribe?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will cancel your PushtiRanna subscription. You will '
              'no longer be able to use the app until you resubscribe.',
            ),
            if (phone.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Phone: $phone',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFE53935),
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Unsubscribe'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    if (confirmed != true) return;

    final auth = Get.find<PhoneAuthController>();
    if (!Get.context!.mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(Get.context!);

    // Disable button while we wait for the server round-trip.
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final ok = await auth.unsubscribe();
    if (Get.isDialogOpen ?? false) Get.back();

    if (ok) {
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Subscription cancelled. You can resubscribe anytime.'),
          backgroundColor: Color(0xFF1B5E20),
        ),
      );
      Get.offAllNamed(AppRoutes.GATE);
    } else {
      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            auth.lastError.value.isEmpty
                ? 'Could not unsubscribe. Please try again.'
                : auth.lastError.value,
          ),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
    }
  }

  Future<void> _showAdminUnlock(BuildContext context) async {
    final gate = Get.find<AdminGateController>();
    // The dialog owns its own TextEditingController so it can be
    // disposed in lockstep with the dialog widget. Disposing it from
    // here while Get is still tearing down the dialog route causes
    // Flutter's "dependents.isEmpty" assertion during a previous build.
    final bodyKey = GlobalKey<_PinDialogBodyState>();

    final result = await Get.dialog<_PinResult>(
      AlertDialog(
        title: const Text('Owner PIN'),
        content: _PinDialogBody(key: bodyKey),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(
              result: _PinResult(pin: bodyKey.currentState?.currentPin ?? ''),
            ),
            child: const Text('Unlock'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    // If the user dismissed via barrier tap, Get returns null.
    if (result == null) return;

    await gate.unlock(result.pin);
    if (gate.isAdmin.value) {
      Get.offAllNamed(AppRoutes.ADMIN_RECIPES);
    } else {
      Get.snackbar(
        'Wrong PIN',
        'That PIN is not valid for this build.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

/// State body for the admin PIN dialog. Owns its TextEditingController
/// so disposal happens during the dialog widget's dispose(), not from
/// the caller — that's what previously triggered the
/// `_dependents.isEmpty` assertion.
class _PinDialogBody extends StatefulWidget {
  const _PinDialogBody({super.key});

  @override
  State<_PinDialogBody> createState() => _PinDialogBodyState();
}

class _PinDialogBodyState extends State<_PinDialogBody> {
  late final TextEditingController _pinCtrl;

  /// Most recently entered PIN text. The Unlock button reads this so
  /// it can pass the value back through Get.back().
  String currentPin = '';

  @override
  void initState() {
    super.initState();
    _pinCtrl = TextEditingController();
    _pinCtrl.addListener(() {
      currentPin = _pinCtrl.text;
    });
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _pinCtrl,
      autofocus: true,
      obscureText: true,
      keyboardType: TextInputType.number,
      // Submitting on Enter closes the dialog with the entered value.
      onSubmitted: (value) =>
          Get.back(result: _PinResult(pin: value)),
      decoration: InputDecoration(
        hintText: AdminGateController.hasConfiguredPin
            ? 'Enter PIN'
            : 'No PIN configured in this build',
      ),
    );
  }
}

/// Returned from the PIN dialog. `pin` may be empty if the user
/// tapped Unlock without typing anything.
class _PinResult {
  const _PinResult({required this.pin});
  final String pin;
}