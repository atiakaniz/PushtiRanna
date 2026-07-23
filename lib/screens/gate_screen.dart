import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';
import '../themes/auth_theme.dart';

/// Decision screen shown right after the splash.
/// - No saved phone number   → PHONE
/// - Saved phone number      → HOME
///
/// Also re-runs when the controller reports a server-side subscription
/// revocation (`PhoneAuthController.subscriptionRevokedAt`), so a user
/// who unsubscribes from the landing page (or any other bdapps surface)
/// and then opens the app is routed straight back to PHONE/SUBSCRIPTION.
class GateScreen extends StatefulWidget {
  const GateScreen({super.key});

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  final PhoneAuthController auth = Get.find();

  Worker? _revokedWorker;

  /// Set after `_route()` has been called once. Used to decide whether a
  /// `subscriptionRevokedAt` bump came from our own launch check (no
  /// snackbar — the user just opened the app cold) or from a resume-time
  /// check that fired while the user was already using the app (show the
  /// "subscription cancelled" snackbar).
  bool _initialRoutingDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());

    // Whenever the controller declares the subscription revoked while we
    // are mounted (either because we just re-checked on launch, or because
    // a resume-time check from another screen fired), make sure we are
    // showing the gate and show a snackbar explaining what happened.
    _revokedWorker = ever<int>(auth.subscriptionRevokedAt, (_) {
      if (!mounted) return;
      _route(showCancelledSnack: true);
    });
  }

  @override
  void dispose() {
    _revokedWorker?.dispose();
    super.dispose();
  }

  Future<void> _route({bool showCancelledSnack = false}) async {
    final savedPhone = await auth.getSavedPhone();

    if (savedPhone == null || savedPhone.isEmpty) {
      Get.offAllNamed(AppRoutes.PHONE);
      _initialRoutingDone = true;
      return;
    }

    // ALWAYS hit the server when we have a saved phone number — not just
    // when the local `is_subscribed` flag is true. This is what makes the
    // app server-authoritative: a user who unsubscribes from the landing
    // page and then opens the app cold, or who re-subscribes from the
    // landing page and then opens the app, both end up on the right
    // screen based on what bdapps says right now.
    final ok = await auth.checkSubscription();
    _initialRoutingDone = true;
    if (!mounted) return;
    if (ok) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      // Server says not subscribed. Send the user back to PHONE so they
      // re-enter their number and re-subscribe from scratch — same flow
      // as a brand-new user. PhoneScreen's submit handler will call
      // checkSubscription() again and route HOME/SUBSCRIPTION based on
      // whatever the server says at that moment.
      Get.offAllNamed(AppRoutes.PHONE);
    }

    if (showCancelledSnack && _initialRoutingDone) {
      // Defer until after the PHONE screen has built, otherwise we
      // surface the snackbar against the (about-to-be-disposed) Gate.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Get.snackbar(
          'Subscription cancelled',
          'Your PushtiRanna subscription is no longer active. '
              'Please re-enter your number to resubscribe.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AuthTheme.surface,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 5),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AuthTheme.background,
      body: Center(
        child: CircularProgressIndicator(color: AuthTheme.accent),
      ),
    );
  }
}
