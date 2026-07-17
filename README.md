# PushtiRanna 🍲

> A Bengali-first healthy recipe app built with Flutter — discover balanced meals, mark favorites, and switch between English and বাংলা.

PushtiRanna ("nutritious food" in Bangla) is a mobile-first recipe companion focused on Bengali cuisine with a healthy twist. The app keeps the experience lightweight: no account creation, no backend calls — just open the app, drop in your phone number once, and start cooking.

---

## ✨ Features

- 📱 **Phone-number gate** — one-time local sign-in (no server, no OTP).
- 🍱 **Recipe library** — 50+ Bengali recipes with images, ingredients, and steps.
- ❤️ **Favorites** — bookmark recipes you love; persisted with `SharedPreferences`.
- 🌐 **Bilingual UI** — full English + বাংলা translations.
- ⚙️ **Settings** — language switcher, share app, logout.
- 🎞️ **Lottie animations** — splash and empty-state visuals.

---

## 🛠️ Tech Stack

| Layer | Tool |
|-------|------|
| Framework | Flutter (Dart `>=3.0.0 <4.0.0`) |
| State management | [GetX](https://pub.dev/packages/get) (`get: ^4.7.3`) |
| Local storage | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Fonts | [google_fonts](https://pub.dev/packages/google_fonts) |
| Animations | [lottie](https://pub.dev/packages/lottie) |
| Sharing | [share_plus](https://pub.dev/packages/share_plus) |
| i18n | [intl](https://pub.dev/packages/intl) |
| Icons | [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) (dev) |

> ℹ️ Earlier versions used Firebase Auth + a Node backend. Those have been **removed** — the app is fully offline now.

---

## 🗂️ Project Structure

```
lib/
├── main.dart                  # App entry; registers permanent GetX controllers
├── bindings/app_binding.dart  # Dependency injection wiring
├── controllers/
│   ├── auth_controller.dart       # Gate routing + logout
│   ├── favorite_controller.dart   # Favorites persistence
│   └── phone_auth_controller.dart # Phone-number persistence (local only)
├── data/recipe_data.dart      # Recipe model + seed list
├── routes/app_routes.dart     # Named route definitions
├── screens/
│   ├── welcome_screen.dart    # Splash / entry
│   ├── gate_screen.dart       # Routes user → phone or home
│   ├── phone_screen.dart      # Phone input (one-time)
│   ├── home_screen.dart       # Recipe list + drawer
│   ├── detail_screen.dart     # Recipe detail
│   ├── favorite_screen.dart   # Saved recipes
│   └── settings_screen.dart   # Language + share + logout
├── themes/                    # Colors, text styles
├── translations/              # English & Bengali strings
└── widgets/                   # Reusable UI components

assets/
├── images/   # Recipe photos
├── animations/food.json       # Lottie splash
└── icon/app_icon.jpg
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x (Dart `>=3.0.0 <4.0.0`)
- Android Studio / Xcode (for mobile builds)
- A connected device or emulator

### Install & run
```bash
flutter pub get
flutter run
```

### Build a release APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

For signed production builds, configure `android/key.properties` and reference it from `android/app/build.gradle.kts`.

---

## 🔐 How Auth Works (Phone-Only)

1. App launches → `WelcomeScreen`.
2. `GateScreen` checks `SharedPreferences` for a saved phone number.
3. If absent → `PhoneScreen` collects a `+8801XXXXXXXXX` number, normalizes it, saves it locally.
4. If present → straight to `HomeScreen`.
5. Settings → Logout clears the saved number and returns to `GateScreen`.

No data leaves the device. No server round-trip. No OTP.

---

## 🌐 Deployment (cPanel)

The APK can be hosted on any static-capable web host. Recommended layout on cPanel:

```
public_html/
└── pushtiranna/
    ├── index.html        # Landing page with Download button
    └── app.apk           # The signed release APK
```

Download URL becomes:
```
https://pushtiranna.nestorabyatia.xyz/pushtiranna/app.apk
```

Enable AutoSSL in cPanel for HTTPS, and ensure the `.apk` MIME type is set to `application/vnd.android.package-archive`.

---

## 🧰 Useful Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run on connected device
flutter analyze          # Static analysis
flutter build apk        # Debug APK
flutter build apk --release   # Release APK
flutter build appbundle  # Android App Bundle (for Play Store)
flutter clean            # Clear build artifacts
```

---

## 📦 Versioning

Current: `1.0.0+2` (defined in `pubspec.yaml`). Use semantic versioning for user-facing releases.

---

## 📄 License

This project is private. All rights reserved by the author.

---

## 🙌 Acknowledgements

- Bengali recipe inspiration from traditional home cooking.
- Flutter & Dart teams for the awesome framework.
- The open-source package authors listed in `pubspec.yaml`.
