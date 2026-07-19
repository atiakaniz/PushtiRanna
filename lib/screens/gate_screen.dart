import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';
import '../themes/auth_theme.dart';

/// Decision screen shown right after the splash.
/// - No saved phone number   → PHONE
/// - Saved phone number      → HOME
class GateScreen extends StatefulWidget {
  const GateScreen({super.key});

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  final PhoneAuthController auth = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    final savedPhone = await auth.getSavedPhone();

    if (savedPhone == null || savedPhone.isEmpty) {
      Get.offAllNamed(AppRoutes.PHONE);
      return;
    }

    if (auth.isSubscribed) {
      Get.offAllNamed(AppRoutes.HOME);
      return;
    }

    final subscribed = await auth.checkSubscription();
    if (!mounted) return;

    if (subscribed) {
      await auth.markSubscribed();
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.SUBSCRIPTION);
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
