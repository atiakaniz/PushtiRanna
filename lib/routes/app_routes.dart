import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_gate_controller.dart';
import '../models/recipe_model.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/phone_screen.dart';
import '../screens/gate_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/admin_recipes_screen.dart';
import '../screens/recipe_editor_screen.dart';

class AppRoutes {
  static const WELCOME = '/welcome';
  static const HOME = '/home';
  static const DETAIL = '/detail';
  static const FAVORITE = '/favorite';
  static const SETTINGS = '/settings';

  static const GATE = '/gate';
  static const PHONE = '/phone';
  static const SUBSCRIPTION = '/subscription';

  static const ADMIN_RECIPES = '/admin/recipes';
  static const RECIPE_EDITOR = '/admin/recipe-editor';

  static final routes = [
    GetPage(name: WELCOME, page: () => const WelcomeScreen()),
    GetPage(name: GATE, page: () => const GateScreen()),
    GetPage(name: PHONE, page: () => const PhoneScreen()),
    GetPage(name: SUBSCRIPTION, page: () => const SubscriptionScreen()),
    GetPage(name: HOME, page: () => HomeScreen()),
    GetPage(
      name: DETAIL,
      page: () {
        // Pull the recipe out of Get.arguments if a caller used the
        // arguments: ... form. The recipe is required.
        final arg = Get.arguments;
        if (arg is RecipeModel) return DetailScreen(recipe: arg);
        return const _MissingRecipeScreen();
      },
    ),
    GetPage(name: FAVORITE, page: () => const FavoriteScreen()),
    GetPage(name: SETTINGS, page: () => const SettingsScreen()),
    GetPage(
      name: ADMIN_RECIPES,
      page: () {
        // End users should never reach this route — long-pressing the
        // hidden version label in Settings unlocks the gate first. If
        // they still try (deep link, hot reload, etc.), bounce them.
        final gate = Get.isRegistered<AdminGateController>()
            ? Get.find<AdminGateController>()
            : null;
        if (gate != null && gate.isAdmin.value) {
          return const AdminRecipesScreen();
        }
        return const _LockedScreen();
      },
    ),
    GetPage(
      name: RECIPE_EDITOR,
      page: () {
        final gate = Get.isRegistered<AdminGateController>()
            ? Get.find<AdminGateController>()
            : null;
        if (gate != null && gate.isAdmin.value) {
          return const RecipeEditorScreen();
        }
        return const _LockedScreen();
      },
    ),
  ];
}

/// Shown when someone navigates to /admin/recipes or /admin/recipe-editor
/// without unlocking the gate. Visually distinct so it's obvious something
/// is off, but it never reveals that an admin surface exists.
class _LockedScreen extends StatelessWidget {
  const _LockedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not available')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'This section is not available.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Shown if the user reaches /detail without a recipe argument — e.g. via a
/// deep link. Kept inside the routes file so it's co-located with the only
/// route that needs it.
class _MissingRecipeScreen extends StatelessWidget {
  const _MissingRecipeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No recipe was selected. Please open a recipe from the home '
            'screen.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}