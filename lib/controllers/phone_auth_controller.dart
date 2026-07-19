import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/bdapps_service.dart';

/// Phone-number entry + bdapps subscription controller.
///
/// Phone persistence is local-only (Hive). Subscription/OTP go through the
/// [BdappsService] against `https://pushtiranna.nestorabyatia.xyz`.
class PhoneAuthController extends GetxController {
  static const _boxName = 'settings';
  static const _phoneKey = 'saved_phone';
  static const _subscribedKey = 'is_subscribed';

  final RxString currentPhone = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString lastError = ''.obs;

  /// Returned by `sendOtp` and required by `verifyOtp`.
  final RxnString referenceNo = RxnString();

  Box<String> get _box => Hive.box<String>(_boxName);

  bool get isSubscribed => _box.get(_subscribedKey) == '1';

  Future<void> markSubscribed() async {
    await _box.put(_subscribedKey, '1');
  }

  Future<void> markUnsubscribed() async {
    await _box.delete(_subscribedKey);
  }

  // -- local persistence -----------------------------------------------------

  Future<void> savePhone(String phone) async {
    currentPhone.value = phone;
    await _box.put(_phoneKey, phone);
  }

  Future<String?> getSavedPhone() async {
    final p = _box.get(_phoneKey);
    currentPhone.value = p ?? '';
    return p;
  }

  Future<void> clearSavedPhone() async {
    currentPhone.value = '';
    referenceNo.value = null;
    await _box.delete(_phoneKey);
  }

  /// Strip spaces, dashes, parentheses; ensure E.164 `+<digits>` shape.
  String normalizePhone(String input) {
    var p = input.trim();
    p = p.replaceAll(RegExp(r'[\s\-()]'), '');
    if (p.startsWith('+')) return p;
    if (p.startsWith('00')) return '+${p.substring(2)}';
    if (p.startsWith('0')) return '+88$p';
    return '+88$p';
  }

  /// True if the phone looks like E.164 (e.g. +8801834268008).
  /// Allows 8–15 digits after the `+` so partial-typed numbers don't crash
  /// but still rejects obviously invalid input.
  bool isValidPhone(String phone) =>
      RegExp(r'^\+\d{8,15}$').hasMatch(phone);

  // -- bdapps API ------------------------------------------------------------

  /// bdapps expects E.164 *without* the `+` sign:
  /// e.g. `8801834268008` instead of `+8801834268008`.
  String _forApi(String phone) =>
      phone.startsWith('+') ? phone.substring(1) : phone;

  /// `true` if the user is subscribed on the server.
  Future<bool> checkSubscription() async {
    final phone = currentPhone.value;
    if (phone.isEmpty) return false;
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.checkSubscription(_forApi(phone));
      final v = data['isSubscribed'];
      return v == true || v == 'true';
    } on BdappsException catch (e) {
      lastError.value = e.message;
      return false;
    } catch (e) {
      lastError.value = 'Could not check subscription: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sends a 6-digit OTP. Stores the `referenceNo` for the next step.
  Future<bool> sendOtp() async {
    final phone = currentPhone.value;
    if (phone.isEmpty) {
      lastError.value = 'No phone number saved';
      return false;
    }
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.sendOtp(_forApi(phone));
      final ref = data['referenceNo']?.toString();
      if (ref == null || ref.isEmpty) {
        lastError.value = 'No reference number returned';
        return false;
      }
      referenceNo.value = ref;
      return true;
    } on BdappsException catch (e) {
      lastError.value = e.message;
      return false;
    } catch (e) {
      lastError.value = 'Could not send OTP: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies [otp] using the stored reference number.
  Future<bool> verifyOtp(String otp) async {
    final ref = referenceNo.value;
    if (ref == null) {
      lastError.value = 'No OTP request in progress';
      return false;
    }
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.verifyOtp(otp, ref);
      debugPrint('[PhoneAuth] verifyOtp response: $data');
      final ok = data['isValid'] == true || data['isValid'] == 'true';
      if (ok) {
        await markSubscribed();
        return true;
      }
      // Server didn't flag the OTP invalid (e.g. statusCode 200 but no
      // isValid field). Surface whatever detail it gave us so the user can
      // see *why* it didn't accept the code.
      final detail = (data['statusDetail'] ??
              data['message'] ??
              data['statusCode'] ??
              'Server did not confirm the OTP')
          .toString();
      lastError.value = 'OTP not accepted: $detail';
      return false;
    } on BdappsException catch (e) {
      debugPrint('[PhoneAuth] verifyOtp BdappsException: ${e.message}');
      lastError.value = e.message;
      return false;
    } catch (e, st) {
      debugPrint('[PhoneAuth] verifyOtp caught: $e\n$st');
      lastError.value = 'Could not verify OTP: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> unsubscribe() async {
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.unsubscribe(_forApi(currentPhone.value));
      return data['statusCode']?.toString() == '200' ||
          data['status']?.toString().toLowerCase() == 'ok';
    } on BdappsException catch (e) {
      lastError.value = e.message;
      return false;
    } catch (e) {
      lastError.value = 'Could not unsubscribe: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    currentPhone.value = _box.get(_phoneKey) ?? '';
  }
}
