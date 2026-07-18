import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/recipe_data.dart';
import 'models/recipe_model.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';
import 'translations/app_translation.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/phone_auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive — local, offline storage.
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelAdapter());
  await Hive.openBox<RecipeModel>('recipes');
  await Hive.openBox<bool>('favorites');
  await Hive.openBox<String>('settings');

  // Seed recipes on first launch only.
  final recipeBox = Hive.box<RecipeModel>('recipes');
  if (recipeBox.isEmpty) {
    for (final r in RecipeData.recipes) {
      await recipeBox.put(r.id, r);
    }
  }

  // Register controllers once for the whole app (permanent).
  Get.put(FavoriteController(), permanent: true);
  Get.put(PhoneAuthController(), permanent: true);
  runApp(const PushtiRannaApp());
}

class PushtiRannaApp extends StatelessWidget {
  const PushtiRannaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PushtiRanna',

      translations: AppTranslation(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),

      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      initialRoute: AppRoutes.GATE,
      getPages: AppRoutes.routes,
    );
  }
}