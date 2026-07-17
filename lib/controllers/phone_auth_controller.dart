import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Phone-number entry controller.
/// Pure local persistence only — no server / OTP / subscription.
class PhoneAuthController extends GetxController {
  final RxString currentPhone = ''.obs;
  final RxBool isLoading = false.obs;

  /// Persists the chosen phone number locally.
  Future<void> savePhone(String phone) async {
    currentPhone.value = phone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_phone', phone);
  }

  /// Returns the locally-saved phone, or null if none is saved.
  Future<String?> getSavedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final p = prefs.getString('saved_phone');
    currentPhone.value = p ?? '';
    return p;
  }

  /// Removes the saved phone number (e.g. "Edit number" button).
  Future<void> clearSavedPhone() async {
    currentPhone.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_phone');
  }

  /// Normalises to E.164 — Bangladesh assumed if no country code is given.
  String normalizePhone(String input) {
    var p = input.trim().replaceAll(RegExp(r'\s+'), '');
    if (p.startsWith('+')) return p;
    if (p.startsWith('00')) return '+${p.substring(2)}';
    if (p.startsWith('0')) return '+88$p';
    return '+88$p';
  }

  bool isValidPhone(String phone) =>
      RegExp(r'^\+\d{10,15}$').hasMatch(phone);
}
