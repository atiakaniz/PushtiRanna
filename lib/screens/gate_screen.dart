import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/phone_auth_controller.dart';
import '../routes/app_routes.dart';

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
    } else {
      Get.offAllNamed(AppRoutes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5FFF5),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32))),
    );
  }
}
