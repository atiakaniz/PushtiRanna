import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Gates the recipe-admin screens behind a secret unlock so end users
/// never see them. The PIN is injected at build time via
/// `--dart-define=ADMIN_PIN=xxxx`; if no PIN is defined, the controller
/// refuses every attempt (fail-closed).
class AdminGateController extends GetxController {
  static const _pinFlagKey = 'admin_unlocked';
  static const _boxName = 'settings';

  /// PIN injected at build time. Falls back to a non-empty string so the
  /// comparison still works, but no match is possible unless the build
  /// defines `ADMIN_PIN`.
  static const String _buildPin = String.fromEnvironment(
    'ADMIN_PIN',
    defaultValue: '',
  );

  final RxBool isAdmin = false.obs;

  Box<String> get _box => Hive.box<String>(_boxName);

  @override
  void onInit() {
    super.onInit();
    isAdmin.value = _box.get(_pinFlagKey) == 'true';
  }

  /// Returns true if the supplied PIN matches the build-time PIN.
  /// No-op (returns false) when no PIN has been configured.
  bool verifyPin(String input) {
    if (_buildPin.isEmpty) return false;
    return input.trim() == _buildPin;
  }

  Future<void> unlock(String pin) async {
    if (!verifyPin(pin)) {
      isAdmin.value = false;
      await _box.delete(_pinFlagKey);
      return;
    }
    isAdmin.value = true;
    await _box.put(_pinFlagKey, 'true');
  }

  Future<void> lock() async {
    isAdmin.value = false;
    await _box.delete(_pinFlagKey);
  }

  /// Compile-time helper for the UI: tells you whether a PIN has been
  /// baked into this build. Useful for showing a hint in the unlock
  /// dialog.
  static bool get hasConfiguredPin => _buildPin.isNotEmpty;
}