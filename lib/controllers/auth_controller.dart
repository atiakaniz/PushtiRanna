import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'phone_auth_controller.dart';

/// Auth controller for the phone-only flow.
///   signInWithPhone()    – reads the saved phone; if missing, goes to PHONE
///   logout()             – clears the saved phone and goes to PHONE
class AuthController extends GetxController {
  final PhoneAuthController phone = Get.find();

  /// Returns true if a phone number is already saved locally.
  Future<bool> isSignedIn() async {
    final saved = await phone.getSavedPhone();
    return saved != null && saved.isNotEmpty;
  }

  /// Routes the user to HOME if a phone is saved, otherwise to PHONE.
  void routeFromGate() {
    final saved = phone.currentPhone.value;
    if (saved.isEmpty) {
      Get.offAllNamed(AppRoutes.PHONE);
    } else {
      Get.offAllNamed(AppRoutes.HOME);
    }
  }

  Future<void> logout() async {
    await phone.clearSavedPhone();
    Get.offAllNamed(AppRoutes.PHONE);
  }
}
