import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Phone-number entry controller.
/// Pure local persistence via Hive — no server / OTP / subscription.
class PhoneAuthController extends GetxController {
  static const _boxName = 'settings';
  static const _phoneKey = 'saved_phone';

  final RxString currentPhone = ''.obs;
  final RxBool isLoading = false.obs;

  Box<String> get _box => Hive.box<String>(_boxName);

  /// Persists the chosen phone number locally.
  Future<void> savePhone(String phone) async {
    currentPhone.value = phone;
    await _box.put(_phoneKey, phone);
  }

  /// Returns the locally-saved phone, or null if none is saved.
  Future<String?> getSavedPhone() async {
    final p = _box.get(_phoneKey);
    currentPhone.value = p ?? '';
    return p;
  }

  /// Removes the saved phone number (e.g. "Edit number" button).
  Future<void> clearSavedPhone() async {
    currentPhone.value = '';
    await _box.delete(_phoneKey);
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

  @override
  void onInit() {
    super.onInit();
    currentPhone.value = _box.get(_phoneKey) ?? '';
  }
}
