import 'package:flutter/material.dart';

/// Shared look-and-feel for the dark + cyan auth/onboarding screens
/// (PhoneScreen, SubscriptionScreen, GateScreen).
class AuthTheme {
  AuthTheme._();

  // Background
  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1C24);

  // Accent (the cyan used in the screenshots)
  static const Color accent = Color(0xFF1FE5C5);
  static const Color accentDark = Color(0xFF12B89E);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB6BCC9);
  static const Color textMuted = Color(0xFF7A8090);
  static const Color error = Color(0xFFFF6B6B);

  // Borders
  static const Color border = Color(0xFF2A2D38);
  static const Color borderFocused = accent;

  /// Pill-style CTA used by Continue / Verify / Send OTP buttons.
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accent,
    foregroundColor: Color(0xFF06231E),
    disabledBackgroundColor: Color(0x331FE5C5),
    disabledForegroundColor: Color(0x9906231E),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static const TextStyle screenTitle = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle screenSubtitle = TextStyle(
    color: textSecondary,
    fontSize: 14,
    height: 1.4,
  );

  static const TextStyle linkMuted = TextStyle(
    color: textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
