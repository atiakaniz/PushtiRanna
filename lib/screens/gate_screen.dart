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

    // bdapps's `getStatus` proxy returns isSubscribed=false for some users
    // who are clearly registered (geo-restricted upstream — verified by
    // Postman from a different IP). Don't bounce the user to SUBSCRIPTION
    // based on that unreliable answer alone; let SUBSCRIPTION's _sendOtp
    // hit the E1351 path and decide authoritatively from there.
    Get.offAllNamed(AppRoutes.SUBSCRIPTION);
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
