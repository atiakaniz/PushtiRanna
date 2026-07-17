import 'package:get/get.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/phone_screen.dart';
import '../screens/gate_screen.dart';

class AppRoutes {
  static const WELCOME = '/welcome';
  static const HOME = '/home';
  static const DETAIL = '/detail';
  static const FAVORITE = '/favorite';
  static const SETTINGS = '/settings';

  static const GATE = '/gate';
  static const PHONE = '/phone';

  static final routes = [
    GetPage(name: WELCOME, page: () => const WelcomeScreen()),
    GetPage(name: GATE, page: () => const GateScreen()),
    GetPage(name: PHONE, page: () => const PhoneScreen()),
    GetPage(name: HOME, page: () => HomeScreen()),
    GetPage(name: DETAIL, page: () => const DetailScreen()),
    GetPage(name: FAVORITE, page: () => const FavoriteScreen()),
    GetPage(name: SETTINGS, page: () => const SettingsScreen()),
  ];
}