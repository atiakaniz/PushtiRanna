import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Gates the recipe-admin screens behind a secret unlock so end users
/// never see them. The PIN is injected at build time via
/// `--dart-define=ADMIN_PIN=xxxx`; if no PIN is defined, the controller
/// falls back to a default owner PIN baked into the source.
class AdminGateController extends GetxController {
  static const _pinFlagKey = 'admin_unlocked';
  static const _boxName = 'settings';

  /// Default owner PIN baked into the source. Used only when the build
  /// does not override it with `--dart-define=ADMIN_PIN=...`.
  /// Override at build time to rotate without touching this file.
  ///
  /// NOTE: any default baked into source is technically readable by
  /// anyone who decompiles the APK. To rotate without touching this
  /// file, build with `--dart-define=ADMIN_PIN=your-pin` and omit the
  /// default here.
  static const String _defaultPin = 'Atia_147258';

  /// PIN injected at build time, or the source default if none.
  static const String _buildPin = String.fromEnvironment(
    'ADMIN_PIN',
    defaultValue: _defaultPin,
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
  ///
  /// Comparison is lenient about surrounding whitespace and common
  /// substitutions the soft keyboard or autocorrect can sneak in
  /// (zero-width spaces, smart quotes, full-width digits).
  bool verifyPin(String input) {
    if (_buildPin.isEmpty) return false;
    String _normalize(String s) {
      var out = s.trim();
      // Strip zero-width characters that copy/paste occasionally carries.
      out = out.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
      // Map a few look-alike substitutions back to their ASCII forms.
      const substitutions = <String, String>{
        '\u2018': "'", '\u2019': "'", '\u201C': '"', '\u201D': '"',
        '\uFF10': '0', '\uFF11': '1', '\uFF12': '2', '\uFF13': '3',
        '\uFF14': '4', '\uFF15': '5', '\uFF16': '6', '\uFF17': '7',
        '\uFF18': '8', '\uFF19': '9',
      };
      substitutions.forEach((from, to) {
        out = out.replaceAll(from, to);
      });
      return out;
    }
    return _normalize(input) == _normalize(_buildPin);
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