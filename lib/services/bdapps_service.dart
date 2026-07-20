import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin client around the PushtiRanna bdapps backend
/// (https://pushtiranna.nestorabyatia.xyz). All endpoints accept
/// `application/x-www-form-urlencoded` bodies and return JSON-ish text.
///
/// Network errors and non-2xx responses are surfaced via thrown
/// [BdappsException] so the controller layer can present them to the user.
class BdappsException implements Exception {
  final String message;
  final int? statusCode;
  BdappsException(this.message, {this.statusCode});

  @override
  String toString() => 'BdappsException($statusCode): $message';
}

class BdappsService {
  static const _base = 'https://pushtiranna.nestorabyatia.xyz';
  static const _headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  /// Initiates an OTP send to [mobile].
  /// Expected response: { "statusCode": "200", "referenceNo": "..." }
  static Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final res = await http.post(
      Uri.parse('$_base/send_otp.php'),
      headers: _headers,
      body: {'user_mobile': mobile},
    );
    return _decode(res, 'sendOtp');
  }

  /// Verifies a 6-digit [otp] using [referenceNo] returned from [sendOtp].
  /// Expected response: { "statusCode": "200", "isValid": true }
  static Future<Map<String, dynamic>> verifyOtp(
    String otp,
    String referenceNo,
  ) async {
    final res = await http.post(
      Uri.parse('$_base/verify_otp.php'),
      headers: _headers,
      body: {'Otp': otp, 'referenceNo': referenceNo},
    );
    return _decode(res, 'verifyOtp');
  }

  /// Returns the subscription status for [mobile].
  /// Expected response: `{ "statusCode": "200", "isSubscribed": true }`
  /// or `{ "statusCode": "200", "isSubscribed": false }`.
  static Future<Map<String, dynamic>> checkSubscription(String mobile) async {
    final res = await http.post(
      Uri.parse('$_base/check_subscription.php'),
      headers: _headers,
      body: {'user_mobile': mobile},
    );
    return _decode(res, 'checkSubscription');
  }

  /// Cancels the subscription for [mobile].
  static Future<Map<String, dynamic>> unsubscribe(String mobile) async {
    final res = await http.post(
      Uri.parse('$_base/unsubscribe.php'),
      headers: _headers,
      body: {'user_mobile': mobile},
    );
    return _decode(res, 'unsubscribe');
  }

  // -- helpers ---------------------------------------------------------------

  static Map<String, dynamic> _decode(http.Response res, String op) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw BdappsException(
        '$op failed: HTTP ${res.statusCode}',
        statusCode: res.statusCode,
      );
    }
    final raw = res.body.trim();
    if (raw.isEmpty) return const {};
    Map<String, dynamic> map;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        map = decoded;
      } else {
        return {'value': decoded};
      }
    } on FormatException {
      // Backend returned non-JSON (e.g. an HTML error page) — pass it through.
      return {'raw': raw};
    }

    // IMPORTANT: do NOT throw on business-level codes here. bdapps returns
    // HTTP 200 with `success: false` and a `statusCode` like E1351
    // (already registered) or E1854 (OTP not found). Throwing in those cases
    // makes the controller unable to inspect the payload and react (e.g.
    // auto-route already-subscribed users to HOME). We only throw on
    // genuine transport failures (handled above: non-2xx HTTP).
    return map;
  }
}
